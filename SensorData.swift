import Foundation
import CoreMotion

struct SensorData: Identifiable, Codable {
    let id: UUID
    var timestamp: Date

    // Aceleración total
    var accelerationX: Double
    var accelerationY: Double
    var accelerationZ: Double

    // Aceleración sin gravedad
    var userAccelerationX: Double
    var userAccelerationY: Double
    var userAccelerationZ: Double

    // Gravedad
    var gravityX: Double
    var gravityY: Double
    var gravityZ: Double

    // Velocidades angulares
    var rotationRateX: Double
    var rotationRateY: Double
    var rotationRateZ: Double

    // Actitud espacial
    var attitudeRoll: Double
    var attitudePitch: Double
    var attitudeYaw: Double

    // Campo magnético (si se usa magnetómetro)
    var magneticFieldX: Double
    var magneticFieldY: Double
    var magneticFieldZ: Double
}
