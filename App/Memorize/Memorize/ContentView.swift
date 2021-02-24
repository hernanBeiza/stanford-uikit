//
//  ContentView.swift
//  Memorize
//
//  Created by Hernán Beiza on 24-02-21.
//

import SwiftUI

struct ContentView: View {
    var viewModel:EmojiMemoryGame;
    
    var body: some View {
        //Vista combinada
        return HStack {
            //Para poder usar directamente un modelo en un ForEach, necesita usar el protocolo Identifiable
            ForEach(viewModel.cards) { card in
                //Definir el valor de esta variable
                CardView(card:card).onTapGesture {
                    viewModel.choose(card: card)
                };
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
        //Vista combinada
        ZStack{
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                Text(card.content).font(Font.largeTitle)
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
    }
}
