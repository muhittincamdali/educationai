import Foundation

public enum TimeRange: String, Codable, CaseIterable {
    case today = "today"
    case yesterday = "yesterday"
    case lastWeek = "lastWeek"
    case lastMonth = "lastMonth"
    case lastQuarter = "lastQuarter"
    case lastYear = "lastYear"
    case custom = "custom"
}
