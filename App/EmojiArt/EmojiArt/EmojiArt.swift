//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Hernán Beiza on 02-03-21.
//

import Foundation

struct EmojiArt {
    //Es optional porque el modelo se instancia sin fondo
    var backgroundUrl:URL?
    var emojis = [Emoji]();

    //Modelo para los emoji
    //Solo EmojiArt sabrá acerca del id de Emoji
    struct Emoji: Identifiable {
        //Nunca se podrá cambiar el emoji
        let text:String
        var x:Int   //from center
        var y:Int   //from center
        var size:Int
        //Very unique identifier
        let id:Int
        
        //file private transforma init en privado pero se puede usar libremente en ese archivo
        fileprivate init (text:String, x: Int, y:Int, size:Int, id: Int){
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
        
    }
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text:String, x: Int, y:Int, size:Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId))
    }
    

}
