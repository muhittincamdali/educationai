import Foundation

public struct ContentComplexity: Codable {
    public let readabilityScore: Double
    public let vocabularyLevel: VocabularyLevel
    public let conceptDensity: Double
    public let cognitiveLoad: Double
    
    public init(
        readabilityScore: Double = 0.0,
        vocabularyLevel: VocabularyLevel = .basic,
        conceptDensity: Double = 0.0,
        cognitiveLoad: Double = 0.0
    ) {
        self.readabilityScore = readabilityScore
        self.vocabularyLevel = vocabularyLevel
        self.conceptDensity = conceptDensity
        self.cognitiveLoad = cognitiveLoad
    }
}
