//
//  ContentView.swift
//  Memorize
//
//  Created by Hernán Beiza on 24-02-21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        //Vista combinada
        return HStack{
            //No incluye el 4
            ForEach(0..<4, content:{ index in
                //Definir el valor de esta variable
                CardView(isFaceUp: true)
            })
        }
        .padding()
        .foregroundColor(.orange)
    }
}

struct CardView: View {
    //Si la variable no tiene valor o no es inicializada, al instanciar el objeto pedirá el valor como argumento
    var isFaceUp:Bool
    var body: some View {
        //Vista combinada
        ZStack{
            if isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                Text("👻").font(Font.largeTitle)
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
