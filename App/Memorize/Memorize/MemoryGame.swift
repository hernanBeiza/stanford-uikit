//
//  MemoryGame.swift
//  Memorize
//
//  Created by Hernán Beiza on 20-02-21.
//

import Foundation

//Se debe declarar que se usa un Don't care type
// Para poder usar el protocolo que permite comparar
struct MemoryGame <CardContent> where CardContent: Equatable {
    var cards:Array <Card>
    //Optional es nil si no se inicializa con un valor
    //Computed var
    var indexOfTheOnlyAndOnlyFaceUpCard:Int? {
        get {
            //Array de Ints
            /*
            var faceUpCardIndices = [Int]();
            for index in cards.indices {
                faceUpCardIndices.append(index);
            }
            if faceUpCardIndices.count == 1 {
                return faceUpCardIndices.first;
            } else {
                return nil;
            }
            */
            let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp }
            //Extension de Arrays
            return faceUpCardIndices.only;
        }
        set {
            for index in cards.indices {
                //newValue es el valor que tomará laa variable computada
                /*
                if index == newValue {
                    cards[index].isFaceUp = true;
                } else {
                    cards[index].isFaceUp = false;
                }
                */
                cards[index].isFaceUp = index == newValue;
            }
        }
    }
    
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
        // Unwrapping optional
        // Coma es un secuancial AND, no se usa && cuando se está unwrapping un optional
        if let chosenIndex: Int = self.cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOnlyAndOnlyFaceUpCard {
                // Card.content puede ser cualquier cosa, es a Generic, Don't care type
                // == en Swift usa funciones para poder comparar que recibe dos parámetros
                // Pero no todos los tipos se pueden comparar con ==
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true;
                    cards[potentialMatchIndex].isMatched = true;
                }
            } else {
                indexOfTheOnlyAndOnlyFaceUpCard = chosenIndex;
            }
        }
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
