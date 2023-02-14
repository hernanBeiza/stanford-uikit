# 11 Enroute Picker

- CS193P
- Spring 2020
- https://cs193p.sites.stanford.edu/
- https://www.youtube.com/watch?v=fCfC6m7XUew

## Topics

- NavigationView
- Filter
- Filter inside Form
- Togle

## NavigationView

### Botón para abrir un .sheet o Modal

- Vistas modal son .sheet 

```swift
var body: some View {
  NavigationView {
    FlightList(flightSearch)
    .navigationBarItems(leading: simulation, trailing: filter)
  }
}


@State private var showFilter = false

var filter: some View {
  Button("Filter") {
    self.showFilter = true
  }
  //Binding to @State showFilter, $showFilter
  .sheet(isPresented: $showFilter) {
    FilterFlights(flightSearch: self.$flightSearch, isPresented: self.$showFilter)
  }
}
```

- Botones en la barra de navegación de un NavigationView

```swift
var body: some View {
    NavigationView {
    Form {
      // Elementos UI acá
    }
        .navigationBarTitle("Filter Flights")
        .navigationBarItems(leading: cancel, trailing: done)
        }
}
// Vistas con un botón y la acción del botón
var cancel: some View {
  Button("Cancel") {
    //Cerrar el .sheet
    self.isPresented = false
  }
}
var done: some View {
  Button("Done") {
    // Actualizar la lista, etc
    self.isPresented = false
  }
}
```

### Picker

- Un Picker dentro de un form, cambia la forma en que se muestra
- Sin form, se muestra como la clásica rueda para seleccionar la hora:minutos por ejemplo
- Si se agrega un NavigationView permite navegar hacia la lista de elementos

#### Parámetros

- .pickerStyle(WheelPickerStyle()) permite mostrar un Picker como el clásico WheelPicker
- selection debe ser del mismo tipo que el tag

```swift
//selection es un Binding hacia el objeto, propiedad que se quiere guardar el elemento seleccionado
Picker("Destination", selection: $draft.destination) {
  ForEach(allAirports.codes, id: \.self) { airport in
  //.tag permite que al seleccionar un elemento se pase al Binding
    Text("\(self.allAirports[airport]?.friendlyName ?? airport)").tag(airport)
    }
}
```

### Togle

#### Parámetros

- Binding a la variable a cambiar
- Texto a mostrar

```swift
//Binding a la variable a cambiar
Toggle(isOn: $draft.inTheAir) { Text("Enroute Only") }
```
