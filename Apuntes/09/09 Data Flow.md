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

- ¿Qué es?
  - Anything
  - wrappedValue es cualquier variable, de cualquier tipo
- ¿Qué hace?
  - Almacena los varloes en el heap
  - Cuando cambia, invalida la vista
- ProjectedValue ($)
  - No es un Published
  - Es un **binding**, vinculo, con el valor en la pila de memoria

### @ObservedObject

- ¿Qué es?
  - wrappedValue es cualquier cosa que implemente el protocolo **ObservableObject**
  - ViewModels
- ¿Qué hace?
  - Invalida la vista cuando wrappedValue llama objectWillChange.send()
- Projected value ($) 
  - Es un **binding**, vínculo con las variables **wrappedValue** de un ViewModel
  - Permite vincular una variable de la vista con una del ViewModel

### @Binding

- Property wrapped
- Vincula
- ¿Qué es?
  - Es un valor que consolidado de alguien más, de otro objecto
  - Que se vincula a otra variable
- ¿Qué hace?
  - Obtiene o setea el valor del wrappedValue desde otra fuente de datos
  - Cuando el valor cambia, invalida la vista
- Projected value ($)
  - Es un **binding**
  - Es el vínculo en sí mismo

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

### Binding hacia una valor constante

- Se puede crear un vinculo hacia un valor contante con Binding.constant(value)

````swift
OtherView(sharedText: .constant("ValorConstante"))
// Siempre mostrará "ValorConstante" en la otra vista
````

### Bindings procesados

- Funciona como cualquier computed var

```swift
Binding(get:...,set:...)
```

### @EnvironmentObject

- Es como un @ObservedObject
- Que se pasa a una vista de una forma diferente

```swift
let myView = MyView().environmentObject(theViewModel);
// versus la otra forma
let myView = MyView(viewModel:theViewModel);
// Y dentro de la vista
@EnvironmentObject var viewModel:ViewModelClass
// versus
@ObservedObject var viewModel: ViewModelClass
```

- Almacena el viewModel y se lo pasa a la vista
- Setea el viewModel con un ViewModifier

##### ¿Cuál es la diferencia?

- Los objetos de ambiente, @EnvironmentObject, son visibles para todas las vistas en el body, exceptuando las presentadas como Modal
- **Se usa cuando un número determinado de vistas van a compartir el mismo ViewModel**
- Una excepción son las modales view
  - Popovers
  - Alert
- No obtienen las variables de entorno automáticamente
- Cuando se presenten vistas modalmente, se podría usar @EnvironmentObject
- Se puese solo un @EnvironmentObject wrapper por ObservableObject

### @EnvironmentObject

- ¿Qué es?
  - struct
  - wrappedValue es un ObservableObject obtenido usando .environmentObject()
- ¿Qué hace?
  - Invalida la vista cuando cuando el wrappedValue gatilla objectWillChange.send()
- Projected value ($)
  - Es un Binding, vínculo, con las variables de wrappedValue (del ViewModel)
- 

### @Environment

- No tiene que ver con @EnvironmentObject
- Las property wrappers pueden tener más variables que wrappedValue and projectedValue
- Como cualquier otro struct
- Se pueden pasar valor para setear estos variables uasndo () al usar Property Wrapper

````swift
@Environment(\.colorSheme) var colorSheme
````

- Se puede obtener el valor de una variable del sistema \.colorScheme
- Permite definir que variable de la instancia mirar en el struct EnvironmentValues
- EnvironmentValues tiene muchas variables que pueden ser usadas
- En este ejemplo
  - El tipo de datos de wrappedvalue será **ColorScheme**
    - ColorScheme es un enum con .dark o .light values
  - Así se puede saber si la vista a dibujar será en dark o light mode
- No es necesario setear el valor de colorScheme, ya que lo hace internamente

### @Environment

- ¿Qué es?
  - wrappedValue es el valor de alguna variable en EnvironmentValues
- ¿Qué hace?
  - Setea u obtiene alguno de las variables de EnvironmentValues
- Projected value ($)
  - Nada
  - No proyecta nada

## @Publisher

- Light explanation

### ¿Qué es?

- Es un objeto que emita values y un posible fallo si lo hace en la emisión

```swift
Publisher<Output, Failure>
```

- Output es el tipo de algo que el Publisher publica
- Failure es el tipo de lo que sea que comunique si falla al publicar
- No importa que tipo de dators son Output o Failure
- Si el Publisher no tiene que manejar errores, no falla, el Failure puede ser Never

#### ¿Qué se puede hacer con ellos?

- Escuchar, subscribirse a ellos
- Obtener los valores
- Transformar valores on the fly
  - Tomar acciones, convertir los valores
- Lanzar los valores ,enviarlos a alguna otra parte

#### Listening, subscribing a un **Publisher**

##### Forma 1

````swift
cancellable = myPublisher.shink(
	receiveCompletion: { result in ... } 
  // result is a Completion<Failure> enum
	receiveValue: { thingThePublisherPublishes in ... }
)
````

- Si el Publisher no falla, entonces se puede omitir la implementacióñ de receiveCompletion
-  .sink retorna algo que puede ser cancellable
  - El valor implementa el protocolo Cancellable
- Muy a menudo el tipo puede ser AnyCancellable, similar a AnyTransition
- ¿Para qué?
  - Se puede .cancel() cancelar, detner la subscription al Publisher
  - Permite tener .sink vivo
- Siempre se debe mantener la variable en alguna parte, una variable de la instancia del struct, para poder trabajarlo con .sink
- Sino, la variable y el .sink dejará de escuchar, de recibir los valores emitidos

##### Forma 2

```swift
.onReceive(published) { thingThePublisherPublishes in 
	// reacer lo que sea con thingThePublisherPublishes
	... 
} 
.onReceive automáticamente invalidará la vista (redibujando)

```

#### ¿De dónde vienen los Publishers?

- $ en frente de un ProjectedValue marcado como @Published
- URLSession dataTaskPublisher
  - publica la data obtenida desde una URL cuando se completa
- Timer publish(every:)
  - Periodicamente publica la fecha 
- NotificationCenter publisher(for:)
  - Notifica cosas que suceden en el sistema
  - Eventos de sistema

#### Otras cosas que se pueden hacer con Publisher

- Publica los valores de la misma fuente de verdad