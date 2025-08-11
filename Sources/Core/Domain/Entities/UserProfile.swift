import Foundation

/// Represents a user's profile and learning preferences
public struct UserProfile: Codable, Identifiable {
    
    // MARK: - Properties
    public let id: UUID
    public var name: String
    public var email: String
    public var age: Int
    public var learningStyle: String // Using string instead of enum to avoid conflicts
    public var preferredSubjects: [Subject]
    public var skillLevel: SkillLevel
    public var learningGoals: [LearningGoal]
    public var timeAvailability: TimeAvailability
    public var preferences: UserPreferences
    public var createdAt: Date
    public var lastActiveAt: Date
    
    // MARK: - Initialization
    public init(
        id: UUID = UUID(),
        name: String,
        email: String,
        age: Int,
        learningStyle: String = "adaptive",
        preferredSubjects: [Subject] = [],
        skillLevel: SkillLevel = .beginner,
        learningGoals: [LearningGoal] = [],
        timeAvailability: TimeAvailability = .medium,
        preferences: UserPreferences = UserPreferences(),
        createdAt: Date = Date(),
        lastActiveAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.age = age
        self.learningStyle = learningStyle
        self.preferredSubjects = preferredSubjects
        self.skillLevel = skillLevel
        self.learningGoals = learningGoals
        self.timeAvailability = timeAvailability
        self.preferences = preferences
        self.createdAt = createdAt
        self.lastActiveAt = lastActiveAt
    }
    
    // MARK: - Public Methods
    /// Update user's learning preferences
    public mutating func updateLearningStyle(_ style: String) {
        self.learningStyle = style
        self.lastActiveAt = Date()
    }
    
    /// Add a new preferred subject
    public mutating func addPreferredSubject(_ subject: Subject) {
        if !preferredSubjects.contains(subject) {
            preferredSubjects.append(subject)
        }
    }
    
    /// Update skill level for a specific subject
    public mutating func updateSkillLevel(_ level: SkillLevel) {
        self.skillLevel = level
        self.lastActiveAt = Date()
    }
    
    /// Add a new learning goal
    public mutating func addLearningGoal(_ goal: LearningGoal) {
        if !learningGoals.contains(goal) {
            learningGoals.append(goal)
        }
    }
    
    /// Update time availability
    public mutating func updateTimeAvailability(_ availability: TimeAvailability) {
        self.timeAvailability = availability
        self.lastActiveAt = Date()
    }
}

// MARK: - Supporting Types
// SkillLevel enum is defined in Sources/Core/Domain/Entities/SkillLevel.swift

public enum TimeAvailability: String, Codable, CaseIterable {
    case low = "low"        // 0-30 minutes per day
    case medium = "medium"  // 30-60 minutes per day
    case high = "high"      // 60+ minutes per day
    
    public var displayName: String {
        switch self {
        case .low: return "Low (0-30 min/day)"
        case .medium: return "Medium (30-60 min/day)"
        case .high: return "High (60+ min/day)"
        }
    }
    
    public var minutesPerDay: Int {
        switch self {
        case .low: return 15
        case .medium: return 45
        case .high: return 90
        }
    }
}

public struct UserPreferences: Codable {
    public var notificationsEnabled: Bool
    public var darkModeEnabled: Bool
    public var autoPlayVideos: Bool
    public var soundEnabled: Bool
    public var accessibilityFeatures: [AccessibilityFeature]
    public var language: Language
    public var timezone: TimeZone
    
    public init(
        notificationsEnabled: Bool = true,
        darkModeEnabled: Bool = false,
        autoPlayVideos: Bool = true,
        soundEnabled: Bool = true,
        accessibilityFeatures: [AccessibilityFeature] = [],
        language: Language = .english,
        timezone: TimeZone = TimeZone.current
    ) {
        self.notificationsEnabled = notificationsEnabled
        self.darkModeEnabled = darkModeEnabled
        self.autoPlayVideos = autoPlayVideos
        self.soundEnabled = soundEnabled
        self.accessibilityFeatures = accessibilityFeatures
        self.language = language
        self.timezone = timezone
    }
}

// AccessibilityFeature enum is defined in Sources/Core/Domain/Entities/AccessibilityFeature.swift

public enum Language: String, Codable, CaseIterable {
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case german = "de"
    case chinese = "zh"
    case japanese = "ja"
    case korean = "ko"
    case arabic = "ar"
    case russian = "ru"
    case turkish = "tr"
    
    public var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Español"
        case .french: return "Français"
        case .german: return "Deutsch"
        case .chinese: return "中文"
        case .japanese: return "日本語"
        case .korean: return "한국어"
        case .arabic: return "العربية"
        case .russian: return "Русский"
        case .turkish: return "Türkçe"
        }
    }
}
