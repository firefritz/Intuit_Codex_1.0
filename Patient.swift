import Foundation
import CoreLocation

// Enumeración para el sexo del paciente
enum Gender: String, Codable {
    case masculino
    case femenino
    case otro
}

// Estructura auxiliar para codificar/decodificar coordenadas GPS
struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double

    init(_ coordinate: CLLocationCoordinate2D) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }

    var clLocationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// Modelo principal de paciente
struct Patient: Identifiable, Codable {
    let id: UUID
    var nombre: String
    var edad: Int
    var sexo: Gender
    var embarazo: Bool?
    var peso: Double?
    var nhc: String?
    var fechaInclusion: Date
    var horaComienzo: Date?
    var horaLlegada: Date?
    var horaAtencion: Date?
    var localizacion: Coordinate?  // Ahora codificable
}
