import Foundation
import Testing
@testable import EducationAI

struct QuizTests {
    let capitals = [
        Flashcard(id: "fr", front: "Capital of France", back: "Paris"),
        Flashcard(id: "jp", front: "Capital of Japan", back: "Tokyo"),
        Flashcard(id: "ke", front: "Capital of Kenya", back: "Nairobi"),
        Flashcard(id: "pe", front: "Capital of Peru", back: "Lima"),
        Flashcard(id: "np", front: "Capital of Nepal", back: "Kathmandu", alternativeAnswers: ["Katmandu"])
    ]

    @Test func flashcardsCarryTheirStateIntoTheStudyQueue() throws {
        let now = Date(timeIntervalSince1970: 1_760_500_000)
        var deck = capitals.map { card in
            var card = card
            card.review = ReviewState(due: now)
            return card
        }
        deck[0].review = try FSRSScheduler().review(deck[0].review, rating: .easy, at: now).state
        #expect(StudyQueue.cards(from: deck, at: now, newLimit: 3).map(\.id) == ["jp", "ke", "pe"])
        #expect(deck[4].acceptedAnswers == ["Kathmandu", "Katmandu"])
    }

    // MARK: Questions

    @Test func rejectsQuestionsThatCannotBeAnswered() {
        #expect(throws: QuizError.self) { try QuizQuestion(id: "a", prompt: "?", kind: .multipleChoice(choices: ["only"], correctIndex: 0)) }
        #expect(throws: QuizError.self) { try QuizQuestion(id: "b", prompt: "?", kind: .multipleChoice(choices: ["x", "y"], correctIndex: 2)) }
        #expect(throws: QuizError.self) { try QuizQuestion(id: "c", prompt: "?", kind: .multipleChoice(choices: ["x", "y"], correctIndex: -1)) }
        #expect(throws: QuizError.self) {
            try QuizQuestion(id: "d", prompt: "?", kind: .multipleChoice(choices: (0...10).map(String.init), correctIndex: 0))
        }
        #expect(throws: QuizError.self) { try QuizQuestion(id: "e", prompt: "?", kind: .typedAnswer(acceptedAnswers: [])) }
        #expect(throws: QuizError.self) { try QuizQuestion(id: "f", prompt: "?", kind: .typedAnswer(acceptedAnswers: [" ", "\n"])) }
    }

    @Test func decodingChecksTheQuestion() throws {
        let valid = try QuizQuestion(id: "q", prompt: "2 + 2", kind: .multipleChoice(choices: ["3", "4"], correctIndex: 1), explanation: "Arithmetic")
        let data = try JSONEncoder().encode(valid)
        #expect(try JSONDecoder().decode(QuizQuestion.self, from: data) == valid)
        let tampered = String(decoding: data, as: UTF8.self).replacingOccurrences(of: #""correctIndex":1"#, with: #""correctIndex":7"#)
        #expect(tampered != String(decoding: data, as: UTF8.self))
        #expect(throws: QuizError.self) { try JSONDecoder().decode(QuizQuestion.self, from: Data(tampered.utf8)) }
    }

    // MARK: Sessions

    @Test func gradesEachKindOfQuestion() throws {
        let questions = [
            try QuizQuestion(id: "mc", prompt: "2 + 2", kind: .multipleChoice(choices: ["3", "4", "5"], correctIndex: 1)),
            try QuizQuestion(id: "tf", prompt: "The sun is a star", kind: .trueFalse(answer: true)),
            try QuizQuestion(id: "typed", prompt: "Capital of Nepal", kind: .typedAnswer(acceptedAnswers: ["Kathmandu"])),
            try QuizQuestion(id: "typo", prompt: "Capital of Kenya", kind: .typedAnswer(acceptedAnswers: ["Nairobi"]))
        ]
        var quiz = try QuizSession(questions: questions)
        #expect(quiz.currentQuestion?.id == "mc")
        #expect(try quiz.answer(.choice(1), to: "mc").evaluation == .correct)
        #expect(try quiz.answer(.trueFalse(false), to: "tf").suggestedRating == .again)
        #expect(try quiz.answer(.text("kathmandu"), to: "typed", duration: 3).suggestedRating == .good)
        let typo = try quiz.answer(.text("Nairbi"), to: "typo")
        #expect(typo.evaluation == .almostCorrect(expected: "Nairobi", typos: 1))
        #expect(typo.suggestedRating == .hard)
        #expect(quiz.isComplete)
        #expect(quiz.currentQuestion == nil)
        #expect(quiz.correctCount == 3)
        #expect(quiz.score == 0.75)
        #expect(quiz.result(for: "typed")?.duration == 3)
    }

    @Test func rejectsResponsesThatDoNotFit() throws {
        let questions = [
            try QuizQuestion(id: "mc", prompt: "?", kind: .multipleChoice(choices: ["a", "b"], correctIndex: 0)),
            try QuizQuestion(id: "typed", prompt: "?", kind: .typedAnswer(acceptedAnswers: ["x"]))
        ]
        var quiz = try QuizSession(questions: questions)
        #expect(throws: QuizError.invalidResponse("mc: choice 2 does not exist")) { try quiz.answer(.choice(2), to: "mc") }
        #expect(throws: QuizError.self) { try quiz.answer(.choice(Int.min), to: "mc") }
        #expect(throws: QuizError.self) { try quiz.answer(.choice(0), to: "typed") }
        #expect(throws: QuizError.unknownQuestion("nope")) { try quiz.answer(.text("x"), to: "nope") }
        try quiz.answer(.choice(0), to: "mc")
        #expect(throws: QuizError.alreadyAnswered("mc")) { try quiz.answer(.choice(1), to: "mc") }
        #expect(quiz.results.count == 1)
    }

    @Test func rejectsDuplicateQuestionIDs() throws {
        let question = try QuizQuestion(id: "same", prompt: "?", kind: .trueFalse(answer: true))
        #expect(throws: QuizError.duplicateQuestionID("same")) { try QuizSession(questions: [question, question]) }
    }

    @Test func emptyQuizScoresZeroAndIsComplete() throws {
        let quiz = try QuizSession(questions: [])
        #expect(quiz.score == 0)
        #expect(quiz.isComplete)
    }

    @Test func savedQuizResumesAndRegradesItsAnswers() throws {
        var quiz = try QuizSession(questions: QuizBuilder.typedAnswer(from: capitals))
        try quiz.answer(.text("Paris"), to: "fr")
        try quiz.answer(.text("Kyoto"), to: "jp")
        let data = try JSONEncoder().encode(quiz)
        let resumed = try JSONDecoder().decode(QuizSession.self, from: data)
        #expect(resumed == quiz)
        #expect(resumed.currentQuestion?.id == "ke")

        // A saved file edited to mark the wrong answer right is graded again on loading.
        var json = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
        var results = try #require(json["results"] as? [[String: Any]])
        results[1]["evaluation"] = ["correct": [String: String]()]
        json["results"] = results
        let edited = try JSONDecoder().decode(QuizSession.self, from: JSONSerialization.data(withJSONObject: json))
        #expect(edited.result(for: "jp")?.evaluation == .incorrect)

        // A saved file that answers a question twice is rejected.
        results.append(results[0])
        json["results"] = results
        #expect(throws: QuizError.alreadyAnswered("fr")) {
            try JSONDecoder().decode(QuizSession.self, from: JSONSerialization.data(withJSONObject: json))
        }
    }

    @Test func largeSavedQuizzesResumeInLinearTime() throws {
        let questions = try (0..<100_000).map { try QuizQuestion(id: "q\($0)", prompt: "Statement \($0)", kind: .trueFalse(answer: $0.isMultiple(of: 2))) }
        var quiz = try QuizSession(questions: questions)
        for question in questions.dropLast() {
            try quiz.answer(.trueFalse(true), to: question.id)
        }
        let data = try JSONEncoder().encode(quiz)
        let start = Date()
        let resumed = try JSONDecoder().decode(QuizSession.self, from: data)
        // Finding each saved answer's question by scanning the list made this quadratic: about 20 s.
        #expect(Date().timeIntervalSince(start) < 5)
        #expect(resumed == quiz)
        #expect(resumed.currentQuestion?.id == "q99999")
        #expect(resumed.correctCount == 50_000)
    }

    @Test func currentQuestionSkipsQuestionsAnsweredOutOfOrder() throws {
        var quiz = try QuizSession(questions: QuizBuilder.typedAnswer(from: capitals))
        try quiz.answer(.text("Tokyo"), to: "jp")
        #expect(quiz.currentQuestion?.id == "fr")
        try quiz.answer(.text("Paris"), to: "fr")
        #expect(quiz.currentQuestion?.id == "ke")
        for id in ["np", "pe", "ke"] { try quiz.answer(.text("?"), to: id) }
        #expect(quiz.currentQuestion == nil)
        #expect(quiz.isComplete)
    }

    // MARK: Builder

    @Test func multipleChoiceUsesOtherCardsAnswersAsWrongChoices() throws {
        var generator = SeededRandomNumberGenerator(seed: 3)
        let questions = QuizBuilder.multipleChoice(from: capitals, choiceCount: 4, using: &generator)
        #expect(questions.map(\.id) == capitals.map(\.id))
        for (question, card) in zip(questions, capitals) {
            guard case let .multipleChoice(choices, correctIndex) = question.kind else {
                Issue.record("not multiple choice")
                continue
            }
            #expect(choices.count == 4)
            #expect(choices[correctIndex] == card.back)
            #expect(Set(choices).count == 4)
            #expect(Set(choices).isSubset(of: Set(capitals.map(\.back))))
        }
    }

    @Test func sameSeedGivesTheSameQuiz() {
        var first = SeededRandomNumberGenerator(seed: 11)
        var second = SeededRandomNumberGenerator(seed: 11)
        #expect(QuizBuilder.multipleChoice(from: capitals, using: &first) == QuizBuilder.multipleChoice(from: capitals, using: &second))
    }

    @Test func answersThatNormalizeAlikeAreNeverOfferedTogether() {
        let cards = [
            Flashcard(id: "a", front: "A", back: "Paris"),
            Flashcard(id: "b", front: "B", back: "paris"),
            Flashcard(id: "c", front: "C", back: "PARIS!"),
            Flashcard(id: "d", front: "D", back: "Rome")
        ]
        var generator = SeededRandomNumberGenerator(seed: 1)
        let questions = QuizBuilder.multipleChoice(from: cards, choiceCount: 4, using: &generator)
        #expect(questions.count == 4)
        for question in questions {
            guard case let .multipleChoice(choices, _) = question.kind else { continue }
            #expect(choices.count == 2)
            #expect(Set(choices.map { AnswerMatcher().normalized($0) }).count == 2)
        }
    }

    @Test func cardsWithoutADifferentAnswerGetNoQuestion() {
        let cards = [Flashcard(id: "a", front: "A", back: "Same"), Flashcard(id: "b", front: "B", back: "same")]
        #expect(QuizBuilder.multipleChoice(from: cards).isEmpty)
        #expect(QuizBuilder.multipleChoice(from: Array(capitals.prefix(1))).isEmpty)
    }

    @Test(arguments: [Int.min, -1, 0, 1, 2, 3, 99, .max])
    func choiceCountIsClamped(choiceCount: Int) {
        let deck = (0..<20).map { Flashcard(id: "\($0)", front: "Q\($0)", back: "A\($0)") }
        let questions = QuizBuilder.multipleChoice(from: deck, choiceCount: choiceCount)
        for question in questions {
            guard case let .multipleChoice(choices, _) = question.kind else { continue }
            #expect((2...QuizQuestion.maximumChoices).contains(choices.count))
        }
    }

    @Test func largeDecksAreBuiltInLinearTime() throws {
        let deck = (0..<20_000).map { Flashcard(id: "\($0)", front: "Q\($0)", back: "Answer \($0)") }
        var generator = SeededRandomNumberGenerator(seed: 5)
        let start = Date()
        let questions = QuizBuilder.multipleChoice(from: deck, choiceCount: 6, using: &generator)
        #expect(Date().timeIntervalSince(start) < 30)
        #expect(questions.count == deck.count)
        let first = try #require(questions.first)
        guard case let .multipleChoice(choices, correctIndex) = first.kind else { return }
        #expect(choices.count == 6)
        #expect(choices[correctIndex] == "Answer 0")
    }

    @Test func typedQuestionsAcceptAlternatives() throws {
        var quiz = try QuizSession(questions: QuizBuilder.typedAnswer(from: capitals))
        #expect(try quiz.answer(.text("katmandu"), to: "np").evaluation == .correct)
        let blank = Flashcard(id: "blank", front: "?", back: "  ")
        #expect(QuizBuilder.typedAnswer(from: [blank]).isEmpty)
    }
}
