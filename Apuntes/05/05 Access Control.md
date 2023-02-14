# 05 ViewBuilder + Shape + ViewModifier

- CS193P
- Spring 2020
- https://cs193p.sites.stanford.edu/
- https://www.youtube.com/watch?v=oDKDGCRdSHc&ab_channel=Stanford

## Topics

- Access Control
- @ViewBuilder
  - Zstack, ForEach, GeometryReader
- Shape
- Animation
  - Mobile app UIs
- ViewModifier
  - foregroundColor
  - font
  - padding

### Access Control

- private

- Controlar el acceso

- El acceso se puede controlar a set o get
  
  - Así se define una variable que puede set obtenida, pero no seteada desde otro lado
  
  ```swift
  private(set) var cards:Array <Card>
  ```

- También se puede definir a las variables computadas

### @ViewBuilder

- Anotación
- Lists of Views
- Permite retornar, definir, que algo será parte de una vista
- Retornará una vista combinada, por ejemplo TupleView (2 a 10 subvistas)
- ConditionalContent View: if-else
- EmptyView: Nada que mostrar
- Se puede usar en funciones o read-only computed var

```swift
@ViewBUilder
func front(ofCard: Card) -> some View {
  RoundedRectangle(cornerRadiuus: 10);
  RoundedRectangle(cornerRadiuus: 10).stroke();
  Text(card.content);
}
// Esto retornará un TupleView
```

- La anotación permite marcar un parámaetro que retornará una vista

```swift
//Ejemplo en GeometryReader
struct GeometryReader<Content> where Content: View {
    init (@ViewBuilder content: @escaping (GeometryProxy) -> Content) { ...} 
}
```

- No hay forma de extraer las vistas hasta el momento
- **El contenido de un @ViewBuilder es una lista de vistas**
- No se pueden declarar variables
- Escribir código
- Si hay if-else, es sólo para crear condiciones para ver que vista se va a mostrar

### Shapes

- RoundedRectangle
- Circle
- Capsule
- Por defecto se dibujan así con el color foreground
- .stroke()
- .fill()
- Son funciones genéricas
  - Es a don't care, pero si hay un where, es un poco más restrictivo
  - Puede ser cualquier cosa que implementa el protocolo ShapeStyle
    - Color
    - ImagePaint
    - AngularGradient
    - LinearGradient

##### Crear una forma

- Protocolo shape tiene una función que implementa el cuerpo de la vista

```swift
func path(in rect: CGRect) -> Path {
    return a Path
}
```

- 0,0 está en la punta superior izquierda
- 

### Animation

- Importante en mobile UI
- Shape se pueden animar directamente
- Vistas se animan a través de ViewModifier
  - padding
  - foregroundColor

### ViewModifier

- Modifican una vista y retornan la vista nueva, la vista modificada
- La función modifier
- El protocol ViewVodifier se encarga de una sola cosa: crear una nueva vista en base a lo que se le pase por parámetro

```swift
protocol ViewModifier {
    associatedType Content;
    func body (content: Content) -> some view {
        return //vista que representa la modificación de content
    }
}
```

- Al llamar .modifier en la vista, el contenido, content, el contenido pasado a la función es la vista
- Crea una nueva vista usando la vista pasada por parámetro

```swift
Text("👻").modifier(Cardify(isFaceUp:true)); //Eventualmente .cardify(isFaceUp:true)

struct Cardify: ViewModifier {
  // Argumentos, parámetros, del ViewModifier
  var isFaceUp: Bool
  func body(content: Content) -> some View {
      Zstack {
      if isFaceUp {
        RoundedRectangle(cornerRadius: 10).fillColor(Color.white);
        RoundedRectangle(cornerRadius: 10).stroke();
        //content
      } else {
        RoundedRectangle(cornerRadius: 10);
      }
    }
  }
}
```

#### ¿Cómo pasar de...?

```swift
//Esto
Text("👻").modifier(Cardify(isFaceUp:true)); 
//A esto
Text("👻").cardify(isFaceUp:true)); 
```

- Simple, crear una extensión de View en el archivo que tiene la función del ViewModifier

```swift
extension View {
  // Argumentos, parámetros, del ViewModifier
  func cardify(isFaceUp: Bool) -> some View {
    return self.modifier(Cardify(isFaceUp:isFaceUp));
  }
}
```

- Quedaría algo así

```swift
import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp:Bool;

    func body(content: Content) -> some View {
        return ZStack {
            if isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            } else {
                RoundedRectangle(cornerRadius: cornerRadius).fill()
            }
        }
    }

    private let cornerRadius:CGFloat = 10.0;
    private let edgeLineWidth:CGFloat = 3.0;
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp));
    }
}
```
