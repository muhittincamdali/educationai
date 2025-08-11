import Foundation

public struct EngagementMetrics: Codable {
    public let viewCount: Int
    public let completionRate: Double
    public let averageTimeSpent: TimeInterval
    public let returnRate: Double
    
    public init(
        viewCount: Int = 0,
        completionRate: Double = 0.0,
        averageTimeSpent: TimeInterval = 0.0,
        returnRate: Double = 0.0
    ) {
        self.viewCount = viewCount
        self.completionRate = completionRate
        self.averageTimeSpent = averageTimeSpent
        self.returnRate = returnRate
    }
}
