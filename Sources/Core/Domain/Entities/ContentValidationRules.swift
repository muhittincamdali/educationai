import Foundation

public struct ContentValidationRules: Codable {
    public let qualityThreshold: Double
    public let requiredFields: [String]
    public let prohibitedContent: [String]
    public let ageAppropriateness: ClosedRange<Int>
    
    public init(
        qualityThreshold: Double = 0.8,
        requiredFields: [String] = [],
        prohibitedContent: [String] = [],
        ageAppropriateness: ClosedRange<Int> = 5...18
    ) {
        self.qualityThreshold = qualityThreshold
        self.requiredFields = requiredFields
        self.prohibitedContent = prohibitedContent
        self.ageAppropriateness = ageAppropriateness
    }
}
