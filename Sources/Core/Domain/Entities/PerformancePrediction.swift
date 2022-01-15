import Foundation

public struct PerformancePrediction: Codable, Identifiable {
    public let id: UUID
    public let userId: UUID
    public let metric: String
    public let predictedValue: Double
    public let confidence: Double
    public let timeRange: TimeRange
    public let factors: [String]
    public let recommendations: [String]
    public let createdAt: Date
    
    public init(
        id: UUID = UUID(),
        userId: UUID,
        metric: String,
        predictedValue: Double,
        confidence: Double,
        timeRange: TimeRange,
        factors: [String] = [],
        recommendations: [String] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.metric = metric
        self.predictedValue = predictedValue
        self.confidence = confidence
        self.timeRange = timeRange
        self.factors = factors
        self.recommendations = recommendations
        self.createdAt = createdAt
    }
}
