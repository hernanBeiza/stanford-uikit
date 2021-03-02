# 07 Multithreading EmojiArt

- CS193P
- Spring 2020
- https://cs193p.sites.stanford.edu/
- https://www.youtube.com/watch?v=tmx-OwkBWxA&ab_channel=Stanford

## Topics

- Colors and Images
  - Colors vs UIColor
  - Image vs UIImage
- Multithreading Programming
  - App is never frozen
- EmojiArt Demo
  - Review MVVM
  - ScrollView
  - fileprivate
  - Drag and Drop
  - UIImage
  - Multithreadiong

## Colors vs UIColor Observers

#### Color

- Especificar color
- Es como ShapeStyle, .fill(Color.blue)
- View, Color.white
- API para la creación y comparación

#### UIColor

- More powerful
- Manipular color
- Funciones de manipulación de color
- RGBA
- OLD UIKit

### Image

- Es una vista, VIEW
- Muestra una imagen
- No es un tipo para vars. UIImage es esa var
- Permite acceder a las imágenes en Assets.xcassets using:

````swift
Image (_name: String);
````

- Acceder imágenes del sistema

````swift
Image(systemName: String);
````

- Se puede controlar el tamaño de la imagen, .imageScale() viewModifier
- Las imágenes del sistema se pueden usar como máscaras

### UImage

- Creacióñ y manipulacióñ de imágenes y almacenar en variables
- Muy poderoso para representar imágenes
- Múltiples formatos

````swift
Image(uiImage:)	
````

## Multithreading

- Permite construir aplicaciones que no bloqueen la UI
- **Nunca es bueno que una aplicación se bloquee, freezee, la UI**
- Para evitar eso, se puede usar Multithreading
- Pero a veces se necesita realizar acciones que toman tiempo
  - Consultas internet
  - Cálculos complejos

### Threads

- Hilo de ejecución
- Los sistemas operativos modernos permiten especificar el thread, el hilo de ejecución a usar
- Los hilos pueden parecer que se ejecutan simultáneamente, de hecho, en los sistemas multi-core se ejecutan así
- Algunos tienen mayor o menor prioridad

### Queues

- Colas
- El tiempo agrega una nueva dimensión al código
- Swift usa colas
- Un montón de bloques de código, alineados, esperando por un hilo para ejecutarse

#### Closures

- El ćodigo que se ejecuta en colas usa **clousures**
  - Funciones como argumentos

### Main Queue

- Queue más importante
- Todo lo relacionado a UI debe hacerse en esta queue
- Usar otra cola para la UI es un error

### Background Queues

- Long tasks
- Acá se ejecuta código que toma tiempo no relacionado a la UI
- Hay varios hilos que corren en segundo plano simultáneamente
- Correrá en paralela con la cola principal

### GCD

- Grand Central Dispatch
- Funciones que manejan todo lo relacionado a las colas

#### Obtener una cola

- DispatchQueue.main
  - Cola para dibujar algo en la UI
- DispatchQueue.global(los: QoS)
- qos(quality of service)
  - userInteractive
    - Super high priority queue
    - Interación de usuarios
    - hacerlo rápido, y obtener ahora
    - La UI depende de ello
  - userInitiated
    - El usuario solicita algo
    - Es iniciada por el usuario
  - utility
    - Se necesita que se ejecuta
    - El usuario no lo solicitó
  - background
    - Tareas de mantenimiento
    - Limpieza

#### Poner una función o código en una cola

- Hay dos formas básicas de hacerlo

````swift
let queue = DispatchQueue.main or DispatchQueue.global(qos;)
queue.async { /* Código a ejecutar en segundo plano */ }
queue.sync { /* Código a ejecutar en primer plano */}
````

- queue.sync { /* Código a ejecutar en primer plano */}
  - Bloquea esperando que el código sea tomado por la cola y completado
  - No debe ser usado en la UI, porque bloque la UI
  - Debe ser llamado solo en la cola en segundo plano
- queue.async { /* Código a ejecutar en segundo plano */ }
  - Generalmente usado
  - Ejecutará el código en algún momento mas adelante
  - El código debe ser tolerando para recibir ese término del código

### Nesting

````swift
DispatchQueue(global: .userInitiated).async {
	//API Rest
  //No bloqueará la UI
  //En algún momento deberá actualizar la UI
  //Pero no se puede ejecutar el código directamente acá, porque está en otro hilo
  DispatchQueue.main.async {
    //Se actualiza la UI
  }
}
````

- Parece código sincrónico, pero no lo es
- Si pasa mucho tiempo, hay que tenenr especial atención con lo que se hará sobre la UI para notificar

### Asynchronous API

````swift
DispatchQueue.main.async {
	//Background
}
````

- DispatchQueue.global(qo:) no se usa tanto como se piensa
- Ya que muchas de las APIs de iOS están a un nivel superior, entonces automáti amente trabajan en una de las dos colas
- URLSession
  - Obtiene data desde una URL, internet y luego la retorna cuando está lista
  - Pero de todas maneras , si se desea realizar algo sobre la UI, se debe llamar a DispatchQueue.main.async { } para actualizar la UI

