# 04 Grid + enum + Optionals

- CS193P
- Spring 2020
- https://cs193p.sites.stanford.edu/
- https://www.youtube.com/watch?v=eHEeWzFP6O4&ab_channel=Stanford

## Topics

- Grid
  - Generics with protocols
  - Functions as types
  - Container View
- Types
  - Enums
- Optional
  - Important type in Swift

### Enums

- Otro tipo de estructura de datos
- Como struct o class
- Pero sólo puede tener estados estáticos

`````swift
enum FastFoodMenuItem {
  case hamburger(numberOfPatties: Int)
  case fries(size: FryOrderSize)
  case drink(String, ounces:Int) //se puede tener parámetro sin nombre, en este caso es la marca
  case cookie
}

enum FryOrderSize {
  case large
  case small
} 
`````

#### Setear valor de un enum

`````swift
let menuItem: FastFoodMenuItem = FastFoodMenuItem.hamburger(patties:2);
let otherItem: FastFoodMenuItem = FastFoodMenuItem.cookie;
`````

- Swift puede inferir desde dónde obtener el valor, pero al menos debe estar definido el tipo de dato en alguno de los dos lados de la asignación

````swift
//OK
let menuItem: FastFoodMenuItem = FastFoodMenuItem.hamburger(patties:2);
let otherItem: FastFoodMenuItem = .cookie;
//Error, no puede inferir
let yetAnotherItem = .cookie;
````

- Como checkear el valor: Usando swith

````swift
var menuItem = FastFoodMenuItem.hamburger(patties:2)
switch menuItem {
	case FastFoodMenuItem.hamburger: print("burger")
	case FastFoodMenuItem.fries: print("fries")
  case FastFoodMenuItem.drink: print("drink")
	case FastFoodMenuItem.cookie: print("cookie")
}
//Se podrían inferir los tipos
````

- Es necesario usar break

````swift
var menuItem = FastFoodMenuItem.hamburger(patties:2)
switch menuItem {
	case .hamburger: break
	case .fries: print("fries")
  case .drink: print("drink")
	case .cookie: print("cookie")
}
//No imprimirá nada por consola
````

- Default 

````swift
var menuItem = FastFoodMenuItem.cookie
switch menuItem {
	case .hamburger: break
	case .fries: print("fries")
  case .drink: print("drink")
	default .print("other")
}	
````

- Para poder obtener los valores de variables, trabajar con la data asociada

````swift
var menuItem = FastFoodMenuItem.drink("Coke", ounces: 32)
switch menuItem {
	case .hamburger: (let pattyCount): print ("a burger with \(pattyCount) patties!")
	case .fries: (let size): print("a \(size) order of fries!")")
	case .drink: (let brand, let ounces): print("a \(ounces)oz \(brand)")
	default .cookie("a cookie!")
}	
````

- Se pueden tener métodos en los enums y variables computadas, pero no valores almacenados

````swift
enum FastFoodMenuItem {
  case hamburger(numberOfPatties: Int)
  case fries(size: FryOrderSize)
  case drink(String, ounces:Int) //se puede tener parámetro sin nombre, en este caso es la marca
  case cookie
  
  func isIncludedInSpecialOrder(numer: Int) -> Bool {}
  var calories : Int { 
    //switch on self and calculate caloric value here 
  }
}
````

- Si hay una función, se pueden usar los valores del mismo switch usando self

````swift
enum FastFoodMenuItem {
  case hamburger(numberOfPatties: Int)
  case fries(size: FryOrderSize)
  case drink(String, ounces:Int) //se puede tener parámetro sin nombre, en este caso es la marca
  case cookie
  
  func isIncludedInSpecialOrder(numer: Int) -> Bool {
    switch self {
      case .hamburger(let pattyCound): return pattyCount == number
      case . fries, .cookie: return true
      case .drink(_, let ounces): return ounces == 16
    }
  }
  var calores : Int { 
    //switch on self and calculate caloric value here 
  }
}
````

- Se pueden iterar sobre los estados de un enum implementando CaseIterable

````swift
enum TeslaModel: CaseIterable {
	case X
	case S
	case Three
	case Y
}
````

- Ahora tendrá una variable static llamada allCases iterable

````swift
for model in TeslaModel.allCases {
	reportSalesNumbers(for: model)
}
func reportSalesNumbers(for model: model){
	switch model {...}	
}
````

### Optional

- ¡Muy importante en Switch!
- Es un enum

````swift
enum Optional <T> { //A generic like Array<Element>
	case none
  case some(T) //Don't care type
}
````

- Puede tener sólo dos valores 
  - is set (some)
  - not set(none)

##### ¿Cuándo usar Optionals? 

- Cuando hayan valores not Set o sin especificar o undetermined
- Cuando exista una función que deba retornar un valor pero no lo encontró, se podría retornar algo 
- Syntactic sugar

#### Syntactic Sugar

- Declarar 

```swift
var hello: String?
//Lo de arriba sería algo así:
var hello:Optional<String> = .none
```

- Asignar un valor a un optional

```swift
var hello: String? = "Hola"
//Lo de arriba sería algo así:
var hello:Optional<String> = .some("Hola")
```

- Asignar null, nil

```swift
var hello: String? = nil
//Lo de arriba sería algo así:
var hello:Optional<String> = .none
```

- Optional implicita nil, si no se define valor, será nil

- Se puede acceder al valor usando exclamación !

````swift
let hello:String? = ...
print(hello!)
Si la variable no tiene valor, habrá una excepción

//Esto sería en enum
switch hello {
  case .none: // crash
  case .some(let data): print(data)
}
````

- O usar una variable segura para evitar ese problema y usarlo en el interior del if

````swift
if let safeHello = hello {
	print(safeHello);
} else {
	//do something
}

//Esto sería en enum
switch hello {
  case .none: { // do something else }
  case .some(let data): print(data)
}
````

- Optional defaulting
  - nil coalescing operator

````swift
let x:String? = ...
let y = x ?? "foo"

//Esto sería en enum
switch x {
  case .none: y = "foo"
  case .some(let data): y = data
}
````

#### Unwrapping

````swift
//Agregar una extensión al tipo Array que tiene elementos Identifiable
extension Array where Element: Identifiable {
    //Optional Int
    func firstIndex(matching:Element) -> Int? {
        for index in 0..<self.count{
            if self[index].id == matching.id {
                return index;
            }
        }
        return nil;
    }
}

//Unwrapping
//Si no encuentra valor, será nil y debería caerse. Que sea nil no siempre es malo, indica que algo malo está pasando
//Group retorna una vista vacía, es un ViewBuilder
func body (for item:Item, in layout:GridLayout) -> some View {
  let index = items.firstIndex(matching: item);
  return Group {
    if index != nil {
      viewForItem(item).frame(width: layout.itemSize.width, height: layout.itemSize.height).position(layout.location(ofItemAt:index!))
    }
  }
}
````

