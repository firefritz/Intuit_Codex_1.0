//
//  VitalsView.swift
//  IntuitCodex
//
//  Created by user on 14/6/25.
//

import SwiftUI

struct VitalsView: View {
    @ObservedObject var patient: PatientDataModel
    @State private var navigateToNIHSS = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Constantes clínicas")) {
                    TextField("Frecuencia cardíaca (bpm)", value: Binding(get: { patient.heartRate ?? 0 }, set: { patient.heartRate = $0 }), formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    TextField("Tensión arterial sistólica (mmHg)", value: Binding(get: { patient.systolicBP ?? 0 }, set: { patient.systolicBP = $0 }), formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    TextField("Tensión arterial diastólica (mmHg)", value: Binding(get: { patient.diastolicBP ?? 0 }, set: { patient.diastolicBP = $0 }), formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    TextField("Glucemia (mg/dL)", value: Binding(get: { patient.glucose ?? 0 }, set: { patient.glucose = $0 }), formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                    TextField("Temperatura (°C)", value: Binding(get: { patient.temperature ?? 0 }, set: { patient.temperature = $0 }), formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                    TextField("Plaquetas (x10³/µL)", value: Binding(get: { patient.platelets ?? 0 }, set: { patient.platelets = $0 }), formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    Stepper(value: $patient.rankinPrevia, in: 0...5) {
                        Text("Escala Rankin previa: \(patient.rankinPrevia)")
                    }
                }

                Section(header: Text("Criterios automáticos (según parámetros clínicos)")) {
                    Text(evaluateVitalsRules())
                        .foregroundColor(.red)
                        .font(.subheadline)
                }

                Button(action: {
                    navigateToNIHSS = true
                }) {
                    Text("Continuar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Constantes Clínicas")
            .navigationDestination(isPresented: $navigateToNIHSS) {
                NIHSSView()
            }
        }
    }

    private func evaluateVitalsRules() -> String {
        var messages: [String] = []

        if let sys = patient.systolicBP, let dia = patient.diastolicBP {
            if sys > 185 || dia > 105 {
                messages.append("⚠️ TA > 185/105: Contraindicación para trombolisis IV si no controlada.")
            }
        }

        if let glucose = patient.glucose {
            if glucose < 50 || glucose > 400 {
                messages.append("⚠️ Glucemia fuera de rango (<50 o >400): Excluye trombolisis.")
            }
        }

        if let platelets = patient.platelets {
            if platelets < 100_000 {
                messages.append("⚠️ Plaquetas < 100.000: Contraindicación para trombolisis IV.")
            }
            if platelets < 50_000 {
                messages.append("❌ Plaquetas < 50.000: Contraindica también tratamiento endovascular.")
            }
        }

        if let nihss = patient.nihssScore {
            if nihss < 4 {
                messages.append("❌ NIHSS < 4: No candidato a trombolisis.")
            } else if nihss < 6 {
                messages.append("ℹ️ NIHSS < 6: Candidato a trombolisis IV solamente.")
            } else {
                messages.append("✅ NIHSS ≥ 6: Candidato a trombolisis IV y tratamiento endovascular.")
            }
        }

        if let onsetTime = patient.timeSinceOnsetHours {
            if onsetTime > 24 {
                messages.append("❌ Tiempo de evolución > 24h: Excluido del código ictus.")
            } else if onsetTime > 4.5 {
                messages.append("ℹ️ Tiempo > 4.5h: No trombolisis IV, valorar tratamiento endovascular.")
            } else {
                messages.append("✅ Tiempo < 4.5h: Apto para trombolisis IV.")
            }
        }

        return messages.isEmpty ? "✅ Parámetros dentro de rango para trombolisis/endovascular." : messages.joined(separator: "\n")
    }
}

#Preview {
    VitalsView(patient: PatientDataModel())
}
