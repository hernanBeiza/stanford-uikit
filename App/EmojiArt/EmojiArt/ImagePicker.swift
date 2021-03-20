//
//  ImagePicker.swift
//  EmojiArt
//
//  Created by Hernán Beiza on 20-03-21.
//

import SwiftUI
import UIKit

// Sirve para definir un tipo de dato y reusarlo
typealias PickedImageHandler = (UIImage?) -> Void

struct ImagePicker: UIViewControllerRepresentable {
    //Cámara o librería
    var sourceType:UIImagePickerController.SourceType;

    //Handler, closure
    var handlePickedImage: PickedImageHandler
    
    typealias UIViewControllerType = UIImagePickerController

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator;
        return picker;
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(handlePickedImage: handlePickedImage);
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var handlePickedImage: PickedImageHandler
        
        init (handlePickedImage: @escaping PickedImageHandler) {
            self.handlePickedImage = handlePickedImage;
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            handlePickedImage(info[.originalImage] as? UIImage);
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
        }
    }
        
}
