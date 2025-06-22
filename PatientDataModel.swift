//
//  PatientDataModel.swift
//  IntuitCodex
//
//  Created by user on 15/6/25.
//

import Foundation

// MARK: - Patient Data Model
final class PatientDataModel: ObservableObject, Identifiable, Codable {
    let id = UUID()
    
    // MARK: - Published properties (Clinical Data)
    @Published var timeSinceOnsetHours: Double
    @Published var systolicBP: Double
    @Published var diastolicBP: Double
    @Published var glucose: Double
    @Published var platelets: Int
    @Published var nihssScore: Int
    @Published var age: Int
    @Published var rankinPrevia: Int
    
    @Published var bpControlled: Bool
    @Published var onHBP: Bool
    @Published var onHeparin: Bool
    @Published var ttpProlonged: Bool
    @Published var onACO: Bool
    @Published var acoType: ACOType
    @Published var hoursSinceLastDose: Double
    @Published var inr: Double
    
    @Published var heartRate: Double
    @Published var temperature: Double
    
    @Published var clinicalNotes: String
    @Published var vitalsHistory: [PatientVitalsSnapshot]
    
    enum CodingKeys: String, CodingKey {
        case id, timeSinceOnsetHours, systolicBP, diastolicBP, glucose, platelets,
             nihssScore, age, rankinPrevia, bpControlled, onHBP, onHeparin,
             ttpProlonged, onACO, acoType, hoursSinceLastDose, inr,
             heartRate, temperature, clinicalNotes, vitalsHistory
    }
    
    // Initializer with default values
    init(
        timeSinceOnsetHours: Double = 0.0,
        systolicBP: Double = 0.0,
        diastolicBP: Double = 0.0,
        glucose: Double = 0.0,
        platelets: Int = 150_000,
        nihssScore: Int = 0,
        age: Int = 0,
        rankinPrevia: Int = 0,
        bpControlled: Bool = true,
        onHBP: Bool = false,
        onHeparin: Bool = false,
        ttpProlonged: Bool = false,
        onACO: Bool = false,
        acoType: ACOType = .NACO,
        hoursSinceLastDose: Double = 0.0,
        inr: Double = 1.0,
        heartRate: Double = 0.0,
        temperature: Double = 36.5,
        clinicalNotes: String = "",
        vitalsHistory: [PatientVitalsSnapshot] = []
    ) {
        self.timeSinceOnsetHours = timeSinceOnsetHours
        self.systolicBP = systolicBP
        self.diastolicBP = diastolicBP
        self.glucose = glucose
        self.platelets = platelets
        self.nihssScore = nihssScore
        self.age = age
        self.rankinPrevia = rankinPrevia
        self.bpControlled = bpControlled
        self.onHBP = onHBP
        self.onHeparin = onHeparin
        self.ttpProlonged = ttpProlonged
        self.onACO = onACO
        self.acoType = acoType
        self.hoursSinceLastDose = hoursSinceLastDose
        self.inr = inr
        self.heartRate = heartRate
        self.temperature = temperature
        self.clinicalNotes = clinicalNotes
        self.vitalsHistory = vitalsHistory
    }
    
    // MARK: - Methods

    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        timeSinceOnsetHours = try container.decode(Double.self, forKey: .timeSinceOnsetHours)
        systolicBP = try container.decode(Double.self, forKey: .systolicBP)
        diastolicBP = try container.decode(Double.self, forKey: .diastolicBP)
        glucose = try container.decode(Double.self, forKey: .glucose)
        platelets = try container.decode(Int.self, forKey: .platelets)
        nihssScore = try container.decode(Int.self, forKey: .nihssScore)
        age = try container.decode(Int.self, forKey: .age)
        rankinPrevia = try container.decode(Int.self, forKey: .rankinPrevia)

        bpControlled = try container.decode(Bool.self, forKey: .bpControlled)
        onHBP = try container.decode(Bool.self, forKey: .onHBP)
        onHeparin = try container.decode(Bool.self, forKey: .onHeparin)
        ttpProlonged = try container.decode(Bool.self, forKey: .ttpProlonged)
        onACO = try container.decode(Bool.self, forKey: .onACO)
        acoType = try container.decode(ACOType.self, forKey: .acoType)
        hoursSinceLastDose = try container.decode(Double.self, forKey: .hoursSinceLastDose)
        inr = try container.decode(Double.self, forKey: .inr)

        heartRate = try container.decode(Double.self, forKey: .heartRate)
        temperature = try container.decode(Double.self, forKey: .temperature)

        clinicalNotes = try container.decode(String.self, forKey: .clinicalNotes)
        vitalsHistory = try container.decode([PatientVitalsSnapshot].self, forKey: .vitalsHistory)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(timeSinceOnsetHours, forKey: .timeSinceOnsetHours)
        try container.encode(systolicBP, forKey: .systolicBP)
        try container.encode(diastolicBP, forKey: .diastolicBP)
        try container.encode(glucose, forKey: .glucose)
        try container.encode(platelets, forKey: .platelets)
        try container.encode(nihssScore, forKey: .nihssScore)
        try container.encode(age, forKey: .age)
        try container.encode(rankinPrevia, forKey: .rankinPrevia)

        try container.encode(bpControlled, forKey: .bpControlled)
        try container.encode(onHBP, forKey: .onHBP)
        try container.encode(onHeparin, forKey: .onHeparin)
        try container.encode(ttpProlonged, forKey: .ttpProlonged)
        try container.encode(onACO, forKey: .onACO)
        try container.encode(acoType, forKey: .acoType)
        try container.encode(hoursSinceLastDose, forKey: .hoursSinceLastDose)
        try container.encode(inr, forKey: .inr)

        try container.encode(heartRate, forKey: .heartRate)
        try container.encode(temperature, forKey: .temperature)

        try container.encode(clinicalNotes, forKey: .clinicalNotes)
        try container.encode(vitalsHistory, forKey: .vitalsHistory)
    }
    func captureSnapshot() {
        let snapshot = PatientVitalsSnapshot(
            timestamp: Date(),
            systolicBP: systolicBP,
            diastolicBP: diastolicBP,
            glucose: glucose,
            platelets: platelets,
            heartRate: heartRate,
            temperature: temperature,
            nihssScore: nihssScore,
            notes: clinicalNotes
        )
        vitalsHistory.append(snapshot)
    }
    
    func exportCSV() -> String {
        let header = "Timestamp,SystolicBP,DiastolicBP,Glucose,Platelets,HeartRate,Temperature,NIHSS,Notes"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let rows = vitalsHistory.map { snapshot in
            snapshot.toCSVRow(dateFormatter: formatter)
        }
        
        return ([header] + rows).joined(separator: "\n")
    }
}

// MARK: - ACOType Enum
enum ACOType: String, Codable {
    case NACO
    case AVK
}

// MARK: - PatientVitalsSnapshot
struct PatientVitalsSnapshot: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let systolicBP: Double
    let diastolicBP: Double
    let glucose: Double
    let platelets: Int
    let heartRate: Double
    let temperature: Double
    let nihssScore: Int
    let notes: String
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        systolicBP: Double,
        diastolicBP: Double,
        glucose: Double,
        platelets: Int,
        heartRate: Double,
        temperature: Double,
        nihssScore: Int,
        notes: String
    ) {
        self.id = id
        self.timestamp = timestamp
        self.systolicBP = systolicBP
        self.diastolicBP = diastolicBP
        self.glucose = glucose
        self.platelets = platelets
        self.heartRate = heartRate
        self.temperature = temperature
        self.nihssScore = nihssScore
        self.notes = notes
    }
    
    func toCSVRow(dateFormatter: DateFormatter) -> String {
        let dateString = dateFormatter.string(from: timestamp)
        return [
            dateString,
            "\(systolicBP)",
            "\(diastolicBP)",
            "\(glucose)",
            "\(platelets)",
            "\(heartRate)",
            "\(temperature)",
            "\(nihssScore)",
            "\"\(notes)\""
        ].joined(separator: ",")
    }
}
