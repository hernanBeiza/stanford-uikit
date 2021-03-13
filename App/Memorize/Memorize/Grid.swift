//
//  Grid.swift
//  Memorize
//
//  Created by Hernán Beiza on 25-02-21.
//

import SwiftUI
//Para poder usar Item e ItemView como elementos que se pueden recorrer
//Usar ID
extension Grid where Item: Identifiable, ID == Item.ID {
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView ) {
        self.init(items,id: \Item.id, viewForItem: viewForItem)
    }
}
struct Grid<Item, ID, ItemView>: View where ID:Hashable, ItemView:View {
    //No tienen que ser public, ya que se inicializan en el init. Si se inicializaran directamente, no podrían ser private
    private var items:[Item];
    private var viewForItem: (Item) -> ItemView;
    private var id: KeyPath<Item,ID>;
    //Permitir que pueda identificar el path \.self, del emoji
    //Valor a identificar, item
    //Valor a retornar, Id
    init(_ items:[Item], id: KeyPath<Item,ID>, viewForItem: @escaping (Item) -> ItemView){
        self.items = items;
        self.id = id;
        self.viewForItem = viewForItem;
        // Escaping closure.
        // La función pasada por parámetro no es usada en el init
        // Hay que marcar o escapar el parámetro para evitar memory ciclings o llamadas circulares
    }
    
    var body: some View {
        /*
        Es necesario incluir where Item:Identifiable para poder usar un foreach con un
        elemento Don'tCare
        */
        GeometryReader { geometry in
            self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size));
        }
    }
    
    //Los id deben ser Hashable
    private func body(for layout:GridLayout) -> some View {
        ForEach(items, id:id) {item in
            self.body(for: item, in:layout);
        }
    }
    
    //Unwrapping
    //Si no encuentra valor, será nil y debería caerse. Que sea nil no siempre es malo, indica que algo malo está pasando
    private func body (for item:Item, in layout:GridLayout) -> some View {
        //Llamar a la variable keyPath de item y revisar si es igual
        let index = items.firstIndex(where: { item[keyPath: id] == $0[keyPath:id]})
        return Group {
            if index != nil {
                viewForItem(item)
                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                    .position(layout.location(ofItemAt:index!))
            }
        }
    }
    
}
