//
//  MapView.swift
//  Enroute
//
//  Created by Hernán Beiza on 20-03-21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit

// Integración con UIKIt
struct MapView: UIViewRepresentable {
    let annotations: [MKAnnotation];
    @Binding var selection: MKAnnotation?;
    
    typealias UIViewType = MKMapView
        
    func makeUIView(context: Context) -> MKMapView {
        let mkMapView = MKMapView()
        mkMapView.delegate = context.coordinator;
        mkMapView.addAnnotations(annotations);
        return mkMapView;
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //redibujar, actualizar, etc
        if let anntation = selection {
            let town = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            uiView.setRegion(MKCoordinateRegion(center: anntation.coordinate, span: town), animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selection:$selection);
    }
    
    // Los delegates heredan de NSObject
    class Coordinator: NSObject, MKMapViewDelegate {
        @Binding var selection:MKAnnotation?;
        //Al ser class, debe tener su init.
        init(selection:Binding<MKAnnotation?>) {
            self._selection = selection;
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "MapViewAnnotation") ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MapViewAnnotation")
            view.canShowCallout = true;
            return view;
        }
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation {
                //Para poder pasar este anotation al struct MapView, se debe crear un @Binding
                self.selection = annotation
            }
        }
    }
    
}
