import Foundation

public struct ProcessedQuery: Codable {
    public let query: String
    public let intent: QueryIntent
    public let filters: ContentFilters
    
    public init(
        query: String,
        intent: QueryIntent,
        filters: ContentFilters
    ) {
        self.query = query
        self.intent = intent
        self.filters = filters
    }
}

public enum QueryIntent: String, Codable, CaseIterable {
    case search = "search"
    case recommendation = "recommendation"
    case learning = "learning"
    case review = "review"
    case practice = "practice"
}
