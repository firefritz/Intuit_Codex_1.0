import SwiftUI

struct SymptomsView: View {
    @State private var selectedSymptoms: Set<String> = []
    @State private var navigateToNext = false

    let symptoms = [
        "Pérdida de fuerza o entumecimiento",
        "Dificultad para hablar",
        "Hormigueos en la mitad del cuerpo",
        "Pérdida de visión",
        "Confusión repentina"
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("¿Presenta alguno de los siguientes síntomas?")
                    .font(.title2)
                    .fontWeight(.bold)

                ForEach(symptoms, id: \.self) { symptom in
                    Button(action: {
                        withAnimation {
                            if selectedSymptoms.contains(symptom) {
                                selectedSymptoms.remove(symptom)
                            } else {
                                selectedSymptoms.insert(symptom)
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: selectedSymptoms.contains(symptom) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedSymptoms.contains(symptom) ? .green : .gray)
                            Text(symptom)
                        }
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                Spacer()

                Button(action: {
                    if !selectedSymptoms.isEmpty {
                        navigateToNext = true
                    }
                }) {
                    Text("Continuar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedSymptoms.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(selectedSymptoms.isEmpty)
            }
            .padding()
            .navigationTitle("Código ICTUS")
            .navigationDestination(isPresented: $navigateToNext) {
                PatientFormView()
            }
        }
    }
}

struct DebugNavigationView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("🧠 Síntomas")) {
                    NavigationLink("1️⃣ SymptomsView", destination: SymptomsView())
                }
                Section(header: Text("👤 Datos del Paciente")) {
                    NavigationLink("2️⃣ PatientFormView", destination: PatientFormView())
                    NavigationLink("3️⃣ VitalsView", destination: VitalsView())
                }
                Section(header: Text("🧪 Escalas y Evaluaciones")) {
                    NavigationLink("4️⃣ NIHSSView", destination: NIHSSView())
                }
                Section(header: Text("📋 Resultados y Sensores")) {
                    NavigationLink("5️⃣ ClinicalSummaryView", destination: ClinicalSummaryView())
                    NavigationLink("6️⃣ SensorCaptureView", destination: AnyView(SensorCaptureView()))
                }
            }
            .navigationTitle("🔧 Debug Navegación")
        }
    }
}

#Preview {
    DebugNavigationView()
}
