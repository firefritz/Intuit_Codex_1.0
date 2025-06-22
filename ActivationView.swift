import SwiftUI

struct ActivationView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()

                Image(systemName: "heart.text.square")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.blue)

                Text("Intuit Codex")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Aplicación médica para activación del Código ICTUS")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                NavigationLink(destination: Text("Evaluación iniciada")) {
                    Text("Activar Código ICTUS")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                Text("⚠️ Esta app es solo para uso sanitario profesional")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ActivationView()
}
