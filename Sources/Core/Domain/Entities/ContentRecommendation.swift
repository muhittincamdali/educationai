import Foundation

/// Represents a personalized content recommendation for a user
public struct ContentRecommendation: Codable, Identifiable, Hashable {
    
    // MARK: - Properties
    public let id: UUID
    public let title: String
    public let description: String
    public let type: ContentType
    public let subject: Subject
    public let difficultyLevel: String // Using string instead of enum to avoid conflicts
    public let estimatedDuration: TimeInterval
    public let confidence: Double // 0.0 to 1.0, AI confidence in recommendation
    public let reason: RecommendationReason
    public let tags: [String]
    public let metadata: ContentMetadata
    public var isConsumed: Bool
    public let createdAt: Date
    public let expiresAt: Date?
    
    // MARK: - Initialization
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        type: ContentType,
        subject: Subject,
        difficultyLevel: String,
        estimatedDuration: TimeInterval,
        confidence: Double,
        reason: RecommendationReason,
        tags: [String] = [],
        metadata: ContentMetadata = ContentMetadata(),
        isConsumed: Bool = false,
        createdAt: Date = Date(),
        expiresAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.subject = subject
        self.difficultyLevel = difficultyLevel
        self.estimatedDuration = estimatedDuration
        self.confidence = confidence
        self.reason = reason
        self.tags = tags
        self.metadata = metadata
        self.isConsumed = isConsumed
        self.createdAt = createdAt
        self.expiresAt = expiresAt
    }
    
    // MARK: - Public Methods
    /// Mark content as consumed
    public mutating func markAsConsumed() {
        isConsumed = true
    }
    
    /// Check if recommendation is expired
    public var isExpired: Bool {
        guard let expiresAt = expiresAt else { return false }
        return Date() > expiresAt
    }
    
    /// Check if recommendation is still valid
    public var isValid: Bool {
        return !isExpired && !isConsumed
    }
    
    /// Get confidence percentage
    public var confidencePercentage: Int {
        return Int(confidence * 100)
    }
    
    /// Get formatted duration
    public var formattedDuration: String {
        let hours = Int(estimatedDuration) / 3600
        let minutes = Int(estimatedDuration) % 3600 / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    /// Get days until expiration
    public var daysUntilExpiration: Int? {
        guard let expiresAt = expiresAt else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: expiresAt)
        return components.day
    }
    
    /// Get recommendation priority based on confidence and reason
    public var priority: RecommendationPriority {
        if confidence >= 0.9 {
            return .critical
        } else if confidence >= 0.7 {
            return .high
        } else if confidence >= 0.5 {
            return .medium
        } else {
            return .low
        }
    }
    
    // MARK: - Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: ContentRecommendation, rhs: ContentRecommendation) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Supporting Types
public enum ContentType: String, Codable, CaseIterable {
    case lesson = "lesson"
    case exercise = "exercise"
    case quiz = "quiz"
    case video = "video"
    case article = "article"
    case book = "book"
    case podcast = "podcast"
    case project = "project"
    case workshop = "workshop"
    case course = "course"
    case tutorial = "tutorial"
    case practice = "practice"
    
    public var displayName: String {
        switch self {
        case .lesson: return "Lesson"
        case .exercise: return "Exercise"
        case .quiz: return "Quiz"
        case .video: return "Video"
        case .article: return "Article"
        case .book: return "Book"
        case .podcast: return "Podcast"
        case .project: return "Project"
        case .workshop: return "Workshop"
        case .course: return "Course"
        case .tutorial: return "Tutorial"
        case .practice: return "Practice"
        }
    }
    
    public var icon: String {
        switch self {
        case .lesson: return "book"
        case .exercise: return "pencil"
        case .quiz: return "questionmark.circle"
        case .video: return "play.rectangle"
        case .article: return "doc.text"
        case .book: return "book.closed"
        case .podcast: return "mic"
        case .project: return "folder"
        case .workshop: return "hammer"
        case .course: return "graduationcap"
        case .tutorial: return "person.2"
        case .practice: return "repeat"
        }
    }
}

public enum RecommendationReason: String, Codable, CaseIterable {
    case userInterest = "userInterest"
    case skillGap = "skillGap"
    case learningPath = "learningPath"
    case trending = "trending"
    case peerRecommendation = "peerRecommendation"
    case aiAnalysis = "aiAnalysis"
    case completion = "completion"
    case review = "review"
    case challenge = "challenge"
    case exploration = "exploration"
    
    public var displayName: String {
        switch self {
        case .userInterest: return "Based on your interests"
        case .skillGap: return "Addresses skill gaps"
        case .learningPath: return "Part of your learning path"
        case .trending: return "Currently trending"
        case .peerRecommendation: return "Recommended by peers"
        case .aiAnalysis: return "AI-powered recommendation"
        case .completion: return "Completes previous content"
        case .review: return "Review and reinforcement"
        case .challenge: return "Challenge your skills"
        case .exploration: return "Explore new topics"
        }
    }
    
    public var description: String {
        switch self {
        case .userInterest: return "This content aligns with topics you've shown interest in"
        case .skillGap: return "This content helps fill gaps in your current skill set"
        case .learningPath: return "This content is part of your personalized learning journey"
        case .trending: return "This content is currently popular among learners"
        case .peerRecommendation: return "Other learners with similar profiles enjoyed this"
        case .aiAnalysis: return "Our AI analyzed your learning patterns and recommended this"
        case .completion: return "This content builds upon what you've already learned"
        case .review: return "This content helps reinforce your existing knowledge"
        case .challenge: return "This content will challenge and expand your skills"
        case .exploration: return "This content introduces you to new and exciting topics"
        }
    }
}

public enum RecommendationPriority: String, Codable, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case critical = "critical"
    
    public var displayName: String {
        switch self {
        case .low: return "Low Priority"
        case .medium: return "Medium Priority"
        case .high: return "High Priority"
        case .critical: return "Critical Priority"
        }
    }
    
    public var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "blue"
        case .high: return "orange"
        case .critical: return "red"
        }
    }
}

// ContentMetadata struct is defined in Sources/Core/Domain/Entities/ContentMetadata.swift

// ContentSize enum is defined in Sources/Core/Domain/Entities/ContentSize.swift
