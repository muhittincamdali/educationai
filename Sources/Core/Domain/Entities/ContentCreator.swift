import Foundation

public struct ContentCreator: Codable, Identifiable {
    public let id: UUID
    public let name: String
    public let expertise: [String]
    public let credentials: [String]
    public let rating: Double
    
    public init(
        id: UUID = UUID(),
        name: String,
        expertise: [String] = [],
        credentials: [String] = [],
        rating: Double = 0.0
    ) {
        self.id = id
        self.name = name
        self.expertise = expertise
        self.credentials = credentials
        self.rating = rating
    }
}
