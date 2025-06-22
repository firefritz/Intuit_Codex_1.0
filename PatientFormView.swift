//
//  PatientFormView.swift
//  IntuitCodex
//
//  Created by user on 14/6/25.
//

import SwiftUI

struct PatientFormView: View {
    @State private var nombre = ""
    @State private var edad = ""
    @State private var sexo = "Masculino"
    @State private var peso = ""
    @State private var nhc = ""
    @State private var ultimaVezAsintomatico = Date()
    @State private var navigateToVitals = false

    let sexos = ["Masculino", "Femenino"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Datos del paciente")) {
                    TextField("Nombre", text: $nombre)
                    TextField("Edad", text: $edad)
                        .keyboardType(.numberPad)
                    Picker("Sexo", selection: $sexo) {
                        ForEach(sexos, id: \.self) { Text($0) }
                    }
                    TextField("Peso (kg)", text: $peso)
                        .keyboardType(.decimalPad)
                    TextField("NHC", text: $nhc)
                    DatePicker("Última vez asintomático", selection: $ultimaVezAsintomatico, displayedComponents: .hourAndMinute)
                }

                Button(action: {
                    navigateToVitals = true
                }) {
                    Text("Continuar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Formulario de paciente")
            .navigationDestination(isPresented: $navigateToVitals) {
                VitalsView()
            }
        }
    }
}

#Preview {
    PatientFormView()
}
