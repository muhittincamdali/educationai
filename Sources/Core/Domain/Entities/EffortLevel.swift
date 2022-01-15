import Foundation

public enum EffortLevel: String, Codable, CaseIterable {
    case minimal = "minimal"
    case low = "low"
    case medium = "medium"
    case high = "high"
    case intensive = "intensive"
}
