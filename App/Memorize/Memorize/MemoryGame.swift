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
    
    mutating func choose (card:Card) -> Void {
        print("Card choosen: \(card)")
        let chosenIndex: Int = self.index(of:card);
        // No se puede cambiar el valor de esta manera
        /*
        let card = self.cards[chosenIndex];
        card.isFaceUp = !card.isFaceUp
        */
        //Implementar reactive UI
        //Todas las funciones que modifican algo dentro de un struct, hay que marcarlas que son mutables
        self.cards[chosenIndex].isFaceUp = !self.cards[chosenIndex].isFaceUp;
    }
    //External an internal names in Swift
    //of es el nombre externo
    //card es el nombre interno
    func index(of card:Card) -> Int {
        for index in 0..<self.cards.count {
            if self.cards[index].id == card.id{
                return index
            }
        }
        // TODO: Corregir
        return 0;
    }
    //Nesting Struct, struct inside struct. Pasar usar MemoryGame.Card
    //Cada vez que se pasa un ValueType, es copiada cada vez que se pasa como parámetro
    //@Protocol
    struct Card: Identifiable {
        var id: Int;
        var isFaceUp: Bool;
        var isMatched: Bool;
        //var content: String;
        var content: CardContent; //Don't care type
    }
    
}
