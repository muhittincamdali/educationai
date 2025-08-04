import Foundation

// MARK: - User Entity
public struct User: Codable, Identifiable, Equatable {
    public let id: UUID
    public var email: String
    public var username: String
    public var firstName: String
    public var lastName: String
    public var profileImageURL: String?
    public var dateOfBirth: Date?
    public var learningLevel: LearningLevel
    public var preferredSubjects: [Subject]
    public var learningGoals: [LearningGoal]
    public var achievements: [Achievement]
    public var progress: UserProgress
    public var settings: UserSettings
    public var subscription: Subscription?
    public var createdAt: Date
    public var updatedAt: Date
    public var lastActiveAt: Date?
    public var isActive: Bool
    
    public init(
        id: UUID = UUID(),
        email: String,
        username: String,
        firstName: String,
        lastName: String,
        profileImageURL: String? = nil,
        dateOfBirth: Date? = nil,
        learningLevel: LearningLevel = .beginner,
        preferredSubjects: [Subject] = [],
        learningGoals: [LearningGoal] = [],
        achievements: [Achievement] = [],
        progress: UserProgress = UserProgress(),
        settings: UserSettings = UserSettings(),
        subscription: Subscription? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        lastActiveAt: Date? = nil,
        isActive: Bool = true
    ) {
        self.id = id
        self.email = email
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageURL = profileImageURL
        self.dateOfBirth = dateOfBirth
        self.learningLevel = learningLevel
        self.preferredSubjects = preferredSubjects
        self.learningGoals = learningGoals
        self.achievements = achievements
        self.progress = progress
        self.settings = settings
        self.subscription = subscription
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastActiveAt = lastActiveAt
        self.isActive = isActive
    }
}

// MARK: - Learning Level
public enum LearningLevel: String, CaseIterable, Codable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
    case expert = "expert"
    
    public var displayName: String {
        switch self {
        case .beginner: return "Başlangıç"
        case .intermediate: return "Orta Seviye"
        case .advanced: return "İleri Seviye"
        case .expert: return "Uzman"
        }
    }
    
    public var description: String {
        switch self {
        case .beginner: return "Yeni başlayanlar için temel kavramlar"
        case .intermediate: return "Temel bilgileri pekiştirme"
        case .advanced: return "Derinlemesine öğrenme"
        case .expert: return "Uzman seviye bilgi ve beceriler"
        }
    }
}

// MARK: - Subject
public enum Subject: String, CaseIterable, Codable {
    case mathematics = "mathematics"
    case science = "science"
    case language = "language"
    case history = "history"
    case geography = "geography"
    case literature = "literature"
    case art = "art"
    case music = "music"
    case technology = "technology"
    case business = "business"
    case health = "health"
    case philosophy = "philosophy"
    
    public var displayName: String {
        switch self {
        case .mathematics: return "Matematik"
        case .science: return "Bilim"
        case .language: return "Dil"
        case .history: return "Tarih"
        case .geography: return "Coğrafya"
        case .literature: return "Edebiyat"
        case .art: return "Sanat"
        case .music: return "Müzik"
        case .technology: return "Teknoloji"
        case .business: return "İş Dünyası"
        case .health: return "Sağlık"
        case .philosophy: return "Felsefe"
        }
    }
    
    public var icon: String {
        switch self {
        case .mathematics: return "function"
        case .science: return "atom"
        case .language: return "textformat"
        case .history: return "clock"
        case .geography: return "globe"
        case .literature: return "book"
        case .art: return "paintbrush"
        case .music: return "music.note"
        case .technology: return "laptopcomputer"
        case .business: return "briefcase"
        case .health: return "heart"
        case .philosophy: return "brain"
        }
    }
}

// MARK: - Learning Goal
public struct LearningGoal: Codable, Identifiable, Equatable {
    public let id: UUID
    public var title: String
    public var description: String
    public var targetDate: Date?
    public var isCompleted: Bool
    public var progress: Double
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        targetDate: Date? = nil,
        isCompleted: Bool = false,
        progress: Double = 0.0,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.targetDate = targetDate
        self.isCompleted = isCompleted
        self.progress = progress
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Achievement
public struct Achievement: Codable, Identifiable, Equatable {
    public let id: UUID
    public var title: String
    public var description: String
    public var icon: String
    public var points: Int
    public var isUnlocked: Bool
    public var unlockedAt: Date?
    public var createdAt: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        icon: String,
        points: Int,
        isUnlocked: Bool = false,
        unlockedAt: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.points = points
        self.isUnlocked = isUnlocked
        self.unlockedAt = unlockedAt
        self.createdAt = createdAt
    }
}

// MARK: - User Progress
public struct UserProgress: Codable, Equatable {
    public var totalPoints: Int
    public var totalLessonsCompleted: Int
    public var totalQuizzesPassed: Int
    public var currentStreak: Int
    public var longestStreak: Int
    public var averageScore: Double
    public var timeSpentLearning: TimeInterval
    public var subjectsProgress: [Subject: SubjectProgress]
    public var lastActivityDate: Date?
    
    public init(
        totalPoints: Int = 0,
        totalLessonsCompleted: Int = 0,
        totalQuizzesPassed: Int = 0,
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        averageScore: Double = 0.0,
        timeSpentLearning: TimeInterval = 0,
        subjectsProgress: [Subject: SubjectProgress] = [:],
        lastActivityDate: Date? = nil
    ) {
        self.totalPoints = totalPoints
        self.totalLessonsCompleted = totalLessonsCompleted
        self.totalQuizzesPassed = totalQuizzesPassed
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.averageScore = averageScore
        self.timeSpentLearning = timeSpentLearning
        self.subjectsProgress = subjectsProgress
        self.lastActivityDate = lastActivityDate
    }
}

// MARK: - Subject Progress
public struct SubjectProgress: Codable, Equatable {
    public var lessonsCompleted: Int
    public var quizzesPassed: Int
    public var averageScore: Double
    public var timeSpent: TimeInterval
    public var currentLevel: LearningLevel
    public var lastActivityDate: Date?
    
    public init(
        lessonsCompleted: Int = 0,
        quizzesPassed: Int = 0,
        averageScore: Double = 0.0,
        timeSpent: TimeInterval = 0,
        currentLevel: LearningLevel = .beginner,
        lastActivityDate: Date? = nil
    ) {
        self.lessonsCompleted = lessonsCompleted
        self.quizzesPassed = quizzesPassed
        self.averageScore = averageScore
        self.timeSpent = timeSpent
        self.currentLevel = currentLevel
        self.lastActivityDate = lastActivityDate
    }
}

// MARK: - User Settings
public struct UserSettings: Codable, Equatable {
    public var notificationsEnabled: Bool
    public var dailyReminderEnabled: Bool
    public var dailyReminderTime: Date
    public var soundEnabled: Bool
    public var hapticFeedbackEnabled: Bool
    public var autoPlayEnabled: Bool
    public var offlineModeEnabled: Bool
    public var dataUsageLimit: DataUsageLimit
    public var language: Language
    public var theme: AppTheme
    
    public init(
        notificationsEnabled: Bool = true,
        dailyReminderEnabled: Bool = true,
        dailyReminderTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date(),
        soundEnabled: Bool = true,
        hapticFeedbackEnabled: Bool = true,
        autoPlayEnabled: Bool = false,
        offlineModeEnabled: Bool = true,
        dataUsageLimit: DataUsageLimit = .unlimited,
        language: Language = .turkish,
        theme: AppTheme = .system
    ) {
        self.notificationsEnabled = notificationsEnabled
        self.dailyReminderEnabled = dailyReminderEnabled
        self.dailyReminderTime = dailyReminderTime
        self.soundEnabled = soundEnabled
        self.hapticFeedbackEnabled = hapticFeedbackEnabled
        self.autoPlayEnabled = autoPlayEnabled
        self.offlineModeEnabled = offlineModeEnabled
        self.dataUsageLimit = dataUsageLimit
        self.language = language
        self.theme = theme
    }
}

// MARK: - Data Usage Limit
public enum DataUsageLimit: String, CaseIterable, Codable {
    case unlimited = "unlimited"
    case low = "low"
    case medium = "medium"
    case high = "high"
    
    public var displayName: String {
        switch self {
        case .unlimited: return "Sınırsız"
        case .low: return "Düşük"
        case .medium: return "Orta"
        case .high: return "Yüksek"
        }
    }
}

// MARK: - Language
public enum Language: String, CaseIterable, Codable {
    case turkish = "tr"
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
    case arabic = "ar"
    
    public var displayName: String {
        switch self {
        case .turkish: return "Türkçe"
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
        case .arabic: return "العربية"
        }
    }
}

// MARK: - App Theme
public enum AppTheme: String, CaseIterable, Codable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    public var displayName: String {
        switch self {
        case .system: return "Sistem"
        case .light: return "Açık"
        case .dark: return "Koyu"
        }
    }
}

// MARK: - Subscription
public struct Subscription: Codable, Equatable {
    public var type: SubscriptionType
    public var startDate: Date
    public var endDate: Date?
    public var isActive: Bool
    public var autoRenew: Bool
    public var price: Decimal
    public var currency: String
    
    public init(
        type: SubscriptionType,
        startDate: Date,
        endDate: Date? = nil,
        isActive: Bool = true,
        autoRenew: Bool = true,
        price: Decimal,
        currency: String = "USD"
    ) {
        self.type = type
        self.startDate = startDate
        self.endDate = endDate
        self.isActive = isActive
        self.autoRenew = autoRenew
        self.price = price
        self.currency = currency
    }
}

// MARK: - Subscription Type
public enum SubscriptionType: String, CaseIterable, Codable {
    case basic = "basic"
    case pro = "pro"
    case elite = "elite"
    
    public var displayName: String {
        switch self {
        case .basic: return "Temel"
        case .pro: return "Pro"
        case .elite: return "Elite"
        }
    }
    
    public var features: [String] {
        switch self {
        case .basic:
            return [
                "Temel AI özellikleri",
                "Sınırlı içerik",
                "Reklamsız deneyim"
            ]
        case .pro:
            return [
                "Gelişmiş AI özellikleri",
                "Sınırsız içerik",
                "Detaylı analitik",
                "Sertifikalar",
                "Öncelikli destek"
            ]
        case .elite:
            return [
                "Kişisel AI öğretmen",
                "Özel içerik",
                "Üniversite kredisi",
                "1-on-1 dersler",
                "VIP destek",
                "Özel etkinlikler"
            ]
        }
    }
} 