import Foundation

public enum PerformanceTrend: String, Codable, CaseIterable {
    case improving = "improving"
    case stable = "stable"
    case declining = "declining"
    case fluctuating = "fluctuating"
}
