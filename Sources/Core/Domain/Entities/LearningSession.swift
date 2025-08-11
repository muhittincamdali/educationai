import Foundation

/// Represents a learning session for a specific subject
public struct LearningSession: Codable, Identifiable {
    
    // MARK: - Properties
    public let id: UUID
    public let userId: UUID
    public let subjectId: UUID
    public var startTime: Date
    public var endTime: Date?
    public var duration: TimeInterval
    public var progress: Double // 0.0 to 1.0
    public var currentLesson: Lesson?
    public var completedLessons: [Lesson]
    public var quizResults: [QuizResult]
    public var notes: [SessionNote]
    public var status: SessionStatus
    public var learningPath: LearningPath
    public var adaptiveRecommendations: [AdaptiveRecommendation]
    public var metadata: SessionMetadata
    
    // MARK: - Initialization
    public init(
        id: UUID = UUID(),
        userId: UUID,
        subjectId: UUID,
        startTime: Date = Date(),
        endTime: Date? = nil,
        duration: TimeInterval = 0,
        progress: Double = 0.0,
        currentLesson: Lesson? = nil,
        completedLessons: [Lesson] = [],
        quizResults: [QuizResult] = [],
        notes: [SessionNote] = [],
        status: SessionStatus = .active,
        learningPath: LearningPath,
        adaptiveRecommendations: [AdaptiveRecommendation] = [],
        metadata: SessionMetadata = SessionMetadata()
    ) {
        self.id = id
        self.userId = userId
        self.subjectId = subjectId
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.progress = progress
        self.currentLesson = currentLesson
        self.completedLessons = completedLessons
        self.quizResults = quizResults
        self.notes = notes
        self.status = status
        self.learningPath = learningPath
        self.adaptiveRecommendations = adaptiveRecommendations
        self.metadata = metadata
    }
    
    // MARK: - Public Methods
    /// Start the session
    public mutating func start() {
        status = .active
        startTime = Date()
    }
    
    /// Pause the session
    public mutating func pause() {
        status = .paused
        updateDuration()
    }
    
    /// Resume the session
    public mutating func resume() {
        status = .active
        startTime = Date()
    }
    
    /// Complete the session
    public mutating func complete() {
        status = .completed
        endTime = Date()
        updateDuration()
        progress = 1.0
    }
    
    /// Add a completed lesson
    public mutating func completeLesson(_ lesson: Lesson) {
        if !completedLessons.contains(lesson) {
            completedLessons.append(lesson)
            updateProgress()
        }
    }
    
    /// Add quiz result
    public mutating func addQuizResult(_ result: QuizResult) {
        quizResults.append(result)
        updateProgress()
    }
    
    /// Add session note
    public mutating func addNote(_ note: SessionNote) {
        notes.append(note)
    }
    
    /// Add lesson completion
    public mutating func addLessonCompletion(_ lesson: Lesson) {
        completeLesson(lesson)
    }
    
    /// Update learning path
    public mutating func updateLearningPath(with recommendations: [AdaptiveRecommendation]) {
        adaptiveRecommendations = recommendations
    }
    
    /// Get subject ID
    public var subject: UUID {
        return subjectId
    }
    
    /// Get user profile ID
    public var userProfile: UUID {
        return userId
    }
    
    /// Add a note to the session
    public mutating func addNote(_ note: String) {
        notes.append(SessionNote(content: note, timestamp: Date()))
    }
    
    /// Update progress based on completed content
    private mutating func updateProgress() {
        let totalLessons = learningPath.lessons.count
        let completedCount = completedLessons.count
        
        if totalLessons > 0 {
            progress = Double(completedCount) / Double(totalLessons)
        }
    }
    
    /// Update session duration
    private mutating func updateDuration() {
        if let endTime = endTime {
            duration = endTime.timeIntervalSince(startTime)
        } else {
            duration = Date().timeIntervalSince(startTime)
        }
    }
    
    /// Get formatted duration string
    public var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) % 3600 / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    /// Get progress percentage
    public var progressPercentage: Int {
        return Int(progress * 100)
    }
    
    /// Check if session is active
    public var isActive: Bool {
        return status == .active
    }
    
    /// Check if session is completed
    public var isCompleted: Bool {
        return status == .completed
    }
}

// MARK: - Supporting Types
public enum SessionStatus: String, Codable, CaseIterable {
    case active = "active"
    case paused = "paused"
    case completed = "completed"
    case abandoned = "abandoned"
    
    public var displayName: String {
        switch self {
        case .active: return "Active"
        case .paused: return "Paused"
        case .completed: return "Completed"
        case .abandoned: return "Abandoned"
        }
    }
}

public struct LessonPerformance: Codable {
    public let averageScore: Double
    public let completionRate: Double
    public let timeSpent: TimeInterval
    public let attempts: Int
    
    public init(
        averageScore: Double = 0.0,
        completionRate: Double = 0.0,
        timeSpent: TimeInterval = 0.0,
        attempts: Int = 0
    ) {
        self.averageScore = averageScore
        self.completionRate = completionRate
        self.timeSpent = timeSpent
        self.attempts = attempts
    }
}

public struct Lesson: Codable, Identifiable, Hashable {
    public let id: UUID
    public let title: String
    public let description: String
    public let type: LessonType
    public let difficultyLevel: String
    public let duration: TimeInterval
    public let content: LessonContent
    public let order: Int
    public var isCompleted: Bool
    public let performance: LessonPerformance
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        type: LessonType,
        difficultyLevel: String = "beginner",
        duration: TimeInterval,
        content: LessonContent,
        order: Int,
        isCompleted: Bool = false,
        performance: LessonPerformance = LessonPerformance()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.difficultyLevel = difficultyLevel
        self.duration = duration
        self.content = content
        self.order = order
        self.isCompleted = isCompleted
        self.performance = LessonPerformance()
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Lesson, rhs: Lesson) -> Bool {
        return lhs.id == rhs.id
    }
}

public enum LessonType: String, Codable, CaseIterable {
    case video = "video"
    case text = "text"
    case interactive = "interactive"
    case quiz = "quiz"
    case exercise = "exercise"
    case project = "project"
    
    public var displayName: String {
        switch self {
        case .video: return "Video"
        case .text: return "Text"
        case .interactive: return "Interactive"
        case .quiz: return "Quiz"
        case .exercise: return "Exercise"
        case .project: return "Project"
        }
    }
}

public struct LessonContent: Codable {
    public let mediaURL: URL?
    public let text: String?
    public let interactiveElements: [InteractiveElement]
    public let attachments: [Attachment]
    
    public init(
        mediaURL: URL? = nil,
        text: String? = nil,
        interactiveElements: [InteractiveElement] = [],
        attachments: [Attachment] = []
    ) {
        self.mediaURL = mediaURL
        self.text = text
        self.interactiveElements = interactiveElements
        self.attachments = attachments
    }
}

public struct InteractiveElement: Codable, Identifiable {
    public let id: UUID
    public let type: InteractiveElementType
    public let data: [String: String]
    
    public init(
        id: UUID = UUID(),
        type: InteractiveElementType,
        data: [String: String] = [:]
    ) {
        self.id = id
        self.type = type
        self.data = data
    }
}

public enum InteractiveElementType: String, Codable {
    case button, slider, input, dragDrop, hotspot
}

public struct Attachment: Codable, Identifiable {
    public let id: UUID
    public let name: String
    public let url: URL
    public let type: AttachmentType
    public let size: Int64
    
    public init(
        id: UUID = UUID(),
        name: String,
        url: URL,
        type: AttachmentType,
        size: Int64
    ) {
        self.id = id
        self.name = name
        self.url = url
        self.type = type
        self.size = size
    }
}

public enum AttachmentType: String, Codable {
    case pdf, image, video, audio, document, spreadsheet
}

// QuizPerformance enum is defined in Sources/Core/Domain/Entities/QuizPerformance.swift

public struct QuizResult: Codable, Identifiable {
    public let id: UUID
    public let quizId: UUID
    public let score: Double
    public let totalQuestions: Int
    public let correctAnswers: Int
    public let timeSpent: TimeInterval
    public let completedAt: Date
    
    public init(
        id: UUID = UUID(),
        quizId: UUID,
        score: Double,
        totalQuestions: Int,
        correctAnswers: Int,
        timeSpent: TimeInterval,
        completedAt: Date = Date()
    ) {
        self.id = id
        self.quizId = quizId
        self.score = score
        self.totalQuestions = totalQuestions
        self.correctAnswers = correctAnswers
        self.timeSpent = timeSpent
        self.completedAt = completedAt
    }
}

public struct SessionNote: Codable, Identifiable {
    public let id: UUID
    public let content: String
    public let timestamp: Date
    public let lessonId: UUID?
    
    public init(
        id: UUID = UUID(),
        content: String,
        timestamp: Date = Date(),
        lessonId: UUID? = nil
    ) {
        self.id = id
        self.content = content
        self.timestamp = timestamp
        self.lessonId = lessonId
    }
}

public struct LearningPath: Codable {
    public let lessons: [Lesson]
    public let estimatedDuration: TimeInterval
    public let difficulty: String // Using string instead of enum to avoid conflicts
    
    public init(
        lessons: [Lesson],
        estimatedDuration: TimeInterval,
        difficulty: String
    ) {
        self.lessons = lessons
        self.estimatedDuration = estimatedDuration
        self.difficulty = difficulty
    }
    
    public var difficultyLevel: String {
        return difficulty
    }
}

public struct AdaptiveRecommendation: Codable, Identifiable {
    public let id: UUID
    public let type: RecommendationType
    public let content: String
    public let priority: Priority
    public let isApplied: Bool
    
    public init(
        id: UUID = UUID(),
        type: RecommendationType,
        content: String,
        priority: Priority = .medium,
        isApplied: Bool = false
    ) {
        self.id = id
        self.type = type
        self.content = content
        self.priority = priority
        self.isApplied = isApplied
    }
}

// RecommendationType and Priority enums are defined in their respective entity files

public struct SessionMetadata: Codable {
    public let deviceInfo: String
    public let appVersion: String
    public let platform: String
    public let networkType: String
    public let customData: [String: String]
    
    public init(
        deviceInfo: String = "",
        appVersion: String = "",
        platform: String = "",
        networkType: String = "",
        customData: [String: String] = [:]
    ) {
        self.deviceInfo = deviceInfo
        self.appVersion = appVersion
        self.platform = platform
        self.networkType = networkType
        self.customData = customData
    }
}
