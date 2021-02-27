//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Hernán Beiza on 20-02-21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    //No puede ser private, porque debe ser seteada desde afuera
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
    //No puede ser private, porque necesita ser seteada en el constructor
    var card:MemoryGame<String>.Card
    //Access Control
    //No puede ser private, porque el sistema la necesita
    var body: some View {
        GeometryReader(content: { geometry in
            //Implementación para solucionar el bug antiguo de self dentro de llamado de una función inline
            self.body(for: geometry.size)
        })
    }

    // Ahora es una lista de Vistas
    @ViewBuilder
    private func body(for size:CGSize) -> some View {
        //Vista combinada
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Pie(startAngle:Angle.degrees(-90),endAngle: Angle.degrees(110-90), clockwise: true).padding(5).opacity(0.4)
                Text(card.content)
                .font(Font.system(size: fontSize(for: size)))
            }
            //.modifier(Cardify(isFaceUp:card.isFaceUp))
            //Se puede usar así gracias a la extension en Cardify
            .cardify(isFaceUp: card.isFaceUp)
        }
        //Ahora se puede retornar un EmptyView al usar la anotación ViewBuilder
    }
        
    // MARK: - Drawing Constants
    private func fontSize(for size: CGSize) -> CGFloat {
        return min(size.width, size.height) * 0.7;
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame();
        game.choose(card: game.cards[0]);
        return EmojiMemoryGameView(viewModel: game)
    }
}
