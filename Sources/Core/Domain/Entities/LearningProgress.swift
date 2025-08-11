import Foundation

/// Represents the learning progress of a user
public struct LearningProgress: Codable, Identifiable {
    
    // MARK: - Properties
    public let id: UUID
    public let userId: UUID
    public let subjectId: UUID
    public let sessionId: UUID?
    public let lessonId: UUID?
    public let type: ProgressType
    public let value: Double // 0.0 to 1.0 or custom scale
    public let maxValue: Double
    public let unit: ProgressUnit
    public let description: String
    public let timestamp: Date
    public let metadata: ProgressMetadata
    
    // MARK: - Initialization
    public init(
        id: UUID = UUID(),
        userId: UUID,
        subjectId: UUID,
        sessionId: UUID? = nil,
        lessonId: UUID? = nil,
        type: ProgressType,
        value: Double,
        maxValue: Double = 1.0,
        unit: ProgressUnit = .percentage,
        description: String,
        timestamp: Date = Date(),
        metadata: ProgressMetadata = ProgressMetadata()
    ) {
        self.id = id
        self.userId = userId
        self.subjectId = subjectId
        self.sessionId = sessionId
        self.lessonId = lessonId
        self.type = type
        self.value = value
        self.maxValue = maxValue
        self.unit = unit
        self.description = description
        self.timestamp = timestamp
        self.metadata = metadata
    }
    
    // MARK: - Public Methods
    /// Get progress percentage (0.0 to 1.0)
    public var progressPercentage: Double {
        if maxValue == 0 { return 0.0 }
        return value / maxValue
    }
    
    /// Get progress percentage as integer
    public var progressPercentageInt: Int {
        return Int(progressPercentage * 100)
    }
    
    /// Get formatted progress value
    public var formattedValue: String {
        switch unit {
        case .percentage:
            return "\(progressPercentageInt)%"
        case .score:
            return "\(Int(value))/\(Int(maxValue))"
        case .time:
            return formatTime(value)
        case .count:
            return "\(Int(value))"
        case .custom:
            return "\(value)"
        }
    }
    
    /// Check if progress is complete
    public var isComplete: Bool {
        return progressPercentage >= 1.0
    }
    
    /// Check if progress is significant (more than 10% improvement)
    public var isSignificant: Bool {
        return progressPercentage >= 0.1
    }
    
    /// Get progress status
    public var status: ProgressStatus {
        if isComplete {
            return .completed
        } else if progressPercentage >= 0.8 {
            return .nearCompletion
        } else if progressPercentage >= 0.5 {
            return .inProgress
        } else if progressPercentage >= 0.2 {
            return .started
        } else {
            return .notStarted
        }
    }
    
    /// Get progress trend (if available in metadata)
    public var trend: ProgressTrend? {
        return metadata.trend
    }
    
    /// Get skill analytics for this progress
    public var skillAnalytics: SkillAnalytics? {
        // This would be populated by the analytics engine
        return nil
    }
    
    // MARK: - Private Methods
    private func formatTime(_ seconds: Double) -> String {
        let hours = Int(seconds) / 3600
        let minutes = Int(seconds) % 3600 / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

// ProgressType enum is defined in Sources/Core/Domain/Entities/ProgressType.swift

public enum ProgressUnit: String, Codable, CaseIterable {
    case percentage = "percentage"
    case score = "score"
    case time = "time"
    case count = "count"
    case custom = "custom"
    
    public var displayName: String {
        switch self {
        case .percentage: return "Percentage"
        case .score: return "Score"
        case .time: return "Time"
        case .count: return "Count"
        case .custom: return "Custom"
        }
    }
    
    public var symbol: String {
        switch self {
        case .percentage: return "%"
        case .score: return "pts"
        case .time: return "min"
        case .count: return "#"
        case .custom: return ""
        }
    }
}

public enum ProgressStatus: String, Codable, CaseIterable {
    case notStarted = "notStarted"
    case started = "started"
    case inProgress = "inProgress"
    case nearCompletion = "nearCompletion"
    case completed = "completed"
    
    public var displayName: String {
        switch self {
        case .notStarted: return "Not Started"
        case .started: return "Started"
        case .inProgress: return "In Progress"
        case .nearCompletion: return "Near Completion"
        case .completed: return "Completed"
        }
    }
    
    public var color: String {
        switch self {
        case .notStarted: return "gray"
        case .started: return "blue"
        case .inProgress: return "orange"
        case .nearCompletion: return "yellow"
        case .completed: return "green"
        }
    }
    
    public var icon: String {
        switch self {
        case .notStarted: return "circle"
        case .started: return "circle.lefthalf.filled"
        case .inProgress: return "clock"
        case .nearCompletion: return "checkmark.circle"
        case .completed: return "checkmark.circle.fill"
        }
    }
}

// ProgressTrend enum is defined in Sources/Core/Domain/Entities/ProgressTrend.swift

public struct ProgressMetadata: Codable {
    public let context: String?
    public let difficulty: String? // Using string instead of enum to avoid conflicts
    public let effort: EffortLevel?
    public let mood: UserMood?
    public let environment: LearningEnvironment?
    public let trend: ProgressTrend?
    public let notes: String?
    public let customData: [String: String]
    
    public init(
        context: String? = nil,
        difficulty: String? = nil,
        effort: EffortLevel? = nil,
        mood: UserMood? = nil,
        environment: LearningEnvironment? = nil,
        trend: ProgressTrend? = nil,
        notes: String? = nil,
        customData: [String: String] = [:]
    ) {
        self.context = context
        self.difficulty = difficulty
        self.effort = effort
        self.mood = mood
        self.environment = environment
        self.trend = trend
        self.notes = notes
        self.customData = customData
    }
}

// EffortLevel enum is defined in Sources/Core/Domain/Entities/EffortLevel.swift

public enum UserMood: String, Codable, CaseIterable {
    case excited = "excited"
    case happy = "happy"
    case neutral = "neutral"
    case frustrated = "frustrated"
    case tired = "tired"
    case confused = "confused"
    case confident = "confident"
    case anxious = "anxious"
    
    public var displayName: String {
        switch self {
        case .excited: return "Excited"
        case .happy: return "Happy"
        case .neutral: return "Neutral"
        case .frustrated: return "Frustrated"
        case .tired: return "Tired"
        case .confused: return "Confused"
        case .confident: return "Confident"
        case .anxious: return "Anxious"
        }
    }
    
    public var emoji: String {
        switch self {
        case .excited: return "🤩"
        case .happy: return "😊"
        case .neutral: return "😐"
        case .frustrated: return "😤"
        case .tired: return "😴"
        case .confused: return "😕"
        case .confident: return "😎"
        case .anxious: return "😰"
        }
    }
}

public enum LearningEnvironment: String, Codable, CaseIterable {
    case home = "home"
    case office = "office"
    case library = "library"
    case classroom = "classroom"
    case outdoors = "outdoors"
    case commute = "commute"
    case coffeeShop = "coffeeShop"
    case gym = "gym"
    case other = "other"
    
    public var displayName: String {
        switch self {
        case .home: return "Home"
        case .office: return "Office"
        case .library: return "Library"
        case .classroom: return "Classroom"
        case .outdoors: return "Outdoors"
        case .commute: return "Commute"
        case .coffeeShop: return "Coffee Shop"
        case .gym: return "Gym"
        case .other: return "Other"
        }
    }
}
