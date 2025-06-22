//  SymptomsModel.swift
//  IntuitCodex
//
//  Created by user on 14/6/25.
//

import Foundation

struct Symptom: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var isPresent: Bool
}

struct StrokeSymptoms {
    var symptoms: [Symptom] = [
        Symptom(title: "Pérdida de fuerza o entumecimiento", isPresent: false),
        Symptom(title: "Dificultad para hablar", isPresent: false),
        Symptom(title: "Pérdida de sensibilidad u hormigueos en la mitad del cuerpo", isPresent: false),
        Symptom(title: "Pérdida de visión", isPresent: false),
        Symptom(title: "Confusión repentina", isPresent: false)
    ]
}
