//
//  ContentView.swift
//  EmojiArt
//
//  Created by Hernán Beiza on 02-03-21.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    // Modelo de Documento
    @ObservedObject var document:EmojiArtDocument;
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}
