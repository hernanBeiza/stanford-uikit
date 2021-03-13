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
    
    @State private var chosenPalette: String = "";
    
    init(document: EmojiArtDocument){
        self.document = document;
        //No se puede hacer esto
        //self.chosenPalette = self.document.defaultPalette;
        //Una forma de inicializar un State, en un método init
        _chosenPalette = State(wrappedValue: self.document.defaultPalette);
    }
    
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
                .navigationBarItems(trailing: Button(action: {
                    // Obtener valor copiado en el pasteboard
                    if let url = UIPasteboard.general.url, url != self.document.backgroundURL {
                        self.confirmBackgroundPaste = true;
                    } else {
                        self.explainBackgroundPaste = true;
                    }
                }, label: {
                    Image(systemName: "doc.on.clipboard").imageScale(.large)
                        .alert(isPresented: self.$explainBackgroundPaste){
                            return Alert(
                                title: Text("Paste background"),
                                 message: Text("Copy the URL of an image to the clip board and tocuh this button to make it the background of your document."),
                                 dismissButton: .default(Text("Ok"))
                            )
                        }
                } ))
            }
            //Todas las vistas de arriba, se quedarán bajo
            .zIndex(-1)
        }
        // NO se pueden poner dos alertas en el mismo elemento
        .alert(isPresented: self.$confirmBackgroundPaste){
            return Alert(
                title: Text("Paste background"),
                message: Text("Replace your background with \(UIPasteboard.general.url?.absoluteString ?? "nothing")?."),
                primaryButton: .default(Text("Ok")) {
                    self.document.backgroundURL = UIPasteboard.general.url
                },
                secondaryButton: .cancel()
            )
        }

    }
    
    @State private var explainBackgroundPaste = false;
    @State private var confirmBackgroundPaste = false;
    
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
    // Puede ser de cualquier tipo
    @GestureState private var gestureZoomScale:CGFloat = 1.0;
    
    private var zoomScale : CGFloat {
        self.document.steadyStateZoomScale * gestureZoomScale;
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
                self.document.steadyStateZoomScale *= finalGestureScale
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
        if let image = image, image.size.width>0, image.size.height>0, size.height>0, size.width>0 {
            let hZoom = size.width / image.size.width;
            let vZoom = size.height / image.size.height;
            self.document.steadyStatePanOffset = .zero;
            self.document.steadyStateZoomScale = min(hZoom,vZoom);
        }
    }
    
    //Paneo
    @GestureState private var gesturePanOffset:CGSize = .zero;
    
    private var panOffset : CGSize {
        return (self.document.steadyStatePanOffset + gesturePanOffset) * zoomScale;
    }

    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transaction in
                gesturePanOffset = latestDragGestureValue.translation / self.zoomScale
            }
            .onEnded { finalDragGestureValue in
                self.document.steadyStatePanOffset = self.document.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)
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
