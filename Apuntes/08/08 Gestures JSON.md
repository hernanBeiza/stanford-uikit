# 08 Gestures JSON

- CS193P
- Spring 2020
- https://cs193p.sites.stanford.edu/
- https://www.youtube.com/watch?v=mz-rNLWJ0bk&ab_channel=Stanford

## Topics

- UserDefaults: Simple and lightweight persistence
- Gestures  

### Persistence

- In filesystem: Filemanager
- SQl database: CoreData for OOP
- iCloud: All iOS devices
- CloudKit: A databse in the cloud

#### UserDefaults: Persisten Dictionary

- Usar para pequeñas cosas, como Preferencias de usuario....
- Nunca para guarar documentos
- Es limitado

- 

#### Datatypes

- Es una API Antigua
- Property Lists es el concepto
- Se pueden guardar String, Ing, Bool, floating points, date, data, array o diccionarios
- Otras cosas hay que convertirla a una de los tipos definidos arriba
- Codable convierte STRUCTS en objetos DATA
- UserDefaults usa ANY, pero porque es una API antigua



````swift
let defaults = UserDefaults.standard
// Se obtiene toda la data de la app


````

- Para guardar data

```swift
let defaults = UserDefaults.standard
default.set(object, forKey:"SomeKey")
//Es como un diccionario. forKey permite obtenerlo después
```

- Para guardar data de tipo numérico

````swift
defaults.setDouble(37.5, forKey:"MyDouble")p;
````

- Para obtener data

````swift
let i:Int = defaults.integer(forKey:"MyInteger");
let d:Data? = defaults.data(forKey:"MyData");
let u:Url? = defaults.url(forKey:"MyURL");
let strings:[String]? = defaults.stringArray(forKey:"MyString");
// Si no encuentra nada, retornará nil
````

- Si no encuentra nada, retornará nil
- Obtener arrays de algo

````swift
let a = defaults.array(forKey:"MyArray");
````

- Retornará un Array<Any>
- Habría que hacer un TypeCasting usando as
- Codable puede transformar data(forKey:) en lo que sea necesario



### Gestures

- Obtener input del usuario
- Multitouch
- SwiftUI permite reconocer los gestos del usuario
- Hay que manejar, handle, los gestos: Definir que se quiere realizar cuando se reconoce un gesto realizado

#### Una vista reconoce un gesto

````swift
myView.gesture(theGesture)
// theGesture debe implementar el protocolo Gesture
````

#### Crear un gesto

- Usar una función o una variable calculada

```swift
var theGesture: some Gesture {
  //some permite implementar retornar lo que sea que se requiere siempre cuando implemente el protocolo Gesture
	return TapGesture(count:2);
}
// Reconocerá el dopuble tap, por eso 2
```

#### Como manejar el gesto

##### Tipos de gestos

###### Gestos discretos

- El gesto ocurre y debe hacer algo

````swift
var theGesture: some gesture. {
  return TapGesture(count:2)
  	.onEnded {
  		//Hacer algo cuando termina el doble tap
  }
}
````

- Los gestos discretos se pueden implementar de una forma mas conveniente también:

```swift
myView.onTapGesture(count:Int) { /* hacer algo */}
myView.onLongPressGesture(count:Int) { /* hacer algo */}
```

###### Gestos no discretos

- No hay que manejar cuando se reconoce el gesto, sino también cuando se está ejecutando (los dedos se están moviendo en ese momento)
- Ejemplos
  - DragGesture
  - MagnificationGesture
  - RotationGesture
  - LongPressGesture
- Cuando el gesto termina:

```swift
var theGesture: some Gesture {
	DragGesture(...)
		.onEnded { value in  /* Ejecutar algo acá */}
}
```

- .onEnded retorna un parámetro, value
- Ese valor permite saber el estado del Gesto, identificar que pasa con ese gesto, cuando se termina
- DragGesture: struct con la posición inicial y final de los dedos
  - start
  - end
- MagnificationGesture: escala de zoom, cuánto se separaron los dedos
  - scale
- RotationGesture: Ángulo de rotación
  - Angle

- En los gestos no discretos, se puede realizar algo mientras se está ejecutando
- En cada momento que algo cambie, se puede actualizar un estado

````swift
@Gesture var myGestureState: MyGestureStateType = <starting value>
````

- Variable de cualquier tipo
- Mientras el gesto está suciendo, se puede cambiar el estado

````swift
var theGesture: some Gesture {
	DragGesture(...)
		.updating($myGestureState) { value, myGestureState, transaction in 
		myGestureState = /* Algo relacionado al value */
		}
		.onEnded { value in  /* Ejecutar algo acá */}
}
````

- .updating es un clousure que se ejecuta cuando está sucediendo el gesto
- $ es la variable del estado @GestureState var
- value: Parámetro del closure. Es el mismo valor que en el closure .onEnded.
- myGestureState : Parámetro del closure. @GestureState. 
  - **Sólo acá se puede cambiar el valor del state**
  - No se puede cambiar el valor del state ya que solo se debe estar activo cuando el Gesture está en ejecución
- transaction: Parámetro relacionado a animación

````swift
var theGesture: some Gesture {
	DragGesture(...)
		.onChanged{ value in 
			/* Hacer algo relacionado al value */
		}
		.onEnded { value in  /* Ejecutar algo acá */}
}
````

- Esto sirve solo si se necesita la posición actual. 
- Pero generalmente se necesitan los valores relativos:
  - Que tan lejos se movieron los dedos
- 