import Foundation

public enum InteractiveElementPreference: String, Codable, CaseIterable {
    case minimal = "minimal"
    case moderate = "moderate"
    case high = "high"
    case adaptive = "adaptive"
}
