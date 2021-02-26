//
//  Array+Only.swift
//  Memorize
//
//  Created by Hernán Beiza on 25-02-21.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil;
    }
}
