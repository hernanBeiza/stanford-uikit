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
    
    @State private var showPalleteEditor = false;
    
    var body: some View {
        HStack {
            Stepper(onIncrement:{
                self.chosenPalette = self.document.palette(after:self.chosenPalette)
            }, onDecrement: {
                self.chosenPalette = self.document.palette(before:self.chosenPalette)
                
            }, label: { EmptyView() })
            Text(self.document.paletteNames[self.chosenPalette] ?? "")
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture {
                    self.showPalleteEditor = true
                }
                //Podría ser un .popover, .sheet
                .popover(isPresented: $showPalleteEditor, content: {
                    // Pasar el @State, con $ al @Binding interno de PaletteEditor
                    PaletteEditor(chosenPalette: $chosenPalette, isShowing: $showPalleteEditor)
                        //Pasar el objeto
                        .environmentObject(self.document)
                    .frame(minWidth: 300, minHeight: 500)
                })
        }
        .fixedSize(horizontal: true, vertical: false)
        //Elimina espacios proporcinoales
        //Permite inicializar valores de state según observedObject
        //No necesario ya que se usa @Binding para recibir el valor del @State
        //.onAppear{ self.chosenPalette = self.document.defaultPalette }
    }
}

struct PaletteEditor: View {
    //@EnvirontmentObject usado para pasar data a otra vista
    @EnvironmentObject var document:EmojiArtDocument
    // Conectca estas variables locales cno las definidas en el Struct de más arriba, los @State
    @Binding var chosenPalette: String;
    @Binding var isShowing:Bool;

    @State var paletteName: String = "";
    @State var emojisToAdd: String = "";


    var body: some View {
        VStack(spacing:0) {
            ZStack{
                Text("Palette Editor").font(.headline).padding()
                HStack {
                    Spacer()
                    Button(action: {
                        self.isShowing = false;
                    }, label: { Text("Done") }).padding()
                }
            }
            Divider()
            //Agrega scrolls y títulos
            Form {
                Section(){
                    TextField("Palette Name", text:$paletteName, onEditingChanged: { began in
                        if !began {
                            self.document.renamePalette(self.chosenPalette, to: self.paletteName)
                        }
                    })
                    TextField("Add Emoji", text:$emojisToAdd, onEditingChanged: { began in
                        if !began {
                            self.chosenPalette = self.document.addEmoji(self.emojisToAdd, toPalette: self.chosenPalette)
                            self.emojisToAdd = "";
                        }
                    })
                }
                Section(header: Text("Remove Emoji")){
                    Grid(chosenPalette.map { String($0) }, id:\.self) { emoji in
                        Text(emoji).font(Font.system(size:self.fontSize))
                            .onTapGesture {
                                self.chosenPalette = self.document.removeEmoji(emoji, fromPalette: self.chosenPalette)
                            }
                    }
                    .frame(height: self.height)
                }
            }
        }
        .onAppear { self.paletteName = self.document.paletteNames[self.chosenPalette] ?? "" }
    }
    
    var height: CGFloat {
        CGFloat ((chosenPalette.count - 1 ) / 6) * 70 + 70;
    }
    let fontSize: CGFloat = 40;
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        //Se pasa un Binding con un valor constante
        //En Preview no funcionará
        PaletteChooser(document: EmojiArtDocument(), chosenPalette: Binding.constant("") )
    }
}
