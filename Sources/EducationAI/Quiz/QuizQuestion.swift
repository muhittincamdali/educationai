/// Errors thrown when a quiz question or answer is not usable.
public enum QuizError: Error, Sendable, Hashable {
    /// The question cannot be asked; the message says why.
    case invalidQuestion(String)
    /// Two questions in a session share an identifier.
    case duplicateQuestionID(String)
    /// No question in the session has this identifier.
    case unknownQuestion(String)
    /// The question was already answered in this session.
    case alreadyAnswered(String)
    /// The response does not fit the question, such as a choice for a typed question or a choice
    /// index that does not exist.
    case invalidResponse(String)
}

/// One question of a quiz.
///
/// The initializer and the decoder check the question, so a session never meets a multiple-choice
/// question whose correct index does not exist.
public struct QuizQuestion: Identifiable, Codable, Sendable, Hashable {
    /// The form of a question and its right answer.
    public enum Kind: Codable, Sendable, Hashable {
        /// Pick one of `choices`; `correctIndex` is the right one.
        case multipleChoice(choices: [String], correctIndex: Int)
        /// Say whether the prompt is true.
        case trueFalse(answer: Bool)
        /// Type the answer; any of `acceptedAnswers` counts, as compared by ``AnswerMatcher``.
        case typedAnswer(acceptedAnswers: [String])
    }

    /// The most choices a multiple-choice question may have.
    public static let maximumChoices = 10

    /// The matcher that folds nothing but white space and invisible characters, so an accepted
    /// answer it cannot match is one that no matcher can match.
    private static let literalMatcher = AnswerMatcher(
        ignoresCase: false, ignoresDiacritics: false, ignoresPunctuation: false, typoTolerance: .none
    )

    /// The question's identifier, unique within a session.
    public let id: String
    /// The question text.
    public let prompt: String
    /// The form of the question and its answer.
    public let kind: Kind
    /// An optional explanation to show after the answer.
    public let explanation: String?

    /// Creates a question.
    /// - Throws: ``QuizError/invalidQuestion(_:)`` for a multiple-choice question with fewer than
    ///   2 or more than ``maximumChoices`` choices, a correct index outside the choices, or a typed
    ///   question without an accepted answer that can be typed: one that keeps a character once
    ///   white space and invisible characters are removed and is at most
    ///   ``AnswerMatcher/maximumLength`` characters long.
    public init(id: String, prompt: String, kind: Kind, explanation: String? = nil) throws {
        switch kind {
        case let .multipleChoice(choices, correctIndex):
            guard (2...Self.maximumChoices).contains(choices.count) else {
                throw QuizError.invalidQuestion("\(id): \(choices.count) choices, expected 2...\(Self.maximumChoices)")
            }
            guard choices.indices.contains(correctIndex) else {
                throw QuizError.invalidQuestion("\(id): correctIndex \(correctIndex) outside the choices")
            }
        case .typedAnswer(let accepted):
            guard accepted.contains(where: Self.literalMatcher.canMatch) else {
                throw QuizError.invalidQuestion("\(id): no accepted answer that can be typed")
            }
        case .trueFalse:
            break
        }
        self.id = id
        self.prompt = prompt
        self.kind = kind
        self.explanation = explanation
    }

    private enum CodingKeys: String, CodingKey { case id, prompt, kind, explanation }

    /// Decodes a question and checks it as the initializer does.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            id: try container.decode(String.self, forKey: .id),
            prompt: try container.decode(String.self, forKey: .prompt),
            kind: try container.decode(Kind.self, forKey: .kind),
            explanation: try container.decodeIfPresent(String.self, forKey: .explanation)
        )
    }
}

/// A learner's response to a question.
public enum QuizResponse: Codable, Sendable, Hashable {
    /// The index of the chosen option of a multiple-choice question.
    case choice(Int)
    /// The answer to a true-or-false question.
    case trueFalse(Bool)
    /// The text typed for a typed-answer question.
    case text(String)
}
