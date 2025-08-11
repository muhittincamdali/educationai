import Foundation

/// Represents a user in the EducationAI system
public struct User: Codable, Identifiable, Equatable {
    
    // MARK: - Core Properties
    public let id: UUID
    public let email: String
    public let username: String
    public let firstName: String
    public let lastName: String
    public let profileImageURL: URL?
    public let dateOfBirth: Date?
    public let createdAt: Date
    public let lastActiveAt: Date
    
    // MARK: - Learning Profile
    public let learningStyle: LearningStyle
    public let preferredSubjects: [Subject]
    public let skillLevel: SkillLevel
    public let timeZone: TimeZone
    
    // MARK: - Progress & Analytics
    public let totalStudyTime: TimeInterval
    public let completedCourses: Int
    public let currentStreak: Int
    public let longestStreak: Int
    public let averageScore: Double
    
    // MARK: - Preferences
    public let notificationPreferences: NotificationPreferences
    public let accessibilitySettings: AccessibilitySettings
    public let languagePreference: Language
    
    // MARK: - Initialization
    public init(
        id: UUID = UUID(),
        email: String,
        username: String,
        firstName: String,
        lastName: String,
        profileImageURL: URL? = nil,
        dateOfBirth: Date? = nil,
        learningStyle: LearningStyle = .visual,
        preferredSubjects: [Subject] = [],
        skillLevel: SkillLevel = .beginner,
        timeZone: TimeZone = .current,
        notificationPreferences: NotificationPreferences = .default,
        accessibilitySettings: AccessibilitySettings = .default,
        languagePreference: Language = .english
    ) {
        self.id = id
        self.email = email
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageURL = profileImageURL
        self.dateOfBirth = dateOfBirth
        self.createdAt = Date()
        self.lastActiveAt = Date()
        self.learningStyle = learningStyle
        self.preferredSubjects = preferredSubjects
        self.skillLevel = skillLevel
        self.timeZone = timeZone
        self.totalStudyTime = 0
        self.completedCourses = 0
        self.currentStreak = 0
        self.longestStreak = 0
        self.averageScore = 0.0
        self.notificationPreferences = notificationPreferences
        self.accessibilitySettings = accessibilitySettings
        self.languagePreference = languagePreference
    }
    
    // MARK: - Computed Properties
    public var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    public var displayName: String {
        username.isEmpty ? fullName : username
    }
    
    public var age: Int? {
        guard let dateOfBirth = dateOfBirth else { return nil }
        return Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year
    }
    
    public var isActive: Bool {
        let inactiveThreshold: TimeInterval = 7 * 24 * 60 * 60 // 7 days
        return Date().timeIntervalSince(lastActiveAt) < inactiveThreshold
    }
    
    public var progressPercentage: Double {
        guard completedCourses > 0 else { return 0.0 }
        return min(Double(completedCourses) / 100.0, 1.0) // Assuming 100 courses is 100%
    }
}

// MARK: - Supporting Types
public enum LearningStyle: String, CaseIterable, Codable {
    case visual = "visual"
    case auditory = "auditory"
    case kinesthetic = "kinesthetic"
    case reading = "reading"
    case mixed = "mixed"
    
    public var description: String {
        switch self {
        case .visual: return "Visual Learner"
        case .auditory: return "Auditory Learner"
        case .kinesthetic: return "Hands-on Learner"
        case .reading: return "Reading/Writing Learner"
        case .mixed: return "Mixed Learning Style"
        }
    }
}

public enum SkillLevel: String, CaseIterable, Codable, Comparable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
    case expert = "expert"
    
    public var description: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        case .expert: return "Expert"
        }
    }
    
    public static func < (lhs: SkillLevel, rhs: SkillLevel) -> Bool {
        let order: [SkillLevel] = [.beginner, .intermediate, .advanced, .expert]
        guard let lhsIndex = order.firstIndex(of: lhs),
              let rhsIndex = order.firstIndex(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
}

public enum Subject: String, CaseIterable, Codable {
    case mathematics = "mathematics"
    case science = "science"
    case language = "language"
    case history = "history"
    case geography = "geography"
    case literature = "literature"
    case art = "art"
    case music = "music"
    case computerScience = "computer_science"
    case business = "business"
    case psychology = "psychology"
    case philosophy = "philosophy"
    
    public var displayName: String {
        switch self {
        case .mathematics: return "Mathematics"
        case .science: return "Science"
        case .language: return "Language"
        case .history: return "History"
        case .geography: return "Geography"
        case .literature: return "Literature"
        case .art: return "Art"
        case .music: return "Music"
        case .computerScience: return "Computer Science"
        case .business: return "Business"
        case .psychology: return "Psychology"
        case .philosophy: return "Philosophy"
        }
    }
}

public enum Language: String, CaseIterable, Codable {
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case german = "de"
    case italian = "it"
    case portuguese = "pt"
    case russian = "ru"
    case chinese = "zh"
    case japanese = "ja"
    case korean = "ko"
    
    public var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Español"
        case .french: return "Français"
        case .german: return "Deutsch"
        case .italian: return "Italiano"
        case .portuguese: return "Português"
        case .russian: return "Русский"
        case .chinese: return "中文"
        case .japanese: return "日本語"
        case .korean: return "한국어"
        }
    }
}

public struct NotificationPreferences: Codable, Equatable {
    public let pushEnabled: Bool
    public let emailEnabled: Bool
    public let studyReminders: Bool
    public let achievementNotifications: Bool
    public let socialNotifications: Bool
    public let quietHours: ClosedRange<Int>?
    
    public static let `default` = NotificationPreferences(
        pushEnabled: true,
        emailEnabled: true,
        studyReminders: true,
        achievementNotifications: true,
        socialNotifications: true,
        quietHours: 22...8
    )
}

public struct AccessibilitySettings: Codable, Equatable {
    public let voiceOverEnabled: Bool
    public let dynamicTypeEnabled: Bool
    public let highContrastEnabled: Bool
    public let reduceMotionEnabled: Bool
    public let audioDescriptionsEnabled: Bool
    
    public static let `default` = AccessibilitySettings(
        voiceOverEnabled: false,
        dynamicTypeEnabled: false,
        highContrastEnabled: false,
        reduceMotionEnabled: false,
        audioDescriptionsEnabled: false
    )
}

// MARK: - Extensions
extension User {
    public func updateLastActive() -> User {
        var updatedUser = self
        updatedUser.lastActiveAt = Date()
        return updatedUser
    }
    
    public func updateStudyTime(_ additionalTime: TimeInterval) -> User {
        var updatedUser = self
        updatedUser.totalStudyTime += additionalTime
        return updatedUser
    }
    
    public func completeCourse() -> User {
        var updatedUser = self
        updatedUser.completedCourses += 1
        return updatedUser
    }
    
    public func updateStreak(_ newStreak: Int) -> User {
        var updatedUser = self
        updatedUser.currentStreak = newStreak
        updatedUser.longestStreak = max(updatedUser.longestStreak, newStreak)
        return updatedUser
    }
    
    public func updateAverageScore(_ newScore: Double) -> User {
        var updatedUser = self
        let totalScore = updatedUser.averageScore * Double(updatedUser.completedCourses) + newScore
        updatedUser.averageScore = totalScore / Double(updatedUser.completedCourses + 1)
        return updatedUser
    }
}
