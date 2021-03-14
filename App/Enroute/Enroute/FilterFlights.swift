//
//  FilterFlights.swift
//  Enroute
//
//  Created by CS193p Instructor on 5/12/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI

struct FilterFlights: View {
    @ObservedObject var allAirports = Airports.all
    @ObservedObject var allAirlines = Airlines.all

    // Estos no se pueden inicializar directamente acá
    @Binding var flightSearch: FlightSearch
    @Binding var isPresented: Bool

    // Variable borrador, acá sae realizan los cambnios y luego se copian al valor flightSearch
    @State private var draft: FlightSearch
    
    //Pasar un Binding en el constructor
    //Binding<TipoDeDatosQueLeCorrespondeAlBinding>
    init(flightSearch: Binding<FlightSearch>, isPresented: Binding<Bool>) {
        _flightSearch = flightSearch
        _isPresented = isPresented
        //no se puede usar self.draft - flightSearch, porque no  son del mismo tipo. Uno es FlightSearch y el otro @Binding
        _draft = State(wrappedValue: flightSearch.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            Form {
                //selection es un Binding hacia el objeto,propiedad que se quiere guardar el elemento seleccionado
                Picker("Destination", selection: $draft.destination) {
                    ForEach(allAirports.codes, id: \.self) { airport in
                        //.tag permite que al seleccionar un elemento se pase al Binding
                        Text("\(self.allAirports[airport]?.friendlyName ?? airport)").tag(airport)
                    }
                }
                Picker("Origin", selection: $draft.origin) {
                    // Agregar una vista extra al foreach para poder seleccionar una opción por defecto por ejemplo
                    //nil for optional strings
                    Text("Any").tag(String?.none)
                    //selection debe ser del mismo tipo que el tag sino no se mostrará nada
                    ForEach(allAirports.codes, id: \.self) { (airport: String?) in
                        Text("\(self.allAirports[airport]?.friendlyName ?? airport ?? "Any")").tag(airport)
                    }
                }
                Picker("Airline", selection: $draft.airline) {
                    Text("Any").tag(String?.none)
                    ForEach(allAirlines.codes, id: \.self) { (airline: String?) in
                        Text("\(self.allAirlines[airline]?.friendlyName ?? airline ?? "Any")").tag(airline)
                    }
                }
                //Binding a la variable a cambiar
                Toggle(isOn: $draft.inTheAir) { Text("Enroute Only") }
            }
            .navigationBarTitle("Filter Flights")
            .navigationBarItems(leading: cancel, trailing: done)
        }
    }
    
    var cancel: some View {
        Button("Cancel") {
            self.isPresented = false
        }
    }
    var done: some View {
        Button("Done") {
            // Pasar por refencia el borrador a la variable flightSearch y gatillar el redibujado
            self.flightSearch = self.draft
            self.isPresented = false
        }
    }
}

//struct FilterFlights_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterFlights()
//    }
//}
