//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Hernán Beiza on 02-03-21.
//

// Modelo de Documento

import SwiftUI

class EmojiArtDocument: ObservableObject {
    
    static let palette: String = "🚌🦠😎🏵🎹";

    //Gatillar redibujar de la vista cada vez que cambia
    @Published private var emojiArt:EmojiArt = EmojiArt();

    //Gatillar redibujar de la vista cada vez que se obtiene la imagen
    @Published private(set) var backgroundImage: UIImage?;

    //Variable computada para obtener los valores de este modelo
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    // MARK: Intent(s)
    func addEmoji(_ emoji:String, at location: CGPoint, size:CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size:Int(size))
    }
    
    func moveEmoji(_ emoji:EmojiArt.Emoji, by offset:CGSize){
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji:EmojiArt.Emoji, by scale: CGFloat){
        if let index = emojiArt.emojis.firstIndex(matching: emoji){
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    func setBackgroundURL (_ url:URL?){
        //De la extensión para obtener la url de la imagen
        emojiArt.backgroundUrl = url?.imageURL;
        fetchBackgroundImageData()
    }
    
    private func fetchBackgroundImageData(){
        backgroundImage = nil
        //Provide some UI hint, loading progressbar
        if let url = self.emojiArt.backgroundUrl {
            // Obtener la URL desde el background thread
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    // Avisar a la UI que se debe actualizar
                    // Pasar data al main thread, UI
                    DispatchQueue.main.async {
                        if url == self.emojiArt.backgroundUrl {
                            self.backgroundImage = UIImage(data: imageData);
                        }
                    }
                }
            }
        }
    }
    
}

extension EmojiArt.Emoji {
    var fontSize:CGFloat { CGFloat(self.size) }
    var location:CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
