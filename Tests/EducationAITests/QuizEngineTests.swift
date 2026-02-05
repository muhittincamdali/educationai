import XCTest
@testable import EducationAI

final class QuizEngineTests: XCTestCase {

    var engine: QuizEngine!
    var testCards: [Flashcard]!
    let subjectID = UUID()

    override func setUp() {
        super.setUp()
        engine = QuizEngine()
        testCards = (0..<20).map { i in
            Flashcard(
                subjectID: subjectID,
                front: "Question \(i)",
                back: "Answer \(i)",
                difficulty: DifficultyLevel.allCases[i % 4]
            )
        }
    }

    // MARK: - Generation Tests

    func testGenerateQuizFromCards() {
        let quiz = engine.generate(from: testCards, count: 10)
        XCTAssertEqual(quiz.questions.count, 10)
        XCTAssertEqual(quiz.subjectID, subjectID)
    }

    func testGenerateQuizWithFewerCardsThanRequested() {
        let fewCards = Array(testCards.prefix(3))
        let quiz = engine.generate(from: fewCards, count: 10)
        XCTAssertEqual(quiz.questions.count, 3)
    }

    func testGenerateQuizFromEmptyCards() {
        let quiz = engine.generate(from: [], count: 10)
        XCTAssertEqual(quiz.questions.count, 0)
    }

    func testGenerateQuizWithDifficultyFilter() {
        let quiz = engine.generate(from: testCards, count: 5, difficulty: .easy)
        // All questions should come from easy cards
        for question in quiz.questions {
            if let sourceID = question.sourceCardID,
               let card = testCards.first(where: { $0.id == sourceID }) {
                XCTAssertEqual(card.difficulty, .easy)
            }
        }
    }

    func testGenerateMultipleChoiceQuestions() {
        let quiz = engine.generate(from: testCards, count: 5, types: [.multipleChoice])
        for question in quiz.questions {
            XCTAssertEqual(question.type, .multipleChoice)
            XCTAssertGreaterThanOrEqual(question.options.count, 2)
            // Correct answer should be in options
            XCTAssertTrue(question.options.contains { question.correctAnswers.contains($0) })
        }
    }

    func testGenerateTrueFalseQuestions() {
        let quiz = engine.generate(from: testCards, count: 5, types: [.trueFalse])
        for question in quiz.questions {
            XCTAssertEqual(question.type, .trueFalse)
            XCTAssertEqual(question.options.count, 2)
            XCTAssertTrue(question.options.contains("True"))
            XCTAssertTrue(question.options.contains("False"))
        }
    }

    func testGenerateShortAnswerQuestions() {
        let quiz = engine.generate(from: testCards, count: 5, types: [.shortAnswer])
        for question in quiz.questions {
            XCTAssertEqual(question.type, .shortAnswer)
            XCTAssertTrue(question.options.isEmpty)
            XCTAssertFalse(question.correctAnswers.isEmpty)
        }
    }

    func testQuestionsHaveSourceCardIDs() {
        let quiz = engine.generate(from: testCards, count: 5)
        for question in quiz.questions {
            XCTAssertNotNil(question.sourceCardID)
        }
    }

    // MARK: - Scoring Tests

    func testPerfectScore() {
        let quiz = engine.generate(from: testCards, count: 5, types: [.shortAnswer])
        var answers: [UUID: String] = [:]
        for question in quiz.questions {
            answers[question.id] = question.correctAnswers.first!
        }
        let result = engine.score(quiz: quiz, answers: answers, timeTaken: 60)
        XCTAssertEqual(result.score, 1.0, accuracy: 0.001)
        XCTAssertTrue(result.passed)
    }

    func testZeroScore() {
        let quiz = engine.generate(from: testCards, count: 5, types: [.shortAnswer])
        var answers: [UUID: String] = [:]
        for question in quiz.questions {
            answers[question.id] = "completely wrong"
        }
        let result = engine.score(quiz: quiz, answers: answers, timeTaken: 60)
        XCTAssertEqual(result.score, 0.0, accuracy: 0.001)
        XCTAssertFalse(result.passed)
    }

    func testPartialScore() {
        let quiz = engine.generate(from: testCards, count: 4, types: [.shortAnswer], shuffle: false)
        var answers: [UUID: String] = [:]
        for (i, question) in quiz.questions.enumerated() {
            if i < 2 {
                answers[question.id] = question.correctAnswers.first!
            } else {
                answers[question.id] = "wrong"
            }
        }
        let result = engine.score(quiz: quiz, answers: answers, timeTaken: 60)
        XCTAssertEqual(result.score, 0.5, accuracy: 0.001)
    }

    func testMissingAnswerCountsAsWrong() {
        let quiz = engine.generate(from: testCards, count: 5, types: [.shortAnswer])
        let answers: [UUID: String] = [:] // No answers submitted
        let result = engine.score(quiz: quiz, answers: answers, timeTaken: 60)
        XCTAssertEqual(result.score, 0.0, accuracy: 0.001)
    }

    func testScoreRecordsTimeTaken() {
        let quiz = engine.generate(from: testCards, count: 3)
        let result = engine.score(quiz: quiz, answers: [:], timeTaken: 120.5)
        XCTAssertEqual(result.timeTaken, 120.5)
    }

    func testScoreRecordsPerQuestionResults() {
        let quiz = engine.generate(from: testCards, count: 3, types: [.shortAnswer])
        let result = engine.score(quiz: quiz, answers: [:], timeTaken: 30)
        XCTAssertEqual(result.answers.count, quiz.questions.count)
    }

    // MARK: - Question Correctness

    func testQuestionIsCorrectCaseInsensitive() {
        let question = Question(
            text: "Capital of France?",
            correctAnswers: ["Paris"]
        )
        XCTAssertTrue(question.isCorrect(answer: "paris"))
        XCTAssertTrue(question.isCorrect(answer: "PARIS"))
        XCTAssertTrue(question.isCorrect(answer: " Paris "))
    }

    func testQuestionIsCorrectWithMultipleAnswers() {
        let question = Question(
            text: "Name a primary color",
            correctAnswers: ["Red", "Blue", "Yellow"]
        )
        XCTAssertTrue(question.isCorrect(answer: "red"))
        XCTAssertTrue(question.isCorrect(answer: "blue"))
        XCTAssertFalse(question.isCorrect(answer: "purple"))
    }

    // MARK: - Quiz Properties

    func testTotalPoints() {
        let questions = [
            Question(text: "Q1", correctAnswers: ["A"], points: 2.0),
            Question(text: "Q2", correctAnswers: ["B"], points: 3.0),
        ]
        let quiz = Quiz(subjectID: subjectID, questions: questions)
        XCTAssertEqual(quiz.totalPoints, 5.0)
    }

    func testPassingScore() {
        let quiz = Quiz(subjectID: subjectID, passingScore: 0.8)
        XCTAssertEqual(quiz.passingScore, 0.8)
    }
}
