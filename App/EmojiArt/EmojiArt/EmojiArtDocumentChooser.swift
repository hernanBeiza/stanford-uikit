//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by Hernán Beiza on 13-03-21.
//

import SwiftUI


struct EmojiArtDocumentChooser: View {
    @EnvironmentObject var store: EmojiArtDocumentStore
        
    @State private var editMode: EditMode = .inactive;
    
    var body: some View {
        NavigationView {
            //TableView!
            List {
                ForEach(store.documents) { document in
                    NavigationLink(destination: EmojiArtDocumentView(document: document)
                        //Al entrar a la vista, el título cambiará
                        .navigationBarTitle(self.store.name(for: document))) {
                        EditableText(self.store.name(for: document),isEditing:self.editMode.isEditing) { name in
                            self.store.setName(name, for: document)
                        }
                    }
                }
                //Función a ejecutar al eliminar un elemento de la lista
                .onDelete { indexSet in
                    indexSet.map { self.store.documents[$0] }.forEach { document in
                        self.store.removeDocument(document);
                    }
                }
            }
            .navigationTitle(self.store.name)
            //Solo para cuando se muestra la lista
            .navigationBarItems(
                leading: Button(action: {self.store.addDocument()},label: { Image(systemName: "plus").imageScale(.large)}),
                //Agregar botón editar lista en la esquina superior derecha
                trailing: EditButton()
            )
            //Binding con la variable de ambiente EditMode
            // Es un @binding porque una vez que se setea la variable de ambiente, o en palabras simples se modifica algo, EditMode, se debe redibujar la vista nuevamente.
            // Redibuja solo las vistas en dónde se llama
            .environment(\.editMode, $editMode)
        }
    }
    
}

/*
struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentChooser()
    }
}
*/
