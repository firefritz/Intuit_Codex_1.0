import SwiftUI
import Foundation

@main
struct IntuitCodexApp: App {
    var body: some Scene {
        WindowGroup {
            ClinicalSummaryView() // or the appropriate view that uses IctusCodex model
        }
    }
}
