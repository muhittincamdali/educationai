import Foundation

public enum ContentSize: String, Codable, CaseIterable {
    case small = "small"      // < 15 minutes
    case medium = "medium"    // 15-60 minutes
    case large = "large"      // 1-4 hours
    case extensive = "extensive" // 4+ hours
    
    public var displayName: String {
        switch self {
        case .small: return "Small (< 15 min)"
        case .medium: return "Medium (15-60 min)"
        case .large: return "Large (1-4 hours)"
        case .extensive: return "Extensive (4+ hours)"
        }
    }
}
