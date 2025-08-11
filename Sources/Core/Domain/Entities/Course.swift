import Foundation

/// Represents an educational course in the EducationAI system
public struct Course: Codable, Identifiable, Equatable {
    
    // MARK: - Core Properties
    public let id: UUID
    public let title: String
    public let description: String
    public let shortDescription: String
    public let thumbnailURL: URL?
    public let bannerURL: URL?
    public let category: CourseCategory
    public let subject: Subject
    public let difficulty: SkillLevel
    public let estimatedDuration: TimeInterval
    public let language: Language
    
    // MARK: - Content Structure
    public let modules: [Module]
    public let prerequisites: [UUID] // Course IDs
    public let learningObjectives: [String]
    public let tags: [String]
    
    // MARK: - Metadata
    public let author: CourseAuthor
    public let createdAt: Date
    public let updatedAt: Date
    public let publishedAt: Date?
    public let version: String
    
    // MARK: - Statistics
    public let enrollmentCount: Int
    public let completionRate: Double
    public let averageRating: Double
    public let reviewCount: Int
    
    // MARK: - Pricing & Access
    public let isFree: Bool
    public let price: Decimal?
    public let currency: String?
    public let accessLevel: AccessLevel
    public let isPublished: Bool
    
    // MARK: - Initialization
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        shortDescription: String,
        thumbnailURL: URL? = nil,
        bannerURL: URL? = nil,
        category: CourseCategory,
        subject: Subject,
        difficulty: SkillLevel,
        estimatedDuration: TimeInterval,
        language: Language = .english,
        modules: [Module] = [],
        prerequisites: [UUID] = [],
        learningObjectives: [String] = [],
        tags: [String] = [],
        author: CourseAuthor,
        version: String = "1.0.0",
        isFree: Bool = true,
        price: Decimal? = nil,
        currency: String? = nil,
        accessLevel: AccessLevel = .public,
        isPublished: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.shortDescription = shortDescription
        self.thumbnailURL = thumbnailURL
        self.bannerURL = bannerURL
        self.category = category
        self.subject = subject
        self.difficulty = difficulty
        self.estimatedDuration = estimatedDuration
        self.language = language
        self.modules = modules
        self.prerequisites = prerequisites
        self.learningObjectives = learningObjectives
        self.tags = tags
        self.author = author
        self.createdAt = Date()
        self.updatedAt = Date()
        self.publishedAt = nil
        self.version = version
        self.enrollmentCount = 0
        self.completionRate = 0.0
        self.averageRating = 0.0
        self.reviewCount = 0
        self.isFree = isFree
        self.price = price
        self.currency = currency
        self.accessLevel = accessLevel
        self.isPublished = isPublished
    }
    
    // MARK: - Computed Properties
    public var totalLessons: Int {
        modules.reduce(0) { $0 + $1.lessons.count }
    }
    
    public var totalQuizzes: Int {
        modules.reduce(0) { $0 + $1.quizzes.count }
    }
    
    public var totalAssignments: Int {
        modules.reduce(0) { $0 + $1.assignments.count }
    }
    
    public var formattedDuration: String {
        let hours = Int(estimatedDuration) / 3600
        let minutes = Int(estimatedDuration) % 3600 / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    public var formattedPrice: String? {
        guard let price = price, let currency = currency else { return nil }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: price as NSDecimalNumber)
    }
    
    public var isPremium: Bool {
        !isFree
    }
    
    public var canEnroll: Bool {
        isPublished && (isFree || accessLevel != .restricted)
    }
    
    public var progressPercentage: Double {
        guard !modules.isEmpty else { return 0.0 }
        let completedModules = modules.filter { $0.isCompleted }.count
        return Double(completedModules) / Double(modules.count)
    }
}

// MARK: - Supporting Types
public enum CourseCategory: String, CaseIterable, Codable {
    case programming = "programming"
    case mathematics = "mathematics"
    case science = "science"
    case language = "language"
    case business = "business"
    case design = "design"
    case music = "music"
    case health = "health"
    case technology = "technology"
    case arts = "arts"
    case history = "history"
    case philosophy = "philosophy"
    case psychology = "psychology"
    case economics = "economics"
    case engineering = "engineering"
    
    public var displayName: String {
        switch self {
        case .programming: return "Programming"
        case .mathematics: return "Mathematics"
        case .science: return "Science"
        case .language: return "Language"
        case .business: return "Business"
        case .design: return "Design"
        case .music: return "Music"
        case .health: return "Health"
        case .technology: return "Technology"
        case .arts: return "Arts"
        case .history: return "History"
        case .philosophy: return "Philosophy"
        case .psychology: return "Psychology"
        case .economics: return "Economics"
        case .engineering: return "Engineering"
        }
    }
    
    public var icon: String {
        switch self {
        case .programming: return "💻"
        case .mathematics: return "🔢"
        case .science: return "🔬"
        case .language: return "🌍"
        case .business: return "💼"
        case .design: return "🎨"
        case .music: return "🎵"
        case .health: return "🏥"
        case .technology: return "⚡"
        case .arts: return "🎭"
        case .history: return "📚"
        case .philosophy: return "🤔"
        case .psychology: return "🧠"
        case .economics: return "📊"
        case .engineering: return "⚙️"
        }
    }
}

public enum AccessLevel: String, CaseIterable, Codable {
    case `public` = "public"
    case `private` = "private"
    case restricted = "restricted"
    case premium = "premium"
    
    public var displayName: String {
        switch self {
        case .public: return "Public"
        case .private: return "Private"
        case .restricted: return "Restricted"
        case .premium: return "Premium"
        }
    }
}

public struct CourseAuthor: Codable, Equatable {
    public let id: UUID
    public let name: String
    public let bio: String?
    public let avatarURL: URL?
    public let expertise: [String]
    public let verified: Bool
    public let totalCourses: Int
    public let averageRating: Double
    
    public init(
        id: UUID = UUID(),
        name: String,
        bio: String? = nil,
        avatarURL: URL? = nil,
        expertise: [String] = [],
        verified: Bool = false,
        totalCourses: Int = 0,
        averageRating: Double = 0.0
    ) {
        self.id = id
        self.name = name
        self.bio = bio
        self.avatarURL = avatarURL
        self.expertise = expertise
        self.verified = verified
        self.totalCourses = totalCourses
        self.averageRating = averageRating
    }
}

public struct Module: Codable, Identifiable, Equatable {
    public let id: UUID
    public let title: String
    public let description: String
    public let order: Int
    public let lessons: [Lesson]
    public let quizzes: [Quiz]
    public let assignments: [Assignment]
    public let estimatedDuration: TimeInterval
    public let isCompleted: Bool
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        order: Int,
        lessons: [Lesson] = [],
        quizzes: [Quiz] = [],
        assignments: [Assignment] = [],
        estimatedDuration: TimeInterval = 0,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.order = order
        self.lessons = lessons
        self.quizzes = quizzes
        self.assignments = assignments
        self.estimatedDuration = estimatedDuration
        self.isCompleted = isCompleted
    }
}

public struct Lesson: Codable, Identifiable, Equatable {
    public let id: UUID
    public let title: String
    public let content: String
    public let type: LessonType
    public let duration: TimeInterval
    public let order: Int
    public let isCompleted: Bool
    public let resources: [Resource]
    
    public init(
        id: UUID = UUID(),
        title: String,
        content: String,
        type: LessonType,
        duration: TimeInterval,
        order: Int,
        isCompleted: Bool = false,
        resources: [Resource] = []
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.type = type
        self.duration = duration
        self.order = order
        self.isCompleted = isCompleted
        self.resources = resources
    }
}

public enum LessonType: String, CaseIterable, Codable {
    case video = "video"
    case text = "text"
    case interactive = "interactive"
    case audio = "audio"
    case mixed = "mixed"
    
    public var displayName: String {
        switch self {
        case .video: return "Video Lesson"
        case .text: return "Text Lesson"
        case .interactive: return "Interactive Lesson"
        case .audio: return "Audio Lesson"
        case .mixed: return "Mixed Media"
        }
    }
}

public struct Quiz: Codable, Identifiable, Equatable {
    public let id: UUID
    public let title: String
    public let description: String
    public let questions: [Question]
    public let timeLimit: TimeInterval?
    public let passingScore: Double
    public let order: Int
    public let isCompleted: Bool
    public let score: Double?
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        questions: [Question] = [],
        timeLimit: TimeInterval? = nil,
        passingScore: Double = 70.0,
        order: Int,
        isCompleted: Bool = false,
        score: Double? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.questions = questions
        self.timeLimit = timeLimit
        self.passingScore = passingScore
        self.order = order
        self.isCompleted = isCompleted
        self.score = score
    }
}

public struct Question: Codable, Identifiable, Equatable {
    public let id: UUID
    public let text: String
    public let type: QuestionType
    public let options: [String]?
    public let correctAnswer: String
    public let explanation: String?
    public let points: Double
    
    public init(
        id: UUID = UUID(),
        text: String,
        type: QuestionType,
        options: [String]? = nil,
        correctAnswer: String,
        explanation: String? = nil,
        points: Double = 1.0
    ) {
        self.id = id
        self.text = text
        self.type = type
        self.options = options
        self.correctAnswer = correctAnswer
        self.explanation = explanation
        self.points = points
    }
}

public enum QuestionType: String, CaseIterable, Codable {
    case multipleChoice = "multiple_choice"
    case trueFalse = "true_false"
    case shortAnswer = "short_answer"
    case essay = "essay"
    case matching = "matching"
    
    public var displayName: String {
        switch self {
        case .multipleChoice: return "Multiple Choice"
        case .trueFalse: return "True/False"
        case .shortAnswer: return "Short Answer"
        case .essay: return "Essay"
        case .matching: return "Matching"
        }
    }
}

public struct Assignment: Codable, Identifiable, Equatable {
    public let id: UUID
    public let title: String
    public let description: String
    public let dueDate: Date?
    public let maxPoints: Double
    public let order: Int
    public let isCompleted: Bool
    public let score: Double?
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        dueDate: Date? = nil,
        maxPoints: Double = 100.0,
        order: Int,
        isCompleted: Bool = false,
        score: Double? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.maxPoints = maxPoints
        self.order = order
        self.isCompleted = isCompleted
        self.score = score
    }
}

public struct Resource: Codable, Identifiable, Equatable {
    public let id: UUID
    public let name: String
    public let type: ResourceType
    public let url: URL
    public let size: Int64?
    public let description: String?
    
    public init(
        id: UUID = UUID(),
        name: String,
        type: ResourceType,
        url: URL,
        size: Int64? = nil,
        description: String? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.url = url
        self.size = size
        self.description = description
    }
}

public enum ResourceType: String, CaseIterable, Codable {
    case pdf = "pdf"
    case video = "video"
    case audio = "audio"
    case image = "image"
    case document = "document"
    case spreadsheet = "spreadsheet"
    case presentation = "presentation"
    case archive = "archive"
    
    public var displayName: String {
        switch self {
        case .pdf: return "PDF Document"
        case .video: return "Video File"
        case .audio: return "Audio File"
        case .image: return "Image File"
        case .document: return "Document"
        case .spreadsheet: return "Spreadsheet"
        case .presentation: return "Presentation"
        case .archive: return "Archive"
        }
    }
    
    public var icon: String {
        switch self {
        case .pdf: return "📄"
        case .video: return "🎥"
        case .audio: return "🎵"
        case .image: return "🖼️"
        case .document: return "📝"
        case .spreadsheet: return "📊"
        case .presentation: return "📽️"
        case .archive: return "📦"
        }
    }
}

// MARK: - Extensions
extension Course {
    public func publish() -> Course {
        var updatedCourse = self
        updatedCourse.publishedAt = Date()
        updatedCourse.isPublished = true
        updatedCourse.updatedAt = Date()
        return updatedCourse
    }
    
    public func updateStatistics(
        enrollmentCount: Int? = nil,
        completionRate: Double? = nil,
        averageRating: Double? = nil,
        reviewCount: Int? = nil
    ) -> Course {
        var updatedCourse = self
        if let enrollmentCount = enrollmentCount {
            updatedCourse.enrollmentCount = enrollmentCount
        }
        if let completionRate = completionRate {
            updatedCourse.completionRate = completionRate
        }
        if let averageRating = averageRating {
            updatedCourse.averageRating = averageRating
        }
        if let reviewCount = reviewCount {
            updatedCourse.reviewCount = reviewCount
        }
        updatedCourse.updatedAt = Date()
        return updatedCourse
    }
    
    public func addModule(_ module: Module) -> Course {
        var updatedCourse = self
        updatedCourse.modules.append(module)
        updatedCourse.updatedAt = Date()
        return updatedCourse
    }
    
    public func updateModule(_ module: Module) -> Course {
        var updatedCourse = self
        if let index = updatedCourse.modules.firstIndex(where: { $0.id == module.id }) {
            updatedCourse.modules[index] = module
            updatedCourse.updatedAt = Date()
        }
        return updatedCourse
    }
}
