//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Hernán Beiza on 02-03-21.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    // Modelo de Documento
    @ObservedObject var document:EmojiArtDocument;
    @State var chosenPalette: String = "";
    
    var body: some View {
        VStack {
            HStack {
                //Se pasa el valor proyectado de chosenPaleete
                PaletteChooser(document:self.document, chosenPalette: $chosenPalette)
                ScrollView(.horizontal){
                    HStack {
                        //Usar una variable como id. Usar el mismo objeto como identificador
                        ForEach (chosenPalette.map { String($0) }, id: \.self ) { emoji in
                            Text(emoji)
                                .font(Font.system(size: defaultEmojiSize))
                                .onDrag { NSItemProvider(object: emoji as NSString) }
                        }
                    }
                }
                .onAppear{ self.chosenPalette = self.document.defaultPalette }
            }
            GeometryReader { geometry in
                ZStack {
                    //Usar el espacio de Rectangle, no agregar otra vista, overlay o background
                    //No se pueden hacer if en algo que no sean ViewBuilders
                    Color.white.overlay(
                        OptionalImage(uiImage: document.backgroundImage)
                            .scaleEffect(self.zoomScale)
                            .offset(self.panOffset)
                    )
                    .gesture(self.doubleTapToZoom(in: geometry.size))
                    if self.isLoading {
                        Image(systemName:"hourglass").imageScale(.large).spinning()
                    } else {
                        ForEach(self.document.emojis) { emoji in
                            Text(emoji.text)
                                .font(animatableWithSize: emoji.fontSize * zoomScale)
                                .position(self.position(for: emoji, in: geometry.size))
                        }
                    }
                }
                .clipped()
                .gesture(self.panGesture())
                .gesture(self.zoomGesture())
                .edgesIgnoringSafeArea([.horizontal,.bottom])
                //onReceive permite recibir el valor publicado por @Publisher, es la subscription
                .onReceive(self.document.$backgroundImage) { image in
                    self.zoomToFit(image, in: geometry.size)
                }
                .onDrop(of: ["public.image", "public.text"], isTargeted:nil) { providers, location in
                    print("location \(location)");
                    var location = geometry.convert(location,from: .global)
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    //Corregir sistema de coordenadas según el zoom
                    location = CGPoint(x: location.x / self.zoomScale, y: location.y / self.zoomScale)
                    //Corrección paneo
                    location = CGPoint(x: location.x - self.panOffset.width, y: location.y - self.panOffset.height)
                    // public.image, es el tipo de lo que queremos dropear
                    // isTargeted,
                    // clousure
                    // providers, toda la data de quien provee lo dropeado
                    // location, la posición del área de drop
                    return self.drop(providers:providers, at:location);
                }

            }
        }
    }
    
    private func drop(providers: [NSItemProvider], at location:CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped \(url)");
            self.document.backgroundURL = url;
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size:self.defaultEmojiSize)
            }
        }
        return found;
    }
    
    var isLoading : Bool {
        document.backgroundURL != nil && document.backgroundImage == nil;
    }
    //Temporal
    @State private var steadyStateZoomScale:CGFloat = 1.0;
    // Puede ser de cualquier tipo
    @GestureState private var gestureZoomScale:CGFloat = 1.0;
    
    private var zoomScale : CGFloat {
        steadyStateZoomScale * gestureZoomScale;
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            //Constantemente llamada mientras cambia el estado
            .updating($gestureZoomScale) { latestGestureScale, ourGestureStateInOut, transaction in
                //Recibe la variable y la copia de vuelta
                //Pasar la misma variable de estado, modificarla, y pasarla de vuelta
                //ourGestureStateInOut es gestureZoomScale
                //Se maneja así porque un GestureState no debe ser manejado directamente, debe ser a través de la variable InOut
                ourGestureStateInOut = latestGestureScale
            }
            .onEnded { finalGestureScale in
                self.steadyStateZoomScale *= finalGestureScale
            }
    }
        
    private func doubleTapToZoom(in size:CGSize) -> some Gesture {
        TapGesture(count: 2).onEnded {
            withAnimation {
                self.zoomToFit(document.backgroundImage, in: size)
            }
        }
    }
    
    private func zoomToFit(_ image:UIImage?, in size: CGSize){
        if let image = image, image.size.width>0, image.size.height>0 {
            let hZoom = size.width / image.size.width;
            let vZoom = size.height / image.size.height;
            self.steadyStatePanOffset = .zero;
            self.steadyStateZoomScale = min(hZoom,vZoom);
        }
    }
    
    //Paneo
    @State private var steadyStatePanOffset: CGSize = .zero;
    @GestureState private var gesturePanOffset:CGSize = .zero;
    
    private var panOffset : CGSize {
        return (steadyStatePanOffset + gesturePanOffset) * zoomScale;
    }

    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transaction in
                gesturePanOffset = latestDragGestureValue.translation / self.zoomScale
            }
            .onEnded { finalDragGestureValue in
                self.steadyStatePanOffset = self.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)
            }
    }
   
                
    private func font(for emoji:EmojiArt.Emoji) -> Font {
        Font.system(size: emoji.fontSize * zoomScale)
    }
    
    private func position(for emoji:EmojiArt.Emoji, in size:CGSize) -> CGPoint {
        var location = emoji.location
        // Corrección de posición según zoom
        location = CGPoint(x: location.x * self.zoomScale, y: location.y * self.zoomScale)

        location = CGPoint (x: location.x + size.width / 2, y: location.y + size.height / 2)
        // Corrección panel
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        return location
    }
    
    private let defaultEmojiSize : CGFloat = 40;
    
}
