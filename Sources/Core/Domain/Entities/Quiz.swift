import Foundation

// MARK: - Quiz Entity
public struct Quiz: Codable, Identifiable, Equatable {
    public let id: UUID
    public var title: String
    public var description: String
    public var questions: [Question]
    public var timeLimit: TimeInterval?
    public var passingScore: Double
    public var maxAttempts: Int
    public var isRandomized: Bool
    public var isShuffled: Bool
    public var difficulty: QuizDifficulty
    public var category: QuizCategory
    public var tags: [String]
    public var isActive: Bool
    public var createdAt: Date
    public var updatedAt: Date
    public var publishedAt: Date?
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        questions: [Question] = [],
        timeLimit: TimeInterval? = nil,
        passingScore: Double = 70.0,
        maxAttempts: Int = 3,
        isRandomized: Bool = false,
        isShuffled: Bool = true,
        difficulty: QuizDifficulty = .medium,
        category: QuizCategory = .general,
        tags: [String] = [],
        isActive: Bool = true,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        publishedAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.questions = questions
        self.timeLimit = timeLimit
        self.passingScore = passingScore
        self.maxAttempts = maxAttempts
        self.isRandomized = isRandomized
        self.isShuffled = isShuffled
        self.difficulty = difficulty
        self.category = category
        self.tags = tags
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.publishedAt = publishedAt
    }
}

// MARK: - Question
public struct Question: Codable, Identifiable, Equatable {
    public let id: UUID
    public var text: String
    public var type: QuestionType
    public var options: [QuestionOption]
    public var correctAnswers: [String]
    public var explanation: String?
    public var points: Int
    public var difficulty: QuestionDifficulty
    public var category: String?
    public var tags: [String]
    public var isActive: Bool
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        text: String,
        type: QuestionType,
        options: [QuestionOption] = [],
        correctAnswers: [String] = [],
        explanation: String? = nil,
        points: Int = 1,
        difficulty: QuestionDifficulty = .medium,
        category: String? = nil,
        tags: [String] = [],
        isActive: Bool = true,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.text = text
        self.type = type
        self.options = options
        self.correctAnswers = correctAnswers
        self.explanation = explanation
        self.points = points
        self.difficulty = difficulty
        self.category = category
        self.tags = tags
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Question Type
public enum QuestionType: String, CaseIterable, Codable {
    case multipleChoice = "multipleChoice"
    case singleChoice = "singleChoice"
    case trueFalse = "trueFalse"
    case fillInTheBlank = "fillInTheBlank"
    case matching = "matching"
    case ordering = "ordering"
    case dragAndDrop = "dragAndDrop"
    case essay = "essay"
    case fileUpload = "fileUpload"
    
    public var displayName: String {
        switch self {
        case .multipleChoice: return "Çoktan Seçmeli"
        case .singleChoice: return "Tek Seçimli"
        case .trueFalse: return "Doğru/Yanlış"
        case .fillInTheBlank: return "Boşluk Doldurma"
        case .matching: return "Eşleştirme"
        case .ordering: return "Sıralama"
        case .dragAndDrop: return "Sürükle & Bırak"
        case .essay: return "Kompozisyon"
        case .fileUpload: return "Dosya Yükleme"
        }
    }
}

// MARK: - Question Option
public struct QuestionOption: Codable, Identifiable, Equatable {
    public let id: UUID
    public var text: String
    public var value: String
    public var isCorrect: Bool
    public var explanation: String?
    public var order: Int
    
    public init(
        id: UUID = UUID(),
        text: String,
        value: String,
        isCorrect: Bool = false,
        explanation: String? = nil,
        order: Int = 0
    ) {
        self.id = id
        self.text = text
        self.value = value
        self.isCorrect = isCorrect
        self.explanation = explanation
        self.order = order
    }
}

// MARK: - Question Difficulty
public enum QuestionDifficulty: String, CaseIterable, Codable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    case expert = "expert"
    
    public var displayName: String {
        switch self {
        case .easy: return "Kolay"
        case .medium: return "Orta"
        case .hard: return "Zor"
        case .expert: return "Uzman"
        }
    }
}

// MARK: - Quiz Difficulty
public enum QuizDifficulty: String, CaseIterable, Codable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    case expert = "expert"
    
    public var displayName: String {
        switch self {
        case .easy: return "Kolay"
        case .medium: return "Orta"
        case .hard: return "Zor"
        case .expert: return "Uzman"
        }
    }
}

// MARK: - Quiz Category
public enum QuizCategory: String, CaseIterable, Codable {
    case general = "general"
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
        case .general: return "Genel"
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
} 