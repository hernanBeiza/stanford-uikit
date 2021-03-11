# 09 Data Flow

- CS193P
- Spring 2020
- https://cs193p.sites.stanford.edu/
- https://www.youtube.com/watch?v=0i152oA3T3s

## Topics

- Property Wrappers
  - @State
  - @Published
  - @ObserverdObject
- Publishers
- 

- 

## Property Wrappers

- Todos esos @Something son wrappers
- structs
- Encapsulan un template de un comportamiento que se aplican a las variables que encapsulan
- Ejemplo
  - Una variable que vive en @State
  - Una variable que publica sus cambios @Publised
  - Hacer que una vista se redibuje cuando un cambio publicado es detecado @ObservedObject
- Syntactic Sugar

````swift
@Published var emojiArt: EmojiArt = EmojiArt()

// En realidad crea un struct
struct Published {
	var wrappedValue: EmojiArt
	//Crea una variable del tipo que encapsula
	var projectedValue: Publisher<EmojiArt, Never>
  // Que proyecta los valores a otros
}
// Y Swift disponibiliza esa variables
var _emojiArt: Published = Published(wrappedValue: EmojiArt())
// Crea una variable procesada
var emojiArt: EmojiArt {
  get { _emojiArt.wrappedValue }
  set { _emojiArt.wrapperValue = newValue }  
}

//Además hay otra variable dentro del structs Publisher es Published<EmojiArt,Never>
//Never fails
// Se puede acceder a esa variable $emojiArt
````

- Los wrappers en los structs ejecutan algo cuando get o set el wrappedValue

### Published

- ¿Qué hace? 
  - Publica los cambios a través de projectedValue cuando el valor es seteado
  - $emojiArt el cuál es un Publisher
  -  E invoca objectWillChange.send() en el objecto ObservableObject

### @State

- wrappedValue
- ¿Qué es?
  - Anything
  - Cualquier variable, de cualquier tipo
- ¿Qué hace?
  - Almacena los varloes en el heap
  - Cuando cambia, invalida la vista
  - El valor con $, signo peso, es un **binding**

### @ObservedObject

- ¿Qué es?
  - wrappedValue es cualquier cosa que implemente el protocolo **ObservableObject**
  - ViewModels
- ¿Qué hace?
  - Invalida la vista cuando wrappedValue llama objectWillChange.send()
  - Projected value ($) es un **binding** de las variables wrappedValue

### @Binding

- Property wrapped
- Vincula
- ¿Qué es?
  - Es un valor que consolidado de alguien más, de otro objecto
  - Que se vincula a otra variable
- ¿Qué hace?
  - Obtiene o setea el valor del wrappedValue desde otra fuente de datos
  - Cuando el valor cambia, invalida la vista
  - Projected value ($) es un **binding**

#### ¿Dónde se usan los bindings?

- En todas partes
- Se usan para obtener el valor del estado real
- Se usa un @Binding para obtener el valor directamente desde ViewModel y evitar tener
  - Un @State en la vista
  - Un @State en el ViewModel
  - No se usa dos diferentes @State var en dos vistas diferente para almacenar el mismo objecto, valor, etc.
  - En ese caso uno de los dos debe ser un @BGinding
- Permite crear variables para coenctar cosas entre sí y evitar dos diferentes @State

#### Ejemplo de uso de bindings


- Compartiendo valores a través de Bindings

````swift
struct MyView: View {
	@State var myString = "Hello"
  var body: View {
  	OtherView(sharedText: $myString) 
  }
}
struct OtherView: View {
  @Binding var sharedText: String
  // Tendrá un binding de un string
  // Se usa el signo dolar para pasar el valor 
  var body: View {
    Text(sharedText)
  }
}
````

- OtherView body es un texto que siempre  será el valor de myString de MyView
- OtherView sharedText es un valor consolidado de la variable myString de MyView 
- No crea una copia, se vincula un valor con el otro

