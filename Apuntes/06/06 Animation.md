# 06 Animation

- CS193P
- Spring 2020
- https://cs193p.sites.stanford.edu/
- https://www.youtube.com/watch?v=3krC2c56ceQ&ab_channel=Stanford

## Topics

- Property Observers
  - Watching a Var
- @State
  - Usado en estados temporales, como alertas, edición de objetos o animación
- Animation
  - Implicit vs Explicit
  - Animación de Vistas
  - Transiciones
  - Animación de Shapes, formas

## Property Observers

- Forma de estar miranndo, atento a una variable y ejecutar algo cuando cambia

````swift
var isFaceUp: Bool {
	willSet {
	if newValue {
		startUsingBonusTime();
	} else {
		stopUsingBonusTime();
		}
	}
}
````

- newValue es una variable especial dentro de los Observers: Corresponde al nuevo valor que tomará la variable
- didSet permite manejar el valor anterior, oldValue, el valor antes de cambiar

- Las vistas son sólo Read Only
  - las variables son let en SwiftUI

### ¿Por qué?

- Mutabilidad, cuando las variables cambian
- Cuando algo cambia, se sabrá. De esta forma es más eficiente el redibujado
- Las vistas se supone que son stateless. Dibujan lo que el modelo entrega.
- Las vistas no deberían tener estado.

### ¿Cuándo las vistas necesitan state?

- **Temporal storage**
- En Modo Edición, por ejemplo, se recolecta data par un nuevo Intent
- Al mostrar una alerta o notificar al usuario
- Al animar algo, es algo temporal

### @State

- Las variables usadas para State se anotan con @State

````swift
@State private var somethingTemporary: SomeType // puede ser de cualquier tipo
````

- Cambios en la variable anotada con @Stage, gatillarán un redibujado en la vista si es necesario
- Es como un @ObservedObject

### ¿Cuándo una vista necesita un state?

- Esto toma espacio del heap
- Y cuando la vista se redibuja, el puntero se mueve hacia la nueva versión de la vista, no se perderá nada
- las variables read-write en una vista deben ser marcada con @State: Pero debe ser usado con sabiduría

## Animation

- Representación suave en la UI, por un periodo de tiempo, configurable
- De un cambio en alguna parte que **ya ha pasado**
- En caso contrario, las variables siempre estarían cambiando...
- UI/UX permite tomar la atención del usuario para que entienda que algo está cambiando

### ¿Qué cosas pueden ser animadas?

- Cambios en la vistas en contenedores que **están en la pantalla**
- Apariencias
- Cambios sobre los argumentos de la vista animable
- Cambios sobre los argumentos en las formas, Shapes

### ¿Cómo iniciar una animación?

#### Implicitamente

- Usando un viewModifier, .animation(Animation)
- Automatic animation
- Todos los ViewModifier serán animados
- Duration y Curve

````swift
Text("👻")
	.opacity(scary ? 1 : 0)
	.rotationEffect(Angle.degrees(upsideDown ? 180 : 0))
	.animation(Animation.easeInOut)
````

- Si scary o upssideDown cambia, la opacidad y rotación serán animadas
- Si no se llama al modificador .animation, los cambios aparecerían en pantalla inmediatamente
- ¡Atención! .animation no funcinoa de la misma forma en los contenedores de vistas. El contenedor de vista propagará a todas las vistas la animación
  - No es como .padding (solo se aplica en el contenedor), es más como .font (se aplica en todas las subvistas)

##### Animation

- Animation es un struct
- Permite controlar todo lo relacionado a la animación
  - duration
  - delay
  - repeat
  - curve
- Animation Curve: Controla la velocidad de la animación
  - .linear: Animación constante 
  - .easeInOut: Empieza lento, luego rápido y termina lento
  - .spring: Rebote al final de la animación

#### Explicitamente

- wrapping el código con **withAnimation(Animation){}** 
  - Animará todo el código concurrentemente

### Implicitamente vs Explicitamente

#### Implicitamente

- Aumatic no es la forma primaria
- Son usadas en vistas independientes generalmente
  - En vistas contenedoras, las animación son pasadas hacia las vitas hijas

#### Explicitamente

- Para el problema anterior, existen las animaciones explícitas
- Crean una animación en la misma sesión sobre un grupo de vistas
- Todos los cambios ocurrirán juntos
- Es un código imperativo en la vista, por lo que se usará en casos como .onTapGesture
- Son usadas en 
  - Intents
  - En cambios sobre la UI, como al entrar en modo de edicióñ
- **Animaciones explícitas no sobrecargan animaciones implícitas**

### Transitions

- Usados para entradas y salidas de vistas
  - FadeIn
- Es un par de ViewModifier sobre la vista
  - .before, antres de la modificación
  - .after, después de la modificación
- Es una manera de cambiar los argiumentos de un viewModifier

#### ¿Cómo especificar el ViewModifier a modificar?

- Usando el viewmodifier **.transition**

````swift
ZStack {
	if isFaceUp {
		RoundedRectangle()
		Text("👻").transition(.scale) 
    //default .transition is .opacity
	} else {
		RoundedRectangle(cornerRadius: 10).transition(.identity)
    //.identity no animation, aparece de una. No transition
	}
}
````

- Cuando la variable isFaceUp cambia
  - false, el fondo aparecerá inmediatamente y el texto se escalará de 1 a 0
  - true, el fondo desaparecerá inmediatamente y el texto aparecerá escalándose de 0 a 1
- Si dentro de un ViewBuilder se pueden usar condiciones para mostrar u ocultar vistas
- .transition no es como las animaciones implicitas. Si se aplica a un contenedor de vistas, las tarnsiciones se aplicarán sobre el elemento contenedor en sí y no sobre los hijos
  - Pero en el caso de Group y ForEach sí distribuyen las transiciones a las vistas hijos

- Las transiciones sólo ocurren **cuando hay un viewModifier especificado**
- Transition declara que ViewModificer modificar, pero **no ejecuta la animación**
- Las transitions no funcionan con animaciones implícitas. **Solo con explícitas**

- La API de Transitions es de tipo "Type Erased"
- **AnyTransition** borra cualquier info de tipos sobre ViewModifiers
  - AnyTransition.opacity	
  - AnyTransition.scale
  - AnyTransition.offset
  - AnyTransition.modifier(active:identity:) 
    - Transiciones personalizadas

- AnyTransition es un struct
- Se puede llamar directamente a .animation(Animation)
  - No es implicit animation

#### .onAppear

- Las transiciones funcionan solo cuando están presentes en las vistas
- Para ejecutar la función, la vista debe aparecer después de su contenedor
- ¿Cómo coordinar esto? .onAppear
- En la vista contenedor, se puede usar .onAppear
- Ejecutar un cambio en Model/ViewModel

````
.onAppear {
	.withAnimation { }
}
````

#### Shape and ViewModifier Animation

- Shapes y ViewModifier que quieran implementar el procotolo **animatable** deben implementar

```swift
var animatableData: Type
```

- Type es "Don't Care"
- Type debe implementar VectorArithmetic
  - Para poder usar la curva de la animacióñ
- Type es como un valor **decimal**, Float, double, CGFloat
- Hay un struct que implementa **VectorArithmetic** llamado **AnimatablePair**
- **AnimatablePair** combina dos **VectorArithmetic**en un **VectorArithmetic**
- Se pueden tener una estructura más compleja, AnimatablePairs de AnimatablePairs

- animatableData es read-write var
- **set** la variable le indica al sistema **que pieza dibujar**
- get la variable le indica al sistema los puntos de inicio y fin de la animación
- Usualmente es una variable computada
- Generalmente no se impelmenta animatableData en la Forma, Shape o ViewModifier, para poder usar un nombre más descriptivo de lo que se animará
  - Por lo que los set/get llamarán a otras variables

