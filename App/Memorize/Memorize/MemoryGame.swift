//
//  MemoryGame.swift
//  Memorize
//
//  Created by Hernán Beiza on 20-02-21.
//

import Foundation

// Se debe declarar que se usa un Don't care type
// Para poder usar el protocolo que permite comparar, donde CardContent implementa el protocolo Equatable
struct MemoryGame <CardContent> where CardContent: Equatable {
    //Access Control
    //Setting es private, getting no
    private(set) var cards:Array <Card>
    //Optional es nil si no se inicializa con un valor
    //Computed var
    //También se puede controlar el acceso
    private var indexOfTheOnlyAndOnlyFaceUpCard:Int? {
        //Se ejecutará todo este código cuando obtengan el valor de esta variable
        get {
            //Array de Ints
            /*
            //var faceUpCardIndice: Arrray<Int> = Array<Int>();
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
        //Se ejcutará todo este código cuando seteen el valor de esta variable
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
        cards.shuffle()
    }
    
    mutating func choose (card:Card) -> Void {
        //print("Card choosen: \(card)")
        // Unwrapping optional
        // Coma es un secuencial AND, no se usa && cuando se está unwrapping un optional
        if let chosenIndex: Int = self.cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOnlyAndOnlyFaceUpCard {
                // Card.content puede ser cualquier cosa, es a Generic, Don't care type
                // == en Swift usa funciones para poder comparar, la cual recibe dos parámetros
                // Pero no todos los tipos se pueden comparar con ==
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true;
                    cards[potentialMatchIndex].isMatched = true;
                }
                //indexOfTheOnlyAndOnlyFaceUpCard = nil;
                cards[chosenIndex].isFaceUp = true;
            } else {
                indexOfTheOnlyAndOnlyFaceUpCard = chosenIndex;
            }
        }
    }
    
    //Nesting Struct, struct inside struct. Para usar MemoryGame.Card
    //Cada vez que se pasa un ValueType, es copiada cada vez que se pasa como parámetro
    //@Protocol
    struct Card: Identifiable {
        var id: Int;
        // Es más fácil manejar estos llamados acá y evitar errores
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        // Es más fácil manejar estos llamados acá y evitar errores
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime();
            }
            
        }
        //var content: String;
        var content: CardContent; //Don't care type
        
        
        // MARK: Bonus Time
        
        var bonusTimeLimit: TimeInterval = 6;
        
        var lastFaceUpDate: Date?
        var pastFaceUpTime: TimeInterval = 0;

        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate);
            } else {
                return pastFaceUpTime;
            }
        }
        
        var bonusTimeRemaining: TimeInterval {
            max(0,bonusTimeLimit - faceUpTime);
        }
        var bonusRemaining:Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0 ) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        var hasEarnedBonus : Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        var isConsumingBonusTime : Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date();
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime;
            self.lastFaceUpDate = nil;
        }
        
    }
    
}
