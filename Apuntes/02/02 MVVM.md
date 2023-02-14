# 02 MVVM and the Swift Type System

- CS193P
- Spring 2020
- https://www.youtube.com/watch?v=4GjXq2Sr55Q&feature=youtu.be&ab_channel=Stanford

## Topics

- MVVM Design Paradigm
- Tipos
  - struct
  - class
  - protocol

## MVVM

- Paradigma de diseño para organizar el ćodigo
- Reactive user interfaces
- Similar a MVC
- Model
- View
- **La data fluye desde el modelo hacia la vista**, en cualquier momento
  - Mira el modelo y lo muestra en la vista

### Model

- Es independiente de la UI
- Data + Lógica
- Toda la lógica vive en el modelo
- Es la verdad, almacena la data en alguna parte

### View

- Reflects el modelo
- Automáticamente observa las publicaciones del ViewModel, obtiene la data y reconstruye

#### Stateless

- Todos los estados están en el modelo
- No están en la vista, vienen del modelo
- La vista toma lo que el modelo tienen y lo muestra

#### Declarativa

- Declara como la UI se ve
  - Usa un botón
  - HStack
  - RoundedRectangle
- Es independiente del tiempo que ocupa
- Se define como se ve y lo que hace
- Los structs son solo read only
- Todo el código está frente a uno, declarando, mostrando, como se verá la vista

### Diferencia y ventaja de ser declarativo vs imperativo

- Imperial, emperador
  - Tú haz esto!
  - Pon este botón aquí!
- Decir a la UI como hacer las cosas puede ser malo
  - Es malo para la UI por el tiempo que usa
  - Funciones que se llaman a cada rato, entonces es malo para el rendimiento
  - Es complicado manejar estos constantes y múltiples llamados a funciones
  - Es independiente del tiempo

#### Reactive

- Automáticamente si hay un cambio en el modelo, se mostrará en la vista
- Mostrar como el modelo indica
- Una vez que el modelo cambia, cambia la UI
- Reacciona a los cambios en el modelo

### VIEWMODEL

- Unir la vista al modelo
- **Interpreta** el modelo y lo representa en la vista
- Los datos pueden venir desde una base de datos SQL, APIs, etc
- Se encarga de notificar los cambios en el modelo a la vista
- Publica, avisa que algo ha cambiado
- Single source of “truth”

##### Keywords

- @ObservableObject
- @Published
- objectWillChanged.send()
- environmentObject()

### Cómo comunicar los cambios desde la vista hacia el modelo?

- User intent
- ModelViewIntent
- Swift no usa este paradigma
- Crear funciones llamadas desde la vista
- Calls Intent Functions del ViewModel
- A través de estas funciones, se envían los datos del modelo modificadas
- Y luego el modelo notifica cambios, MVVM publica los cambias y la vista escucha estos cambios, obtiene y reconstruye

## Tipos

- structs
- class
- protocol
- Generics
- enum
- functions

### structs y class son similares

#### Similitudes

- Variables almacenadas
- Variables computadas o recetadas: obtenidas de funciones procesadas
- Constantes, lets: valores que nunca cambian
- Funciones: con label argumento y valores

```swift
func multiplicat (_ operando:Int, by otroOperando:Int) -> {
    return operand * otroOperando
}
```

- Initializers: funciones especiales que son llamadas cuando se crea el struct o la clase
  - Suerte de constructor
  - Pueden ser varios init

#### Diferencias entre Structs y Class

| struct                                                                             | class                                                                               |
| ---------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| Value type                                                                         | Reference type                                                                      |
| Copied when passed or assigned                                                     | Passed around via pointers                                                          |
| Copy on write                                                                      | Automatically reference counted                                                     |
| Functional programming                                                             | Object-oriented programming                                                         |
| No herencia                                                                        | Herencia (Single)                                                                   |
| FREE init initializers ALL vars                                                    | FREE init initializers NO vars                                                      |
| Mutability must be explicitly stated                                               | Always mutable                                                                      |
| Go to data structure                                                               | Used in specific circumstances                                                      |
| Everything you've seen so far is a struct (except VIEW which is **protocol** type) | The ViewModel in MVVM is always a class (also, UIKIT, OLD iOS STYLE) is class-based |

##### Struct es tipo valor

- Copiado cuando son pasados o asignadas
- Si se pasa un struct a una función o variable, es una copia, no una referencia
- No se comparten los valores
- **Arrays, Diccionarios, bools, doubles son structs** 
- Los structs fueron creados para programar funcionalidades: functional programming
- No permite herencia
- Una mezcla entre valores inicializados o no
- Mutabilidad, cambios de datos, deben ser explícitamente stated, definir que se hará con el valor
  - var vs let
- Siempre usada, es la primera forma de intentar hacer algo

##### Class es referencia

- Se pasan usando punteros
- Se pasan como referencia
- ARC: Automáticamente se cuentan las referencias
- Object-orientend programming: Encapsulan la data, la funcionalidad
- Permite herencia
- Todas las vars deben tener un valor para iniciar
- Los valores se pueden cambiar siempre, mutar
- Usado en situaciones específicas
- VIEWMODEL, in MVVM es siempre una clase
  - UIKIT
  - iOS antiguo

### Generics

- Algunas veces no nos importa el tipo: "dont't care" type
  - No lo sabemos
  - Y no nos importa saberlo
- Pero como swift es strong typed, hay que usar un **tipo obligadamente**

##### Array

- Contiene un grupo de elementos
- Puede haber lo que sea dentro de un Array

```swift
struct Array<Element> {
    ...
    func append(_ element:Element){...}
}
```

- Element no es struct, class o protocol, es solo un placeholder para un tipo

```swift
var miArreglo = Array<int>()
miArreglo.append(100)
```

- Se pueden tener múltiples don't care type

###### Type Parameter

- Referencia a tipos como Element en un Array como un "dont' care" type
- 

### Functions as Types

- Una variable o parámetro de una función puede ser declarado como una función
- Debe incluir los tipos de los argumentos
- Debe incluir el tipo de retorno

```swift
(Int, Int) -> Bool
(Double) -> Void()
() -> Array<String>
() -> Void
```

- Variables como funciones

```swift
var operacion: (Double) -> Double
func cuadrado(operand:Double) -> Double {
    return operand * operand:
}
let resulado = operacion(4) // retornará 16
// No se usan labels cuando se ejecutan estas funciones en variables
```

#### Closures

- Es común pasar una función que se puede como parámetro pero sin declararla en una variable

## Ejemplo

- Crear un archivo nuevo de tipo swift, NO UI

- Swift Source File

```swift
//
//  MemoryGame.swift
//  Memorize
//
//  Created by Hernán Beiza on 20-02-21.
//

import Foundation
```

### Uso de un tipo Don't Care

```swift
//Se debe declarar que se usa un Don't care type
struct MemoryGame <CardContent> {
    var cards:Array <Card>

    func choose (card:Card) -> Void {
        print("Card choosen: \(card)")
    }

    //Nesting Struct, struct inside struct. Pasar usar MemoryGame.Card
    struct Card {
        var isFaceUp: Bool;
        var isMatched: Bool;
        //var content: String;
        var content: CardContent; //Don't care type

    }

}
```

### Uso de Class

- ```swift
  import Foundation
  
  // Es una clase porque es data que quiero compartir
  // Usa punteros
  // Copiar data
  class EmojiMemoryGame {
    var model:MemoryGame<String>;
  }
  ```

```
- El problema de usar una clase es que si todas esas instancias es que comparten propiedades y comportamientos
- Otros objetos pueden ver las propiedades de las clases y cambiar los valores
  - Pero para esos existen los mutadores de accesos: private
  - Pero ahora nadie más puede acceder a este valor, así que habrá que definir que es visible desde afuera, otras clases, pero no pueden cambiar el valor

```swift
class EmojiMemoryGame {
    private (set) var model:MemoryGame<String>;
}
```

#### Inline function

```swift
//Inline function, closures: Captura cosas
private var model:MemoryGame<String> = MemoryGame<String>(numbersOfPairsOfCards:2, cardContentFactory: { (pairIndex: Int) -> String in
                                                                                                            return "🧐";
                                                                                                       });

//Lo mismo de arriba
private var model:MemoryGame<String> = MemoryGame<String>(numbersOfPairsOfCards:2) { pairIndex in "🧐" };
```
