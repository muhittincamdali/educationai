import Foundation

public enum QuizPerformance: String, Codable, CaseIterable {
    case excellent = "excellent"
    case good = "good"
    case average = "average"
    case poor = "poor"
    case needsImprovement = "needsImprovement"
}
