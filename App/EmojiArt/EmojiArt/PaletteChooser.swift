//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Hernán Beiza on 11-03-21.
//

import SwiftUI

struct PaletteChooser: View {

    @ObservedObject var document:EmojiArtDocument;

    //Binding, vinculo de una variable del ViewModel con otra, que puede estar en otro lado
    // Los valores recibido de un @State no pueden ser inicializados directamente
    @Binding var chosenPalette:String;

    var body: some View {
        HStack {
            Stepper(onIncrement:{
                self.chosenPalette = self.document.palette(after:self.chosenPalette)
            }, onDecrement: {
                self.chosenPalette = self.document.palette(before:self.chosenPalette)
                
            }, label: { EmptyView() })
            Text(self.document.paletteNames[self.chosenPalette] ?? "")
        }
        .fixedSize(horizontal: true, vertical: false)
        //Elimina espacios proporcinoales
        // Permite inicializar valores de state según observedObject
        // No necesario ya que se usa @Binding para recibir el valor del @State
        //.onAppear{ self.chosenPalette = self.document.defaultPalette }
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        //Se pasa un Binding con un valor constante
        //En Preview no funcionará
        PaletteChooser(document: EmojiArtDocument(), chosenPalette: Binding.constant("") )
    }
}
