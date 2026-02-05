import Foundation

/// Engine for generating quizzes from flashcard decks.
///
/// Supports multiple question types: multiple choice, true/false,
/// short answer, and fill-in-the-blank.
///
/// ```swift
/// let engine = QuizEngine()
/// let quiz = engine.generate(
///     from: flashcards,
///     count: 10,
///     types: [.multipleChoice, .trueFalse],
///     difficulty: .medium
/// )
/// ```
public struct QuizEngine: Sendable {

    public init() {}

    // MARK: - Generation

    /// Generate a quiz from a set of flashcards.
    ///
    /// - Parameters:
    ///   - cards: Source flashcards to generate questions from.
    ///   - count: Number of questions to generate.
    ///   - types: Allowed question types. Defaults to all types.
    ///   - difficulty: Target difficulty. Pass `nil` for mixed.
    ///   - shuffle: Whether to shuffle the question order. Defaults to `true`.
    /// - Returns: A fully formed ``Quiz`` ready to be presented.
    public func generate(
        from cards: [Flashcard],
        count: Int = 10,
        types: [QuestionType] = QuestionType.allCases,
        difficulty: DifficultyLevel? = nil,
        shuffle: Bool = true
    ) -> Quiz {
        guard !cards.isEmpty else {
            return Quiz(subjectID: UUID(), questions: [])
        }

        let subjectID = cards.first!.subjectID

        // Filter by difficulty if specified
        var pool = cards
        if let difficulty = difficulty {
            let filtered = cards.filter { $0.difficulty == difficulty }
            if !filtered.isEmpty { pool = filtered }
        }

        // Shuffle pool
        if shuffle { pool.shuffle() }

        // Generate questions
        let questionCount = min(count, pool.count)
        var questions: [Question] = []

        for i in 0..<questionCount {
            let card = pool[i]
            let type = types.randomElement() ?? .multipleChoice
            let question = generateQuestion(from: card, type: type, allCards: pool)
            questions.append(question)
        }

        if shuffle { questions.shuffle() }

        return Quiz(
            title: "Quiz — \(questionCount) Questions",
            subjectID: subjectID,
            questions: questions,
            difficulty: difficulty ?? .medium
        )
    }

    // MARK: - Scoring

    /// Score a completed quiz attempt.
    ///
    /// - Parameters:
    ///   - quiz: The original quiz.
    ///   - answers: The learner's answers (keyed by question ID).
    ///   - timeTaken: Total time in seconds.
    /// - Returns: A ``QuizResult`` with detailed scoring.
    public func score(
        quiz: Quiz,
        answers: [UUID: String],
        timeTaken: TimeInterval
    ) -> QuizResult {
        var quizAnswers: [QuizAnswer] = []
        var pointsEarned: Double = 0

        for question in quiz.questions {
            let submitted = answers[question.id] ?? ""
            let correct = question.isCorrect(answer: submitted)
            if correct {
                pointsEarned += question.points
            }
            quizAnswers.append(QuizAnswer(
                questionID: question.id,
                selectedAnswer: submitted,
                isCorrect: correct
            ))
        }

        let totalPoints = quiz.totalPoints
        let score = totalPoints > 0 ? pointsEarned / totalPoints : 0

        return QuizResult(
            quizID: quiz.id,
            subjectID: quiz.subjectID,
            answers: quizAnswers,
            score: score,
            pointsEarned: pointsEarned,
            pointsAvailable: totalPoints,
            timeTaken: timeTaken,
            passed: score >= quiz.passingScore
        )
    }

    // MARK: - Private Helpers

    private func generateQuestion(
        from card: Flashcard,
        type: QuestionType,
        allCards: [Flashcard]
    ) -> Question {
        switch type {
        case .multipleChoice:
            return makeMultipleChoice(from: card, allCards: allCards)
        case .trueFalse:
            return makeTrueFalse(from: card, allCards: allCards)
        case .shortAnswer:
            return makeShortAnswer(from: card)
        case .fillInTheBlank:
            return makeFillInTheBlank(from: card)
        case .matching:
            return makeShortAnswer(from: card) // Fallback for single-card
        }
    }

    private func makeMultipleChoice(from card: Flashcard, allCards: [Flashcard]) -> Question {
        // Build distractors from other cards
        let distractors = allCards
            .filter { $0.id != card.id }
            .shuffled()
            .prefix(3)
            .map(\.back)

        var options = Array(distractors) + [card.back]
        options.shuffle()

        return Question(
            text: card.front,
            type: .multipleChoice,
            options: options,
            correctAnswers: [card.back],
            explanation: "The correct answer is: \(card.back)",
            difficulty: card.difficulty,
            sourceCardID: card.id
        )
    }

    private func makeTrueFalse(from card: Flashcard, allCards: [Flashcard]) -> Question {
        let showCorrect = Bool.random()
        let displayedAnswer: String
        let isTrue: Bool

        if showCorrect {
            displayedAnswer = card.back
            isTrue = true
        } else {
            // Pick a wrong answer from another card
            let wrong = allCards
                .filter { $0.id != card.id }
                .randomElement()?.back ?? "Incorrect"
            displayedAnswer = wrong
            isTrue = false
        }

        return Question(
            text: "\(card.front) — \(displayedAnswer)",
            type: .trueFalse,
            options: ["True", "False"],
            correctAnswers: [isTrue ? "True" : "False"],
            explanation: "The correct answer for \"\(card.front)\" is: \(card.back)",
            difficulty: card.difficulty,
            sourceCardID: card.id
        )
    }

    private func makeShortAnswer(from card: Flashcard) -> Question {
        Question(
            text: card.front,
            type: .shortAnswer,
            options: [],
            correctAnswers: [card.back],
            hint: String(card.back.prefix(1)) + "...",
            explanation: "The answer is: \(card.back)",
            difficulty: card.difficulty,
            sourceCardID: card.id
        )
    }

    private func makeFillInTheBlank(from card: Flashcard) -> Question {
        let words = card.back.split(separator: " ")
        let blanked: String
        if words.count > 2, let idx = words.indices.randomElement() {
            var mutable = Array(words)
            let answer = String(mutable[idx])
            mutable[idx] = "____"
            blanked = mutable.joined(separator: " ")
            return Question(
                text: "\(card.front): \(blanked)",
                type: .fillInTheBlank,
                options: [],
                correctAnswers: [answer],
                explanation: "The full answer is: \(card.back)",
                difficulty: card.difficulty,
                sourceCardID: card.id
            )
        } else {
            // Fallback to short answer if answer is too short to blank
            return makeShortAnswer(from: card)
        }
    }
}
