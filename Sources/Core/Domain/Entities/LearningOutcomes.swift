import Foundation

public struct LearningOutcomes: Codable {
    public let knowledgeGain: Double
    public let skillImprovement: Double
    public let retentionRate: Double
    public let applicationSuccess: Double
    
    public init(
        knowledgeGain: Double = 0.0,
        skillImprovement: Double = 0.0,
        retentionRate: Double = 0.0,
        applicationSuccess: Double = 0.0
    ) {
        self.knowledgeGain = knowledgeGain
        self.skillImprovement = skillImprovement
        self.retentionRate = retentionRate
        self.applicationSuccess = applicationSuccess
    }
}
