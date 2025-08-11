import Foundation

public struct SessionMetrics: Codable {
    public let duration: TimeInterval
    public let lessonsCompleted: Int
    public let quizzesTaken: Int
    public let averageScore: Double
    public let engagementScore: Double
    public let difficultyLevel: DifficultyLevel
    
    public init(
        duration: TimeInterval = 0.0,
        lessonsCompleted: Int = 0,
        quizzesTaken: Int = 0,
        averageScore: Double = 0.0,
        engagementScore: Double = 0.0,
        difficultyLevel: DifficultyLevel = .beginner
    ) {
        self.duration = duration
        self.lessonsCompleted = lessonsCompleted
        self.quizzesTaken = quizzesTaken
        self.averageScore = averageScore
        self.engagementScore = engagementScore
        self.difficultyLevel = difficultyLevel
    }
}
