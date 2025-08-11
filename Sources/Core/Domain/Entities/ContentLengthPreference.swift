import Foundation

public enum ContentLengthPreference: String, Codable, CaseIterable {
    case short = "short"
    case medium = "medium"
    case long = "long"
    case flexible = "flexible"
}
