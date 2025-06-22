//
//  ClinicalSummaryView.swift
//  IntuitCodex
//
//  Created by user on 14/6/25.
//

import SwiftUI
import UniformTypeIdentifiers
import PDFKit

struct ClinicalSummaryView: View {
    @State private var showExporter = false
    @State private var exportURL: URL?
    @State private var exportType: ExportType?

    @ObservedObject var patient: PatientDataModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📝 Resumen Clínico")
                .font(.largeTitle.bold())
                .padding(.bottom)

            Group {
                Text("👤 Nombre: \(patient.name)")
                Text("🎂 Edad: \(patient.age)")
                Text("🧬 Sexo: \(patient.gender)")
                Text("❤️ FC: \(patient.heartRate) bpm")
                Text("💉 TA: \(patient.bloodPressure)")
                Text("🧪 Glucemia: \(patient.glucose) mg/dL")
                Text("🌡️ Temperatura: \(patient.temperature) °C")
                Text("🫁 Sat. O2: \(patient.oxygenSaturation) %")
                Text("🧠 NIHSS: \(patient.nihssScore)")
                Text("📌 Recomendación: \(patient.recommendation)")
            }
            .font(.body)

            Spacer()

            HStack(spacing: 16) {
                Button("Exportar CSV") {
                    exportType = .csv
                    exportURL = ExportManager.shared.exportCSV(for: patient)
                    showExporter = true
                }

                Button("Exportar PDF") {
                    exportType = .pdf
                    exportURL = ExportManager.shared.exportPDF(for: patient)
                    showExporter = true
                }

                Button("Exportar Word") {
                    exportType = .docx
                    exportURL = ExportManager.shared.exportDOCX(for: patient)
                    showExporter = true
                }
            }
            .buttonStyle(.borderedProminent)
            .fileExporter(isPresented: $showExporter, document: exportURL.map { ExportDocument(fileURL: $0) }, contentType: exportType?.utType ?? .plainText, defaultFilename: "Resumen_ICTUS") { _ in }
        }
        .padding()
        .navigationTitle("Resumen Clínico")
    }
}

// MARK: - Modelos y utilidades

enum ExportType {
    case csv, pdf, docx

    var utType: UTType {
        switch self {
        case .csv: return .commaSeparatedText
        case .pdf: return .pdf
        case .docx: return UTType(filenameExtension: "docx") ?? .plainText
        }
    }
}

class ExportManager {
    static let shared = ExportManager()

    func exportCSV(for patient: PatientDataModel) -> URL {
        let csv = """
        Campo,Valor
        Nombre,\(patient.name)
        Edad,\(patient.age)
        Sexo,\(patient.gender)
        FC,\(patient.heartRate)
        TA,\(patient.bloodPressure)
        Glucemia,\(patient.glucose)
        Temperatura,\(patient.temperature)
        Saturación,\(patient.oxygenSaturation)
        NIHSS,\(patient.nihssScore)
        Recomendación,\(patient.recommendation)
        """
        return saveToTempFile(text: csv, extension: "csv")
    }

    func exportPDF(for patient: PatientDataModel) -> URL {
        let pdfMeta = """
        Resumen Clínico - Ictus Codex

        Nombre: \(patient.name)
        Edad: \(patient.age)
        Sexo: \(patient.gender)
        FC: \(patient.heartRate) bpm
        TA: \(patient.bloodPressure)
        Glucemia: \(patient.glucose) mg/dL
        Temperatura: \(patient.temperature) °C
        Sat. O2: \(patient.oxygenSaturation) %
        NIHSS: \(patient.nihssScore)
        Recomendación: \(patient.recommendation)
        """
        return saveToTempFile(text: pdfMeta, extension: "pdf")
    }

    func exportDOCX(for patient: PatientDataModel) -> URL {
        let docx = """
        Resumen Clínico - Ictus Codex

        Nombre: \(patient.name)
        Edad: \(patient.age)
        Sexo: \(patient.gender)
        FC: \(patient.heartRate) bpm
        TA: \(patient.bloodPressure)
        Glucemia: \(patient.glucose) mg/dL
        Temperatura: \(patient.temperature) °C
        Sat. O2: \(patient.oxygenSaturation) %
        NIHSS: \(patient.nihssScore)
        Recomendación: \(patient.recommendation)
        """
        return saveToTempFile(text: docx, extension: "docx")
    }

    private func saveToTempFile(text: String, extension ext: String) -> URL {
        let filename = "Resumen_ICTUS.\(ext)"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        try? text.write(to: url, atomically: true, encoding: .utf8)
        return url
    }
}

struct ExportDocument: FileDocument {
    static var readableContentTypes: [UTType] = [.plainText]
    var fileURL: URL

    init(fileURL: URL) {
        self.fileURL = fileURL
    }

    init(configuration: ReadConfiguration) throws {
        self.fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("temp.txt")
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return try FileWrapper(url: fileURL, options: .immediate)
    }
}

#Preview {
    ClinicalSummaryView(patient: PatientDataModel())
}
