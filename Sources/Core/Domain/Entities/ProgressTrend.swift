import Foundation

public enum ProgressTrend: String, Codable, CaseIterable {
    case improving = "improving"
    case stable = "stable"
    case accelerating = "accelerating"
    case steady = "steady"
    case slowing = "slowing"
    case plateauing = "plateauing"
    case regressing = "regressing"
}
