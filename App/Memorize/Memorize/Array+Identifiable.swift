//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Hernán Beiza on 25-02-21.
//

import Foundation

//Agregar una extensión al tipo Array que tiene elementos Identifiable
extension Array where Element: Identifiable {
    //Optional Int
    func firstIndex(matching:Element) -> Int? {
        for index in 0..<self.count{
            if self[index].id == matching.id {
                return index;
            }
        }
        return nil;
    }
}
