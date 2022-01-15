import Foundation

public struct DifficultyAdjustment: Codable {
    public let originalLevel: DifficultyLevel
    public let adjustedLevel: DifficultyLevel
    public let adjustmentReason: String
    public let confidence: Double
    
    public init(
        originalLevel: DifficultyLevel,
        adjustedLevel: DifficultyLevel,
        adjustmentReason: String,
        confidence: Double
    ) {
        self.originalLevel = originalLevel
        self.adjustedLevel = adjustedLevel
        self.adjustmentReason = adjustmentReason
        self.confidence = confidence
    }
}
