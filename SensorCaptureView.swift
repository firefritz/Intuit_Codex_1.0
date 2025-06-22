import SwiftUI
import CoreMotion
import HealthKit

struct SensorCaptureView: View {
    @State private var heartRate: Double?
    @State private var stepCount: Int?
    @State private var oxygenSaturation: Double?
    @State private var motionManager = CMMotionManager()
    @State private var acceleration: CMAcceleration?
    private let healthStore = HKHealthStore()

    var body: some View {
        VStack {
            Text("📡 Captura de sensores")
                .font(.title)
                .padding()

            if let heartRate = heartRate {
                Text("❤️ Frecuencia cardíaca: \(String(format: "%.1f", heartRate)) bpm")
                    .padding()
            } else {
                Text("❤️ Frecuencia cardíaca: --")
                    .padding()
            }

            if let stepCount = stepCount {
                Text("👣 Pasos: \(stepCount)")
                    .padding()
            } else {
                Text("👣 Pasos: --")
                    .padding()
            }

            if let oxygen = oxygenSaturation {
                Text("🫁 Saturación de oxígeno: \(String(format: "%.1f", oxygen)) %")
                    .padding()
            } else {
                Text("🫁 Saturación de oxígeno: --")
                    .padding()
            }

            if let accel = acceleration {
                Text("📈 Aceleración - x: \(String(format: "%.2f", accel.x)), y: \(String(format: "%.2f", accel.y)), z: \(String(format: "%.2f", accel.z))")
                    .padding()
            } else {
                Text("📈 Aceleración: --")
                    .padding()
            }

            Spacer()
        }
        .onAppear {
            startMotionUpdates()
            requestHealthKitAccess()
        }
        .navigationTitle("SensorCaptureView")
    }

    func startMotionUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.2
            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                if let data = data {
                    acceleration = data.acceleration
                }
            }
        }
    }

    func requestHealthKitAccess() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let oxygenSaturationType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!

        let typesToRead: Set = [heartRateType, stepCountType, oxygenSaturationType]

        healthStore.requestAuthorization(toShare: [], read: typesToRead) { (success, error) in
            if success {
                fetchHeartRate()
                fetchStepCount()
                fetchOxygenSaturation()
            }
        }
    }

    func fetchHeartRate() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, results, _ in
            if let result = results?.first as? HKQuantitySample {
                let bpm = result.quantity.doubleValue(for: HKUnit(from: "count/min"))
                DispatchQueue.main.async {
                    heartRate = bpm
                }
            }
        }
        healthStore.execute(query)
    }

    func fetchStepCount() {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            if let quantity = result?.sumQuantity() {
                let steps = Int(quantity.doubleValue(for: HKUnit.count()))
                DispatchQueue.main.async {
                    stepCount = steps
                }
            }
        }
        healthStore.execute(query)
    }

    func fetchOxygenSaturation() {
        let oxygenSaturationType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: oxygenSaturationType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, results, _ in
            if let result = results?.first as? HKQuantitySample {
                let percent = result.quantity.doubleValue(for: HKUnit.percent()) * 100
                DispatchQueue.main.async {
                    self.oxygenSaturation = percent
                }
            }
        }
        self.healthStore.execute(query)
    }
}

#Preview {
    SensorCaptureView()
}