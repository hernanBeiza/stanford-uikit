//
//  Cardify.swift
//  Memorize
//
//  Created by Hernán Beiza on 26-02-21.
//

import SwiftUI

//ViewModifier, Animatable == AnimatableModifier
struct Cardify: AnimatableModifier {
    var rotation:Double;
        
    init (isFaceUp : Bool) {
        rotation = isFaceUp ? 0: 180
    }
    
    var isFaceUp:Bool {
        rotation < 90
    }
    //El sistema busca por esta variable, es pedida por el protocolo Animatable
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }

    func body(content: Content) -> some View {
        return ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            }
            .opacity(isFaceUp ? 1: 0)
            RoundedRectangle(cornerRadius: cornerRadius).fill()
            .opacity(isFaceUp ? 0: 1)
        }
        //Con el ViewModifier AnimatableModifier, se sobreescribe la animación por defecto, así que la opacidad no se animará
        .rotation3DEffect(Angle.degrees(rotation), axis: (x: 0, y: 1, z: 0))
    }
 
    private let cornerRadius:CGFloat = 10.0;
    private let edgeLineWidth:CGFloat = 3.0;
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp));
    }
}
