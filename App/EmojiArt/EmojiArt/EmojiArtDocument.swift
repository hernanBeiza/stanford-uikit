//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Hernán Beiza on 02-03-21.
//

// Modelo de Documento

import SwiftUI
//Para Subscribing a valores de Publisher
import Combine

class EmojiArtDocument: ObservableObject {
    
    static let palette: String = "🚌🦠😎🏵🎹";

    //Gatillar redibujar de la vista cada vez que cambia
    //Workaroung for property observer problem with property wrappers
    @Published var emojiArt:EmojiArt;
    // Usar el valor proyectado del Published
    //Cada vezx que el EmojiArt instance cambia, se actualizará el valor proyectado y se comunicará

    private static let untitled = "EmojiArtDocument.Untitled";
    
    //Variable para guardar la subscription al valor del Publisher
    private var autoSaveCancellable: AnyCancellable?;
    
    init () {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt();
        //Subscribing a lo que el Publisher envía, publica
        //$emojiArt es el valor proyectado de @Published
        autoSaveCancellable = $emojiArt.sink { emojiArt in
            //print ("\(emojiArt.json?.utf8 ?? "nil ")");
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled);
        }
        fetchBackgroundImageData();
    }

    //Gatillar redibujar de la vista cada vez que se obtiene la imagen
    @Published private(set) var backgroundImage: UIImage?;

    //Variable computada para obtener los valores de este modelo
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    // MARK: Intent(s)
    func addEmoji(_ emoji:String, at location: CGPoint, size:CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size:Int(size))
    }
    
    func moveEmoji(_ emoji:EmojiArt.Emoji, by offset:CGSize){
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji:EmojiArt.Emoji, by scale: CGFloat){
        if let index = emojiArt.emojis.firstIndex(matching: emoji){
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    var backgroundURL: URL? {
        set {
            //De la extensión para obtener la url de la imagen
            emojiArt.backgroundURL = newValue?.imageURL;
            fetchBackgroundImageData()
        }
        get {
            emojiArt.backgroundURL;
        }
    }
    
    //Eta variable permite cancelar el subscription
    private var fetchImageCancellable: AnyCancellable?
    
    private func fetchBackgroundImageData(){
        backgroundImage = nil
        //Provide some UI hint, loading progressbar
        if let url = self.emojiArt.backgroundURL {
            //Cancelar request anteriorees a la nueva recién realizada
            fetchImageCancellable?.cancel()
            /*
            //URLSession.shared trabajaba en la cola background, BackgroundQueue
            let session = URLSession.shared
            // UNa vez que se descargue la data, se publicará un mensaje con la data
            let publisher = session.dataTaskPublisher(for: url)
                //Se mapea, transforma el closure original de session, a uno personalizado
                .map { data, urlResponse in UIImage(data:data) }
                // Se pasa a MainQueue
                .receive(on: DispatchQueue.main)
                //Reemplaza el manejo del error del publisher, a un nil
                .replaceError(with: nil)
            // Lo que sea que publica el publisher, lo publica directamente en la propiedad de un clase, en self (acá está el objeto, clase en cuestión)
            fetchImageCancellable = publisher.assign(to: \EmojiArtDocument.backgroundImage, on: self)
            */
            fetchImageCancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { data, urlResponse in UIImage(data:data) }
                .receive(on: DispatchQueue.main)
                .replaceError(with: nil)
                .assign(to: \EmojiArtDocument.backgroundImage, on: self)
        }
    }
    
}

extension EmojiArt.Emoji {
    var fontSize:CGFloat { CGFloat(self.size) }
    var location:CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
