//
//  MotionService.swift
//  IntuitCodex
//
//  Created by user on 14/6/25.
//

import Foundation
import CoreMotion

class MotionService: ObservableObject {
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()

    @Published var latestSensorData: SensorData?

    init() {
        startUpdates()
    }

    func startUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion not available.")
            return
        }

        motionManager.deviceMotionUpdateInterval = 0.05

        motionManager.startDeviceMotionUpdates(to: queue) { [weak self] data, error in
            guard let data = data else { return }

            let timestamp = Date()
            let newSensorData = SensorData(
                id: UUID(),
                timestamp: timestamp,
                accelerationX: data.userAcceleration.x + data.gravity.x,
                accelerationY: data.userAcceleration.y + data.gravity.y,
                accelerationZ: data.userAcceleration.z + data.gravity.z,
                userAccelerationX: data.userAcceleration.x,
                userAccelerationY: data.userAcceleration.y,
                userAccelerationZ: data.userAcceleration.z,
                gravityX: data.gravity.x,
                gravityY: data.gravity.y,
                gravityZ: data.gravity.z,
                rotationRateX: data.rotationRate.x,
                rotationRateY: data.rotationRate.y,
                rotationRateZ: data.rotationRate.z,
                attitudeRoll: data.attitude.roll,
                attitudePitch: data.attitude.pitch,
                attitudeYaw: data.attitude.yaw,
                magneticFieldX: 0.0,  // Requiere startMagnetometerUpdates para valores reales
                magneticFieldY: 0.0,
                magneticFieldZ: 0.0
            )

            DispatchQueue.main.async {
                self?.latestSensorData = newSensorData
            }
        }
    }

    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}
