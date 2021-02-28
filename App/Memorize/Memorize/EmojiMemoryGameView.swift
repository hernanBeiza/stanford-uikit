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
        Grid(items:viewModel.cards) { card in
            //Definir el valor de esta variable
            CardView(card:card).onTapGesture {
                //Animará todo. Por defecto está la opacidad
                withAnimation(.linear(duration:0.75)){
                    self.viewModel.choose(card: card)
                    //con self se puede escapar, salir del error de llamados redundantes
                    //de memoria
                }
            }
        }
        .padding()
        .foregroundColor(Color.orange)
        //Se adapta a la plataforma automáticamente
        Button(action: {
            withAnimation(.easeInOut) {
                self.viewModel.resetGame();
            }
        }, label: { Text("New Game"); });
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
    
    // Variables para trackear los valores del modelo y mantener la vista sincronizada con él
    @State private var animatedBonusRemaining : Double = 0;
    //Función para mantener sincronizado los valores de la tarjeta, del modelo, con esta vista
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining;
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0;
        }
    }
    
    // Ahora es una lista de Vistas
    @ViewBuilder
    private func body(for size:CGSize) -> some View {
        //Vista combinada
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle:Angle.degrees(-90),endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true).padding(5).opacity(0.4)
                            .onAppear {
                                //Llama este clousure cada vez que aparece en apantalla
                                startBonusTimeAnimation()
                            }
                    } else{
                        Pie(startAngle:Angle.degrees(-90),endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true).padding(5).opacity(0.4)
                    }
                }
                .padding(5).opacity(0.4).transition(.identity)
                Text(card.content)
                .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360:0))
                    .animation(card.isMatched ? Animation.linear(duration:1).repeatForever(autoreverses: false) : .default)
            }
            //.modifier(Cardify(isFaceUp:card.isFaceUp))
            //Se puede usar así gracias a la extension en Cardify
            .cardify(isFaceUp: card.isFaceUp)
            //Las animaciones ocurren todas al mismo tiempo
            .transition(AnyTransition.scale)
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
