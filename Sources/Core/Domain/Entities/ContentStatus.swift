import Foundation

public enum ContentStatus: String, Codable, CaseIterable {
    case draft = "draft"
    case pending = "pending"
    case approved = "approved"
    case published = "published"
    case archived = "archived"
    case rejected = "rejected"
}
