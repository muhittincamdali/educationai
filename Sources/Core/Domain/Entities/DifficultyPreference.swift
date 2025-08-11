import Foundation

public enum DifficultyPreference: String, Codable, CaseIterable {
    case easier = "easier"
    case current = "current"
    case challenging = "challenging"
    case adaptive = "adaptive"
}
