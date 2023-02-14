# 14 UIKit Integration

- CS193P
- Spring 2020
- https://cs193p.sites.stanford.edu/
- https://www.youtube.com/watch?v=GRX5Dha_Clw

## Topics

- Integration with UIKit
  - Old way developing applications for iOS

## UIKit

- No hay MVVM. Existe MVC
  - Model View Controller
- En UIKit las vistas están agrupadas en Controller
- Un Controller es lo atómico al presentar las vistas en la pantalla

### Integración

- Hay dos formas de integración de SwiftUI a UIKit
- UIViewRepresentable
- UIViewControllerRepresentable
- Cada una convierte una vista o controlador en una vista SwiftUI
- Setear variables
- Llamar funciones

### Delegation

- UIKit es basada en Object Oriented
- Usa delegate para comunicar la funcionalidad
- Los objetos, controllers y vistas, delegate la funcaionlidad a otros objetos
- Esto se realiza usando una variable llamada **delegate**
- La variable delegate está amarrada a través del protocolo con toda la funcionalidad delegate

### Representables

- UIViewRepresentable

- UIViewControllerRepresentable

- Ambos son vistas SwiftUI
1. Una función que crea el UIKit (vista o controller)
   
   ```swift
   func makeUIView { Controller }(context: Context) -> view/controller
   ```

2. Una función que actualiza el elemento UIKit cuando corresponda (bindings change, etc)

```swift
func updateUIView { Controller } (view/controller, contet: Context)
```

3. Un objeto coordinador, el que se encarga de manejar los delegates

```swift
func makeCoordinator() -> Coordinator // Coordinator es de tipo Don't care for Representables
```

4. Un contexto (que contiene el Coordinator, los elementos SwiftUI's del ambiente, animation transaction)

```swift
// pasada en los métodos anteriores
class Coordinator: NSObject, MKMapViewDelegate {

}
```

5. Y una fase de limpieza, teard down, para limpiar variables, etc. cuando la vista o controlador desaparezca

```swift
func dismantleUIView { Controller } (view/controller, coordinator: Coordinator)
```

## Demo

- Integrar UIKit, MapKit  en SwiftUI
  - Usar MapKit
  - Usar @Binding para pasar un valor desde una nested Class a Struct

```swift
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
```

- Integrar UIKit, UIViewController en SwiftUI