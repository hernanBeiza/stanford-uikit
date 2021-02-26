//
//  GridLayout.swift
//  Memorize
//
//  Created by Hernán Beiza on 25-02-21.
//

import SwiftUI

struct GridLayout {
    
    var size:CGSize;
    var rowCount: Int = 0;
    var columnCount: Int = 0;
    
    init (itemCount: Int, nearAspectRatio desiredAspectRatio:Double = 1, in size: CGSize){
        self.size = size;
        self.rowCount = itemCount/2;
        self.columnCount = rowCount/2;
    }

    //TODO: Terminar esto
    var itemSize: CGSize {
        return CGSize(width:100,height:100);
    }
    
    //TODO: Terminar esto
    func location(ofItemAt index:Int ) -> CGPoint {
        return CGPoint(x:50,y:50);
    }
    
}
