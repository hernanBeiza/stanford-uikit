//
//  MemoryGame.swift
//  Memorize
//
//  Created by Hernán Beiza on 20-02-21.
//

import Foundation

//Se debe declarar que se usa un Don't care type
struct MemoryGame <CardContent> {
    var cards:Array <Card>
    
    init(numbersOfPairsOfCards:Int, cardContentFactory:(Int) -> CardContent) {
        cards = Array<Card>();
        for pairIndex in 0..<numbersOfPairsOfCards {
            let content = cardContentFactory(pairIndex);
            cards.append(Card(id:pairIndex*2, isFaceUp:false, isMatched:false, content: content));
            cards.append(Card(id:pairIndex*2+1, isFaceUp:false, isMatched:false, content: content));
        }
    }
    
    func choose (card:Card) -> Void {
        print("Card choosen: \(card)")
    }
    
    //Nesting Struct, struct inside struct. Pasar usar MemoryGame.Card
    //@Protocol
    struct Card: Identifiable {
        var id: Int;
        var isFaceUp: Bool;
        var isMatched: Bool;
        //var content: String;
        var content: CardContent; //Don't care type
    }
    
}
