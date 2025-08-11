import Foundation

public struct LearningPrediction: Codable, Identifiable {
    public let id: UUID
    public let userId: UUID
    public let subjectId: UUID
    public let predictedOutcome: String
    public let confidence: Double
    public let timeframe: TimeInterval
    public let factors: [String]
    public let recommendations: [String]
    public let createdAt: Date
    
    public init(
        id: UUID = UUID(),
        userId: UUID,
        subjectId: UUID,
        predictedOutcome: String,
        confidence: Double,
        timeframe: TimeInterval,
        factors: [String] = [],
        recommendations: [String] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.subjectId = subjectId
        self.predictedOutcome = predictedOutcome
        self.confidence = confidence
        self.timeframe = timeframe
        self.factors = factors
        self.recommendations = recommendations
        self.createdAt = createdAt
    }
}
