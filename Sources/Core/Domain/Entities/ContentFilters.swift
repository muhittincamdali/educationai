import Foundation

public struct ContentFilters: Codable {
    public let subjects: [Subject]
    public let difficultyLevels: [DifficultyLevel]
    public let formats: [ContentFormat]
    public let ageRange: ClosedRange<Int>
    public let tags: [String]
    
    public init(
        subjects: [Subject] = [],
        difficultyLevels: [DifficultyLevel] = [],
        formats: [ContentFormat] = [],
        ageRange: ClosedRange<Int> = 5...18,
        tags: [String] = []
    ) {
        self.subjects = subjects
        self.difficultyLevels = difficultyLevels
        self.formats = formats
        self.ageRange = ageRange
        self.tags = tags
    }
}
