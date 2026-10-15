import Foundation

/// The graded answer to one question.
public struct QuizResult: Codable, Sendable, Hashable {
    /// The question's identifier.
    public let questionID: String
    /// What the learner answered.
    public let response: QuizResponse
    /// How the answer was graded.
    public let evaluation: AnswerEvaluation
    /// How long the learner took, in seconds, if measured.
    public let duration: TimeInterval?

    /// A rating to pass to a scheduler for the item behind the question: ``Rating/again`` for a
    /// wrong answer, ``Rating/hard`` for an answer accepted with typos, ``Rating/good`` otherwise.
    public var suggestedRating: Rating {
        switch evaluation {
        case .incorrect: .again
        case .almostCorrect: .hard
        case .correct: .good
        }
    }
}

/// A quiz in progress: a list of questions and the answers given so far.
///
/// ```swift
/// var quiz = try QuizSession(questions: questions)
/// while let question = quiz.currentQuestion {
///     let result = try quiz.answer(.text(readLine() ?? ""), to: question.id)
///     print(result.evaluation)
/// }
/// print(quiz.score)
/// ```
///
/// It is a `Codable` value, so a quiz can be saved and resumed.
public struct QuizSession: Codable, Sendable, Hashable {
    /// The questions, in the order they are asked.
    public let questions: [QuizQuestion]
    /// How typed answers are compared.
    public let matcher: AnswerMatcher
    /// The graded answers so far, in the order they were given.
    public private(set) var results: [QuizResult]
    /// The position of each question in `questions`, so that answering looks a question up in
    /// constant time and resuming a saved quiz takes time proportional to its size.
    private let questionIndex: [String: Int]
    /// The position of each answered question's result in `results`, for constant-time lookups.
    private var resultIndex: [String: Int] = [:]
    /// The position in `questions` of the first unanswered question (`questions.count` once all
    /// are answered). It only moves forward, so asking for every question in turn costs linear time.
    private var nextPosition = 0

    /// Starts a quiz.
    /// - Throws: ``QuizError/duplicateQuestionID(_:)`` when two questions share an identifier, or
    ///   ``QuizError/invalidQuestion(_:)`` for a typed question that `matcher` can never grade as
    ///   right, such as one whose only accepted answer is "!!!" while punctuation is ignored.
    public init(questions: [QuizQuestion], matcher: AnswerMatcher = AnswerMatcher()) throws {
        var questionIndex = [String: Int](minimumCapacity: questions.count)
        for (position, question) in questions.enumerated() {
            guard questionIndex.updateValue(position, forKey: question.id) == nil else {
                throw QuizError.duplicateQuestionID(question.id)
            }
            if case .typedAnswer(let accepted) = question.kind, !accepted.contains(where: matcher.canMatch) {
                throw QuizError.invalidQuestion("\(question.id): no accepted answer can match with this matcher")
            }
        }
        self.questions = questions
        self.questionIndex = questionIndex
        self.matcher = matcher
        self.results = []
    }

    /// Decodes a saved quiz. Saved answers are graded again, so an edited file cannot mark a wrong
    /// answer right, and answers to unknown or already answered questions throw.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            questions: try container.decode([QuizQuestion].self, forKey: .questions),
            matcher: try container.decode(AnswerMatcher.self, forKey: .matcher)
        )
        for result in try container.decode([QuizResult].self, forKey: .results) {
            _ = try answer(result.response, to: result.questionID, duration: result.duration)
        }
    }

    private enum CodingKeys: String, CodingKey { case questions, matcher, results }

    /// The first question not yet answered, or `nil` when the quiz is complete.
    public var currentQuestion: QuizQuestion? {
        questions.indices.contains(nextPosition) ? questions[nextPosition] : nil
    }

    /// Whether every question has been answered.
    public var isComplete: Bool { results.count == questions.count }

    /// The number of answers that were accepted.
    public var correctCount: Int { results.count { $0.evaluation.isAccepted } }

    /// The share of all questions answered correctly, from 0 to 1 (0 for an empty quiz).
    public var score: Double {
        questions.isEmpty ? 0 : Double(correctCount) / Double(questions.count)
    }

    /// The graded answer to a question, if it has been answered.
    public func result(for questionID: String) -> QuizResult? {
        resultIndex[questionID].map { results[$0] }
    }

    /// Grades and records an answer.
    ///
    /// - Parameters:
    ///   - response: What the learner answered; it must fit the question's kind.
    ///   - questionID: The question answered.
    ///   - duration: How long the learner took, in seconds, kept in the result.
    /// - Throws: ``QuizError/unknownQuestion(_:)``, ``QuizError/alreadyAnswered(_:)`` or
    ///   ``QuizError/invalidResponse(_:)``.
    @discardableResult
    public mutating func answer(_ response: QuizResponse, to questionID: String, duration: TimeInterval? = nil) throws -> QuizResult {
        guard let position = questionIndex[questionID] else { throw QuizError.unknownQuestion(questionID) }
        let question = questions[position]
        guard resultIndex[questionID] == nil else { throw QuizError.alreadyAnswered(questionID) }
        let result = QuizResult(
            questionID: questionID,
            response: response,
            evaluation: try evaluate(response, for: question),
            duration: duration
        )
        resultIndex[questionID] = results.count
        results.append(result)
        while questions.indices.contains(nextPosition), resultIndex[questions[nextPosition].id] != nil {
            nextPosition += 1
        }
        return result
    }

    private func evaluate(_ response: QuizResponse, for question: QuizQuestion) throws -> AnswerEvaluation {
        switch (question.kind, response) {
        case let (.multipleChoice(choices, correctIndex), .choice(index)):
            guard choices.indices.contains(index) else {
                throw QuizError.invalidResponse("\(question.id): choice \(index) does not exist")
            }
            return index == correctIndex ? .correct : .incorrect
        case let (.trueFalse(answer), .trueFalse(given)):
            return answer == given ? .correct : .incorrect
        case let (.typedAnswer(accepted), .text(text)):
            return matcher.evaluate(text, acceptedAnswers: accepted)
        default:
            throw QuizError.invalidResponse("\(question.id): the response does not fit the question")
        }
    }
}
