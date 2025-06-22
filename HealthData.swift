import Foundation

struct HealthData: Identifiable, Codable {
    let id: UUID
    var timestamp: Date

    // Datos vitales
    var heartRate: Double?               // Latidos por minuto (bpm)
    var oxygenSaturation: Double?        // SpO2 (%)
    var systolicPressure: Double?        // Presión sistólica (mmHg)
    var diastolicPressure: Double?       // Presión diastólica (mmHg)
    var bodyTemperature: Double?         // Temperatura corporal (°C)
    var respiratoryRate: Double?         // Respiraciones por minuto
}
