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
    
    var body: some View {
        VStack {
            ScrollView(.horizontal){
                HStack {
                    //Usar una variable como id. Usar el mismo objeto como identificador
                    ForEach (EmojiArtDocument.palette.map { String($0) }, id: \.self ) { emoji in
                        Text(emoji)
                            .font(Font.system(size: defaultEmojiSize))
                            .onDrag { NSItemProvider(object: emoji as NSString) }
                    }
                }
            }
            .padding(.horizontal)
            GeometryReader { geometry in
                ZStack {
                    //Usar el espacio de Rectangle, no agregar otra vista, overlay o background
                    //No se pueden hacer if en algo que no sean ViewBuilders
                    Color.white.overlay(
                        Group {
                            if self.document.backgroundImage != nil {
                                Image(uiImage:self.document.backgroundImage!)
                            }
                        }
                    )
                    .edgesIgnoringSafeArea([.horizontal,.bottom])
                    .onDrop(of: ["public.image", "public.text"], isTargeted:nil) { providers, location in
                        print("location \(location)");
                        var location = geometry.convert(location,from: .global)
                        location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                        // public.image, es el tipo de lo que queremos dropear
                        // isTargeted,
                        // clousure
                        // providers, toda la data de quien provee lo dropeado
                        // location, la posición del área de drop
                        return self.drop(providers:providers, at:location);
                    }
                    ForEach(self.document.emojis) { emoji in
                        Text(emoji.text)
                            .font(self.font(for: emoji))
                            .position(self.position(for: emoji, in: geometry.size))
                    }
                }
            }
        }
    }
    
    private func drop(providers: [NSItemProvider], at location:CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped \(url)");
            self.document.setBackgroundURL(url)
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size:self.defaultEmojiSize)
            }
        }
        return found;
    }
    
    private func font(for emoji:EmojiArt.Emoji) -> Font {
        Font.system(size: emoji.fontSize)
    }
    
    private func position(for emoji:EmojiArt.Emoji, in size:CGSize) -> CGPoint {
        CGPoint (x:emoji.location.x + size.width / 2, y: emoji.location.y + size.height / 2)
        
    }
    
    private let defaultEmojiSize : CGFloat = 40;
    
}

