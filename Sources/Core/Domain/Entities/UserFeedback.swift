import Foundation

public struct UserFeedback: Codable, Identifiable {
    public let id: UUID
    public let rating: Int
    public let comment: String?
    public let timestamp: Date
    public let userId: UUID
    
    public init(
        id: UUID = UUID(),
        rating: Int,
        comment: String? = nil,
        timestamp: Date = Date(),
        userId: UUID
    ) {
        self.id = id
        self.rating = rating
        self.comment = comment
        self.timestamp = timestamp
        self.userId = userId
    }
}
