import Foundation

/// A generated quiz consisting of multiple questions.
public struct Quiz: Identifiable, Codable, Sendable {

    /// Unique identifier.
    public let id: UUID

    /// Human-readable title.
    public var title: String

    /// The subject this quiz covers.
    public let subjectID: UUID

    /// Questions in presentation order.
    public var questions: [Question]

    /// Optional time limit in seconds.
    public var timeLimit: TimeInterval?

    /// Minimum score (0-1) required to pass.
    public var passingScore: Double

    /// Difficulty of the overall quiz.
    public var difficulty: DifficultyLevel

    /// When this quiz was generated.
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        title: String = "Quiz",
        subjectID: UUID,
        questions: [Question] = [],
        timeLimit: TimeInterval? = nil,
        passingScore: Double = 0.7,
        difficulty: DifficultyLevel = .medium,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.subjectID = subjectID
        self.questions = questions
        self.timeLimit = timeLimit
        self.passingScore = passingScore
        self.difficulty = difficulty
        self.createdAt = createdAt
    }

    /// Total points available across all questions.
    public var totalPoints: Double {
        questions.reduce(0) { $0 + $1.points }
    }

    /// Number of questions in the quiz.
    public var questionCount: Int { questions.count }
}

// MARK: - Question

/// A single quiz question with one or more valid answers.
public struct Question: Identifiable, Codable, Sendable, Hashable {

    /// Unique identifier.
    public let id: UUID

    /// The question text shown to the learner.
    public var text: String

    /// Type of question (multiple choice, true/false, etc.).
    public var type: QuestionType

    /// Answer options (for multiple choice / matching).
    public var options: [String]

    /// Index(es) of the correct option(s) — or the text answer for short-answer.
    public var correctAnswers: [String]

    /// Optional hint shown after first wrong attempt.
    public var hint: String?

    /// Explanation shown after answering.
    public var explanation: String?

    /// Points awarded for a correct answer.
    public var points: Double

    /// Difficulty of this individual question.
    public var difficulty: DifficultyLevel

    /// Source flashcard ID (if generated from a flashcard).
    public var sourceCardID: UUID?

    public init(
        id: UUID = UUID(),
        text: String,
        type: QuestionType = .multipleChoice,
        options: [String] = [],
        correctAnswers: [String],
        hint: String? = nil,
        explanation: String? = nil,
        points: Double = 1.0,
        difficulty: DifficultyLevel = .medium,
        sourceCardID: UUID? = nil
    ) {
        self.id = id
        self.text = text
        self.type = type
        self.options = options
        self.correctAnswers = correctAnswers
        self.hint = hint
        self.explanation = explanation
        self.points = points
        self.difficulty = difficulty
        self.sourceCardID = sourceCardID
    }

    /// Check whether the given answer is correct.
    public func isCorrect(answer: String) -> Bool {
        correctAnswers.contains { $0.lowercased().trimmingCharacters(in: .whitespaces) ==
            answer.lowercased().trimmingCharacters(in: .whitespaces) }
    }
}

// MARK: - Question Type

/// Supported question formats.
public enum QuestionType: String, Codable, Sendable, CaseIterable {
    case multipleChoice
    case trueFalse
    case shortAnswer
    case fillInTheBlank
    case matching

    public var displayName: String {
        switch self {
        case .multipleChoice:   return "Multiple Choice"
        case .trueFalse:        return "True / False"
        case .shortAnswer:      return "Short Answer"
        case .fillInTheBlank:   return "Fill in the Blank"
        case .matching:         return "Matching"
        }
    }
}

// MARK: - Quiz Result

/// Outcome of a completed quiz attempt.
public struct QuizResult: Identifiable, Codable, Sendable {

    public let id: UUID
    public let quizID: UUID
    public let subjectID: UUID

    /// Per-question answers submitted by the learner.
    public var answers: [QuizAnswer]

    /// Score as a value between 0 and 1.
    public var score: Double

    /// Total points earned.
    public var pointsEarned: Double

    /// Total points available.
    public var pointsAvailable: Double

    /// Total time taken in seconds.
    public var timeTaken: TimeInterval

    /// Whether the passing threshold was met.
    public var passed: Bool

    /// When the quiz was completed.
    public let completedAt: Date

    public init(
        id: UUID = UUID(),
        quizID: UUID,
        subjectID: UUID,
        answers: [QuizAnswer] = [],
        score: Double = 0,
        pointsEarned: Double = 0,
        pointsAvailable: Double = 0,
        timeTaken: TimeInterval = 0,
        passed: Bool = false,
        completedAt: Date = Date()
    ) {
        self.id = id
        self.quizID = quizID
        self.subjectID = subjectID
        self.answers = answers
        self.score = score
        self.pointsEarned = pointsEarned
        self.pointsAvailable = pointsAvailable
        self.timeTaken = timeTaken
        self.passed = passed
        self.completedAt = completedAt
    }
}

/// A single answer submitted for one quiz question.
public struct QuizAnswer: Identifiable, Codable, Sendable {
    public let id: UUID
    public let questionID: UUID
    public var selectedAnswer: String
    public var isCorrect: Bool
    public var responseTime: TimeInterval

    public init(
        id: UUID = UUID(),
        questionID: UUID,
        selectedAnswer: String,
        isCorrect: Bool,
        responseTime: TimeInterval = 0
    ) {
        self.id = id
        self.questionID = questionID
        self.selectedAnswer = selectedAnswer
        self.isCorrect = isCorrect
        self.responseTime = responseTime
    }
}
