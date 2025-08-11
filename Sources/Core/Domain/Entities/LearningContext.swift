import Foundation

public struct LearningContext: Codable {
    public let userId: UUID?
    public let subject: Subject?
    public let currentSession: LearningSession?
    public let userPreferences: UserContentPreferences?
    public let timestamp: Date
    
    public init(
        userId: UUID? = nil,
        subject: Subject? = nil,
        currentSession: LearningSession? = nil,
        userPreferences: UserContentPreferences? = nil,
        timestamp: Date = Date()
    ) {
        self.userId = userId
        self.subject = subject
        self.currentSession = currentSession
        self.userPreferences = userPreferences
        self.timestamp = timestamp
    }
}
