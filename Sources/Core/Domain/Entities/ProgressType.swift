import Foundation

public enum ProgressType: String, Codable, CaseIterable {
    case sessionStarted = "sessionStarted"
    case sessionPaused = "sessionPaused"
    case sessionResumed = "sessionResumed"
    case sessionCompleted = "sessionCompleted"
    case lessonCompleted = "lessonCompleted"
    case quizCompleted = "quizCompleted"
    case pathAdapted = "pathAdapted"
    case milestoneReached = "milestoneReached"
    case skillImproved = "skillImproved"
    case contentConsumed = "contentConsumed"
}
