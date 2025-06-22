//
//  NIHSSView.swift
//  IntuitCodex
//
//  Created by user on 14/6/25.
//

import SwiftUI

struct NIHSSItem: Identifiable {
    let id = UUID()
    let title: String
    let options: [String]
    var selectedIndex: Int?
}

struct NIHSSView: View {
    @State private var items: [NIHSSItem] = [
        NIHSSItem(title: "Nivel de conciencia", options: ["Alerta", "Somnoliento", "Estuporoso", "Coma"]),
        NIHSSItem(title: "Orientación", options: ["Ambas correctas", "Una correcta", "Ninguna"]),
        NIHSSItem(title: "Órdenes LOC", options: ["Ambas tareas", "Una tarea", "Ninguna"]),
        NIHSSItem(title: "Mirada", options: ["Normal", "Parálisis parcial", "Desviación"]),
        NIHSSItem(title: "Campos visuales", options: ["Sin déficit", "Cuadrantanopsia", "Hemianopsia", "Ceguera"]),
        NIHSSItem(title: "Parálisis facial", options: ["Normal", "Ligera", "Parcial", "Completa"]),
        NIHSSItem(title: "Brazo izquierdo", options: ["No claudica", "Claudica", "Algo de esfuerzo", "Sin esfuerzo", "Ningún movimiento"]),
        NIHSSItem(title: "Brazo derecho", options: ["No claudica", "Claudica", "Algo de esfuerzo", "Sin esfuerzo", "Ningún movimiento"]),
        NIHSSItem(title: "Pierna izquierda", options: ["No claudica", "Claudica", "Algo de esfuerzo", "Sin esfuerzo", "Ningún movimiento"]),
        NIHSSItem(title: "Pierna derecha", options: ["No claudica", "Claudica", "Algo de esfuerzo", "Sin esfuerzo", "Ningún movimiento"]),
        NIHSSItem(title: "Ataxia de miembros", options: ["Ausente", "Una extremidad", "Dos extremidades"]),
        NIHSSItem(title: "Sensibilidad", options: ["Normal", "Hipoestesia", "Anestesia"]),
        NIHSSItem(title: "Lenguaje", options: ["Normal", "Afasia leve", "Afasia grave", "Mutismo"]),
        NIHSSItem(title: "Disartria", options: ["Normal", "Moderada", "Anartria"]),
        NIHSSItem(title: "Extinción", options: ["Ninguna", "Parcial", "Completa"])
    ]

    var body: some View {
        NavigationView {
            Form {
                ForEach(items.indices, id: \.self) { index in
                    Section(header: Text(items[index].title)) {
                        Picker(selection: $items[index].selectedIndex, label: Text("Selecciona")) {
                            ForEach(items[index].options.indices, id: \.self) { optIndex in
                                Text(items[index].options[optIndex])
                                    .tag(optIndex as Int?)
                            }
                        }
                        .pickerStyle(.inline)
                    }
                }

                Section {
                    Button("Ver puntuación total") {
                        // acción futura
                    }
                    .disabled(items.contains { $0.selectedIndex == nil })
                }
            }
            .navigationTitle("Escala NIHSS")
        }
    }
}

#Preview {
    NIHSSView()
}
