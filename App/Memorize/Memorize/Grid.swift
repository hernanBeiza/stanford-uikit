//
//  Grid.swift
//  Memorize
//
//  Created by Hernán Beiza on 25-02-21.
//

import SwiftUI
//Para poder usar Item e ItemView como elementos que se pueden recorrer
struct Grid<Item, ItemView>: View where Item:Identifiable, ItemView:View {
    var items:[Item];
    var viewForItem: (Item) -> ItemView;
    
    init(items:[Item], viewForItem: @escaping (Item) -> ItemView){
        self.items = items;
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
    
    func body(for layout:GridLayout) -> some View {
        ForEach(items) {item in
            self.body(for: item, in:layout);
        }
    }
    
    //Unwrapping
    //Si no encuentra valor, será nil y debería caerse. Que sea nil no siempre es malo, indica que algo malo está pasando
    func body (for item:Item, in layout:GridLayout) -> some View {
        let index = items.firstIndex(matching: item)!;
        return viewForItem(item).frame(width: layout.itemSize.width, height: layout.itemSize.height).position(layout.location(ofItemAt:index))
    }
    
}
