# 03 Reactive UI + Protocols + Layout

- CS193P
- Spring 2020
- https://cs193p.sites.stanford.edu/
- https://www.youtube.com/watch?v=SIYdYpPXil4

## Topics

- Reactive Demo

- Varieties of Types
  - Protocol
  - Enum
- Viewlayout

## Reactive Demo

- 

### Tips: Cambiar el nombre uasndo la herramienta Refactor

- Command + Click

![image-20210221180350684](/Users/hb/Dropbox/HB/Developer/Cursos/Stanford - SwiftUI/03/image-20210221180350684.png)

### External and Internal namings in functions

````swift
//External an internal names in Swift
//of es el nombre externo del parámetro cuando es llamado desde afuera
//card es el nombre interno a usar en la función
func index(of card:Card) -> Int {
  for index in 0..<self.cards.count {
    if self.cards[index].id == card.id{
      return index
    }
  }
}
````

## ObservableObject

```swift
class EmojiMemoryGame: ObservableObject {

    // MARK: - Implementación del protocolo ObjectObservable
    var objectWillChange: ObservableObjectPublisher {
        
    }
  
     // MARK: - Intents(s)
    func choose(card: MemoryGame<String>.Card) {
        //Enviar cambio al resto
        objectWillChange.send()
        model.choose(card: card);
    }
    
  
}
```

#### @Published

El problema de la impelementacióñ eanterior es que hay que hacerlo manualmente y eso puede traer errores, entonces para evitarlo se usa la anotación @Published

````swift
class EmojiMemoryGame: ObservableObject {
    @Published private var model:MemoryGame<String> = EmojiMemoryGame.createMemoryGame();
  
}
    

````

- Cada vez que se envía un cambio, la vista se actualizará

#### @ObservedObject

- Esta anotacion se implementa en el objeto que "recibirá los cambios"

```swift


struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel:EmojiMemoryGame;
    
    var body: some View {
    }
    
    }
```

- Si el modelo cambia mucho, puede ser poco eficiente, pero Swift identificará a través de Identifiable, si se debe redibujar o no

## Varieties of Types

## Protocol

- Es una especie de struct o class pero sin implementación, funciones sin cuerpo
- Tiene funciones y vars pero no implementación o almacenamiento en memoria
- Se usan para definir y ser implementadas en otros objetos

```swift
protocol Moveable {
	func move(by: Int)
	var hasMoved: Bool {get}
	var distanceFromStart: int {get set}
}
```

- Ahora cualquiera otro tipo puede implementar este protocolo llamado Moveable

````swift
struct PortableThing: Moveable {
	// Debe implementar las funciones declaradas en Moveable, move, hasMoved y distanceFromStart
}
````

- Protocol inheritance: Permite herencia de protocolos entre sí

```swift
protocol Vehicle:Moveable {
	var passengerCount: Int
}

class Car:Vehicle {
	// Debe implementar las funciones declaradas en Moveable (move, hasMoved y distanceFromStart) y del protocolo Vehicle (passengerCount)
}

```

- Los protocoloes son un tipo
- Se pueden usar en cualquier otro tipo de dato

````swift
var m:Movevable
var car:Card = new Card()
var portable:PortableThing = PortableThing()
m = card // ok
m = portable // ok
````

- Car es diferente a PortableThing, pero se puede asignar, porque ambos implementan el protocolo Moveable
- Pero no se puede hacer

````swift
portable = car
````

- Ya que portable es de tipo PortableThing y Card no es PortableThing. Son de diferente tipo
- Swift revisa el tipo siempre

### Protocol Extension

- Los protocolos son como constrains and gains

````swift
struct Tesla: Vehicle {
	//Tesla está obligado a implementar todo de Vehicle
}
````

- Se pueden agregar implementacióñ a un protocolo agregando extensiones

````swift
extension Vehicle {
  func registerWithDMV() {
  /*Implementación aquí*/
  // Los nuevos Teslas y Vehicles ganarán esta nueva implementación
  }
} 
````

- Ahora todoslos Teslas y Vehicles pueden usar esta funciones

- Usando esta forma, se pueden agregar **implementaciones por defecto**

````swift
protocol Movevable {
	func move(by: Int)
	var hasMoved: Bool { get }
	var distanceFromStart: Int { get set }
}

extension Moveable {
	var hasMoved: Bool { return distanceFromStart > 0 }
}

struct ChessPiece: Moveable {
  	// Sólo debe implementar move y distanceFromStar
  	// No es necesario implementar hasMoved porque existe una extensión que tiene la implementación definida, pero podría
} 
````

- ChessPiece 
  - Sólo debe implementar move y distanceFromStar
  - No es necesario implementar hasMoved porque existe una extensión que tiene la implementación definida 
  - Pero podría implementar hasMoved si se desea

### Extension

- Se puede usar para agregar código a una clase o struct usando extension

````swift
struct Boat {
	/*...*/
}
extension Boat {
	func sailAroungTheWorld() { /*...*/ }
}
````

- Incluso se puede hacer que un tipo sea parte de una extensión

````swift
extension Boat: Moveable {
	// Debe implementar las funciones de Moveable como move y distanceFromStart
}
````

- Ahora Boat es un Moveable

### ¿Por qué usar protocol?

- Es la forma , para los tipos struct, class, otros protocolos, de decirles qué son capaces de hacer
- También para demandar un comportamiento
- Da lo mismo el tipo de datos
- Formalizar la estructura de la aplicación
- Enfocarse en la funcionalidad y ocultar los detalles de la implementación
- Encapsulacióon OOP

## Generics and Protocols

- Don't care

````swift
protocol Greatness {
	func isGreaterThan(other:Self) -> Bool
}
// Al usar Self, hace referencia al tipo que implementa este protocol
````

- Se pueden agregar una extension a un Array

````swift
extension Array where Element: Greatness {
	var greatest: Element {
		return the greatest element calind isGreaterThan on each element	
	}
}
````

- Agregar extension a tipos ya definidos

#### ¿Cómo usar protocols y generics?

- Fundamento muy poderoso para diseñar y programar cosas
- Experiencia
- SwiftUI no es necesario ser un maestro en programación funcional en un comienzo

### Enum

- Es un tipo que contiene un valor
- En Swift se pueden tener funciones y variables computadas
- Pueden implementar protocols

## Layout

- ¿Como el espacio es distribuido en las vistas?
- Simple

1. Las vistas contenedores ofrecen espacio a las vistas interiores
2. Vistas escogen que tamaño quieren tener
3. Las vistas contenedoras posicionan las vistas en su interior

### ContainerView

- HStack y VStack dividen el espacio ofrecido a las subvistas
- ForEach es diferente al contenedor y pone las vistas dentro de sí mismo
- Los modifiers, padding(), contienen la vista y la modifican

### HStack, VStack

- Stacks dividen el espacio ofrecido por el contenedor y luego ofrecen ese espacio dividido a las vistas internas o hijas
- Ofrecen el espacio menos flexible, en respecto a tamaño, primero a las subvistas
- Vistas inflexibles
  - Image es un ejemplo de inflexible
    - Debe tener un tamaño definido
  - Text
    - Usa el tamaño justo para que el texto entre
- Vista más flexible
  - RoundedRectangle es un ejemplo de vista un poco más flexible
    - Usa siempre el tamaño ofrecido
- Luego de que una vista usa el tamaño que quiere, el espacio es eliminado del espacio disponible
- Luego se mueve al siguiente espacio menos flexible
- Luego se repite
- Y luego de que las vistas dentro del stack escogen su propio espacio, el stack se redimensiona así mismo para ajustarse a ellas (hijas)

#### Spacer

- Una vista que ocupa todo el espacio ofrecido
- No dibuja nada
- minLength es el espacio por defecto mínimo a usar en una plataforma específica

#### Divider

- Dibuja una línea divisoria
- Depende de la plataforma
- Usa el espacio mínimo necsario para hacer calzar la línea

#### layoutPriority(Double)

- Modificer
- Permite priorizar los espacios disponibles a las vistas hijas

#### Alignment

- VStack(alignment:.leading){}
- HStack(alignment:.firsttextBaseline){}
- Definir hacia donde alinear las vistas en un VStack o HStack
- .top, center, trailing

#### Modifiers

- Ejemplo: .padding
- Retornan una vista, la vista que está siendo modificada
- Pero un modifier participan en el layout 
- .padding(10)
  - Retornará una vista con su tamaño modificado
- aspectRadio
  - Modifican el espacio ofrecido y toma un tamañ menor (.fit) o mayot (.fill)
- ¡Una vista puede ser un espacio mayor al ofrecido!

```swift
HStack {
	ForEach(viewModel.cards) { card in 
		CardView(card: card).aspectRatio(2/3, 		contentMode: .fit)
	}
}
.foregroundColor(Color.orange)
.padding(10)

```

- La primera vista será a la creada con .padding(10)
- Reducirá 10 a la siguiente vista, creada con .foregroundColor
- Todo el espacio se ofrece al HStack
- Y ese espacio será dividido por ForEach, tomando en cuenta la proporción 2/3
- Y ese espacio será ofrecido y usado por CardView

## Vistas que usan todo el espacio ofrecido

- Las vistas personalizadas deberían usar todo el espacio ofrecido
- Pero en realidad deberían adaptarse a todo el espacio que se les ofrece

### GeometryReader

- Debe contener la vista a adaptar

```swift
var body: View {
	GeometryReader { geometry in 
	//...
	}
}
```

- GeometryReader es un parámetro de tipo GeometryProxy

````swift
struct GeometryProxy {
	var size: CGSize
	func frame(in: CoordinateSpace) -> CGRect
  var safeAreaInsets: EdgeInsets
}
````

- La variable size es el todo el espacio ofrecido a la vista por el contenedor.
- Con ese size se podría modificar las propiedades de la vista hija, un Text por ejemplo, para cambiar el tamaño de la fuente, etc. 

### Safe Area

- Notch en el iPhone X
- Generalmente lso espacios ofrecidos a las vistas no contemplaten el espacio seguro
- SurroundingView pueden implementar un espacio para que las vistas no dibujen en ellas 
- También se puede ignorar, usando .edgeIgnoringSafeArea([.top])
  - Se usará el espacio superior para dibujar o poner cosas

### Containers

- Como ofrecen espacio a las vistas hijas
  - .frame()
  - .frame tiene varios argumentos
- .position(CGpoint)
  - Es el centro de la subview que está dentro del container
- Stacks usan su algnment y espacio para descubrir el CGPoint de cada subview
- .offset(CGSize)
  - Se puede ofrecer a una vista

## Layout Ejemplo

- Corregir espacio que usa CardView
- Crear una grilla en vez de HStack

## Código

- Coding Style

### Magic Numbers, Constants

```swift

// MARK: - Drawing Constants
// let para constantes
let cornerRadius:CGFloat = 10.0;
let edgeLineWidth:CGFloat = 3.0;
func fontSize(for size: CGSize) -> CGFloat {
  return min(size.width, size.height) * 0.75;
}
```

