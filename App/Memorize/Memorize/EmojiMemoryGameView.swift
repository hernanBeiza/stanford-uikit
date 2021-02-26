//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Hernán Beiza on 20-02-21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel:EmojiMemoryGame;
    
    var body: some View {
        //Vista combinada
        return Grid(items:viewModel.cards) { card in
            //Definir el valor de esta variable
            CardView(card:card).onTapGesture {
                self.viewModel.choose(card: card)
                //con self se puede escapar, salir del error de llamados redundantes
                //de memoria
            }
        }
        .padding()
        .foregroundColor(.orange)
    }
}

struct CardView: View {
    //Si la variable no tiene valor o no es inicializada, al instanciar el objeto pedirá el valor como argumento
    var card:MemoryGame<String>.Card
    var body: some View {
        GeometryReader(content: { geometry in
            //Implementación para solucionar el bug antiguo de self dentro de llamado de una función inline
            self.body(for: geometry.size)
        })
    }
    
    func body(for size:CGSize) -> some View {
        //Vista combinada
        ZStack{
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                Text(card.content)
            } else {
                if !card.isMatched {
                    RoundedRectangle(cornerRadius: cornerRadius).fill()
                }
            }
        }
        .font(Font.system(size: fontrSize(for: size)))
    }
        
    // MARK: - Drawing Constants
    let cornerRadius:CGFloat = 10.0;
    let edgeLineWidth:CGFloat = 3.0;
    func fontrSize(for size: CGSize) -> CGFloat {
        return min(size.width, size.height) * 0.75;
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
