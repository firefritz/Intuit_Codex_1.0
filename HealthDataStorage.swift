//
//  HealthDataStorage.swift
//  IntuitCodex
//
//  Created by user on 14/6/25.
//


import Foundation

class HealthDataStorage {
    static let shared = HealthDataStorage()

    private let filename = "health_data.json"

    private var fileURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(filename)
    }

    func save(_ data: HealthData) {
        guard let url = fileURL else { return }
        do {
            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: url)
        } catch {
            print("❌ Error al guardar datos clínicos: \(error)")
        }
    }

    func load() throws -> HealthData? {
        guard let url = fileURL else { return nil }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(HealthData.self, from: data)
    }
}
