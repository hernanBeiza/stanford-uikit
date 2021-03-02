//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Hernán Beiza on 02-03-21.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: EmojiArtDocument())
        }
    }
}
