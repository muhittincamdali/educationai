import Foundation

/// Represents an educational subject or topic
public struct Subject: Codable, Identifiable, Hashable {
    
    // MARK: - Properties
    public let id: UUID
    public let name: String
    public let description: String
    public let category: SubjectCategory
    public let difficultyLevel: String // Using string instead of enum to avoid conflicts
    public let estimatedDuration: TimeInterval
    public let prerequisites: [Subject]
    public let learningObjectives: [LearningObjective]
    public let tags: [String]
    public let isActive: Bool
    public let createdAt: Date
    public let updatedAt: Date
    
    // MARK: - Initialization
    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        category: SubjectCategory,
        difficultyLevel: String = "beginner",
        estimatedDuration: TimeInterval = 3600, // 1 hour default
        prerequisites: [Subject] = [],
        learningObjectives: [LearningObjective] = [],
        tags: [String] = [],
        isActive: Bool = true,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.difficultyLevel = difficultyLevel
        self.estimatedDuration = estimatedDuration
        self.prerequisites = prerequisites
        self.learningObjectives = learningObjectives
        self.tags = tags
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // MARK: - Public Methods
    /// Check if user meets prerequisites for this subject
    public func canUserAccess(userProfile: UserProfile) -> Bool {
        let userSubjects = userProfile.preferredSubjects
        return prerequisites.allSatisfy { prerequisite in
            userSubjects.contains(prerequisite)
        }
    }
    
    /// Get formatted duration string
    public var formattedDuration: String {
        let hours = Int(estimatedDuration) / 3600
        let minutes = Int(estimatedDuration) % 3600 / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    /// Get difficulty level display name
    public var difficultyDisplayName: String {
        switch difficultyLevel {
        case "beginner": return "Beginner"
        case "intermediate": return "Intermediate"
        case "advanced": return "Advanced"
        case "expert": return "Expert"
        default: return "Unknown"
        }
    }
    
    // MARK: - Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Subject, rhs: Subject) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Subject Categories
public enum SubjectCategory: String, Codable, CaseIterable {
    case mathematics = "mathematics"
    case science = "science"
    case language = "language"
    case history = "history"
    case geography = "geography"
    case arts = "arts"
    case music = "music"
    case technology = "technology"
    case business = "business"
    case health = "health"
    case philosophy = "philosophy"
    case psychology = "psychology"
    case economics = "economics"
    case literature = "literature"
    case computerScience = "computerScience"
    case engineering = "engineering"
    case medicine = "medicine"
    case law = "law"
    case education = "education"
    case sports = "sports"
    
    public var displayName: String {
        switch self {
        case .mathematics: return "Mathematics"
        case .science: return "Science"
        case .language: return "Language"
        case .history: return "History"
        case .geography: return "Geography"
        case .arts: return "Arts"
        case .music: return "Music"
        case .technology: return "Technology"
        case .business: return "Business"
        case .health: return "Health"
        case .philosophy: return "Philosophy"
        case .psychology: return "Psychology"
        case .economics: return "Economics"
        case .literature: return "Literature"
        case .computerScience: return "Computer Science"
        case .engineering: return "Engineering"
        case .medicine: return "Medicine"
        case .law: return "Law"
        case .education: return "Education"
        case .sports: return "Sports"
        }
    }
    
    public var icon: String {
        switch self {
        case .mathematics: return "function"
        case .science: return "atom"
        case .language: return "textformat"
        case .history: return "book"
        case .geography: return "globe"
        case .arts: return "paintbrush"
        case .music: return "music.note"
        case .technology: return "laptopcomputer"
        case .business: return "briefcase"
        case .health: return "heart"
        case .philosophy: return "brain"
        case .psychology: return "person.2"
        case .economics: return "chart.line.uptrend.xyaxis"
        case .literature: return "text.book.closed"
        case .computerScience: return "cpu"
        case .engineering: return "wrench.and.screwdriver"
        case .medicine: return "cross"
        case .law: return "building.columns"
        case .education: return "graduationcap"
        case .sports: return "sportscourt"
        }
    }
}

// MARK: - Learning Objective
public struct LearningObjective: Codable, Identifiable {
    public let id: UUID
    public let title: String
    public let description: String
    public var isCompleted: Bool
    public let order: Int
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        isCompleted: Bool = false,
        order: Int
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.order = order
    }
}
