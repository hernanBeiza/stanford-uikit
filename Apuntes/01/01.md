# 01 Course Logitistics and Introduction to SwiftUI

## Creando proyecto

- Demos: Muchos

- Lectures Sliders: Conceptos
- Reading Assignments: Para aprender

Herramientas

- Xcode 11.4

Crear aplicación Xcode

- Name: Memorize
- Team
  - Agregar un Apple ID

- Organization Name: CS193p Instructor
  - Agregar un Apple ID
  - 
- Organization Identifier: Reverse domain name
  - cl.hiperactivo.memorize
- Languaje: Swift
- 

![Creando proyecto](01/image-20210220120549409.png)

## Revisando el Código

````swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Welcome back to iOS world HB!")
            .padding()
    }
}
````

- Depende de Foundations
- Al escirbir cosas UI, se implementa SwiftUI
- Si no se necesita escribir temas UI, probablemente se importaría Foundation
- Structs, contenedores de Variables son mas poderosos que en otros lenguajes como C
  - Pueden tener comportamiento
  - Variables
  - Funciones

````swift
struct ContentView: View { }
````

- Programación funcional
- Se comportará como View
- ContentView es la ventana completa, la que contiene todo

````swift
var body: some View {
  //Retorna estos valores cada vez que el sistema los solicita
  Text("Welcome back to iOS world HB!")
  .padding()
}
````

- En swift, una varuable se define con **var**
- Pero dentro de los structs, vars, en realidad es una propiedad. No **variable**
- **some** es un tipo de dato genérico, que indica que es parte de alguna, some, vista, view
  - Las vistas, view, son como legos. Se van uniendo
  - De esta forma se puede retornar una vista combinada, a **CombinerView**, que podría contener muchas vistas: Esto permitirá construir vistas más complejas
  - Esta vista **combinada** no se almacena en memoria, es procesada siempre
  - El sistema pregunta por el valor de la variable body, se preocesa y retorna la vista combinada
  - Es como un **return** de una función.

````swift
struct ContentView: View {
    var body: some View {
        return Text("Welcome back to iOS world HB!")
            .padding()
    }
}
````



- some View, le dice al compilador que averigue el mismo el tipo de dato que debe
- Swift es Strong Typed. No es como Javascript
  - Cada variable tiene un tipo específico
- cornerRadius es el nombre del **argumento** de la **función RoundedRectangle**

````swift
struct ContentView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10.0)
    }
}
````

### ZStack

- Stack es una vista combinada, CombinerView
- Sirve para apilar vistas, se puede usar ZStack

````swift
struct ContentView: View {
    var body: some View {
        return ZStack(content: {
            RoundedRectangle(cornerRadius: 10.0).stroke()
          //stroke() es una función que pinta sólo el borde de la forma, del objeto Shape, del cual hereda RoundedRectangle
            Text("👻")
        })
    }
}
````

#### Propiedades de las vistas

- .foregroundColor(.orange)
- .stroke()

````swift
struct ContentView: View {
    var body: some View {
        return ZStack(content: {
            RoundedRectangle(cornerRadius: 10.0).stroke()
            Text("👻")
        }).foregroundColor(.orange)
    }
}
````

### ForEach

- Otro tipo de Vista combinada
- Permite mostrar varios elementos, iterar

````swift
struct ContentView: View {
    var body: some View {
        //No incluye el 4
        return ForEach(0..<4, content:{ index in
            ZStack(content: {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                Text("👻").font(Font.largeTitle)
            })
            .padding()
            .foregroundColor(.orange)
        })
    }
}

````

- El depurador mostrará cada vista diferente
- hay que poner esta vista en otra vista combinada, llamada HStack

### HStach

- VistaCombinada
- Permite mostrar los elementos 

````swift
struct ContentView: View {
    var body: some View {
        //Vista combinada
        return HStack(content: {
            //No incluye el 4
            ForEach(0..<4, content:{ index in
                //Vista combinada
                ZStack(content: {
                    RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                    RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                    Text("👻").font(Font.largeTitle)
                })
            })
        })
        .padding()
        .foregroundColor(.orange)
    }
}

````

- Swift permite elminar los nombres de los argumentos cuando sólo hay uno

````swift

struct ContentView: View {
    var body: some View {
        //Vista combinada
        return HStack{
            //No incluye el 4
            ForEach(0..<4, content:{ index in
                //Vista combinada
                ZStack{
                    RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                    RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                    Text("👻").font(Font.largeTitle)
                }
            })
        }
        .padding()
        .foregroundColor(.orange)
    }
}
````

## Refactorizando los Structs

- Se pueden crear más structs como VistaCombinada, CombinerView, para refactorizar
- Los structs necesitan que las propiedades estén definididas
- En caso contrario habrá que agregar la propiedad y su valor inicializado

````swift

struct ContentView: View {
    var body: some View {
        //Vista combinada
        return HStack{
            //No incluye el 4
            ForEach(0..<4, content:{ index in
                //Definir el valor de esta variable
                CardView(isFaceUp: true)
            })
        }
        .padding()
        .foregroundColor(.orange)
    }
}

struct CardView: View {
    //Si la variable no tiene valor o no es inicializada, al instanciar el objeto pedirá el valor como argumento
    var isFaceUp:Bool
    var body: some View {
        //Vista combinada
        ZStack{
            if isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                Text("👻").font(Font.largeTitle)
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }
    }
}
````

