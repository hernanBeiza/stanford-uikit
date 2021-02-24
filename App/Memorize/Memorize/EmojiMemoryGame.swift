//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Hernán Beiza on 20-02-21.
//

import Foundation

// Es una clase porque es data que quiero compartir
// Usa punteros
// Copiar data
class EmojiMemoryGame {
    //private (set) var model:MemoryGame<String>;
    //Inline function, closures: Captura cosas
    /*
    private var model:MemoryGame<String> = MemoryGame<String>(numbersOfPairsOfCards:2, cardContentFactory: { (pairIndex: Int) -> String in
        return "🧐";
    });
     */
    //Lo mismo de arriba
    private var model:MemoryGame<String> = EmojiMemoryGame.createMemoryGame();
    
    static func createMemoryGame() -> MemoryGame <String> {
        let emojis:Array<String> = ["🧐","🤨","😎"];    
        return MemoryGame<String>(numbersOfPairsOfCards:emojis.count) { pairIndex in return emojis[pairIndex]; };
    }

    // MARK: - Access to the Model
    var cards:Array<MemoryGame<String>.Card> {
        return model.cards;
        //Como es una función de una sóla línea y retorna algo, se podría sacar el return
    }
        
    // MARK: - Intents(s)
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card);
    }
    
}
