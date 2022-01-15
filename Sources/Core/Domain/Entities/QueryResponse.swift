import Foundation

public struct QueryResponse: Codable {
    public let query: String
    public let response: String
    public let confidence: Double
    public let suggestions: [String]
    
    public init(
        query: String,
        response: String,
        confidence: Double,
        suggestions: [String] = []
    ) {
        self.query = query
        self.response = response
        self.confidence = confidence
        self.suggestions = suggestions
    }
}
