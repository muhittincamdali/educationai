import XCTest
@testable import EducationAI

final class EducationAITests: XCTestCase {

    var educationAI: EducationAI!
    let subjectID = UUID()

    override func setUp() {
        super.setUp()
        let config = EducationAIConfiguration(
            storageSuite: "com.educationai.test.integration"
        )
        educationAI = EducationAI(configuration: config)
        // Clean slate
        educationAI.storage.removeAll()
        educationAI.progressTracker.reset()
        educationAI.gamification.reset()
    }

    override func tearDown() {
        educationAI.storage.removeAll()
        super.tearDown()
    }

    // MARK: - Initialization

    func testFrameworkInitializes() {
        XCTAssertNotNil(educationAI)
        XCTAssertNotNil(educationAI.quizEngine)
        XCTAssertNotNil(educationAI.spacedRepetition)
        XCTAssertNotNil(educationAI.adaptiveEngine)
        XCTAssertNotNil(educationAI.progressTracker)
        XCTAssertNotNil(educationAI.recommendationEngine)
        XCTAssertNotNil(educationAI.gamification)
        XCTAssertNotNil(educationAI.storage)
    }

    func testVersion() {
        XCTAssertFalse(EducationAI.version.isEmpty)
    }

    func testDefaultConfiguration() {
        let defaultAI = EducationAI()
        XCTAssertEqual(defaultAI.configuration.maxNewCardsPerDay, 20)
        XCTAssertEqual(defaultAI.configuration.maxReviewsPerDay, 100)
        XCTAssertEqual(defaultAI.configuration.adaptiveSensitivity, 0.5)
    }

    // MARK: - Integration: recordStudy

    func testRecordStudyReturnsCompleteResult() {
        let card = Flashcard(subjectID: subjectID, front: "Q", back: "A")
        let result = educationAI.recordStudy(card: card, rating: .good, responseTime: 3.0)

        // Updated card
        XCTAssertEqual(result.updatedCard.totalReviews, 1)
        XCTAssertEqual(result.updatedCard.correctCount, 1)
        XCTAssertGreaterThan(result.updatedCard.intervalDays, 0)

        // XP
        XCTAssertGreaterThan(result.xpEarned, 0)

        // Next review
        XCTAssertGreaterThan(result.nextReviewDate, Date())

        // Streak
        XCTAssertGreaterThanOrEqual(result.currentStreak, 1)
    }

    func testRecordStudyUpdatesProgress() {
        let card = Flashcard(subjectID: subjectID, front: "Q", back: "A")
        educationAI.recordStudy(card: card, rating: .good, responseTime: 3.0)

        let progress = educationAI.progressTracker.progress
        XCTAssertEqual(progress.totalReviews, 1)
        XCTAssertEqual(progress.totalStudyTime, 3.0)
    }

    func testRecordStudyUpdatesGamification() {
        let card = Flashcard(subjectID: subjectID, front: "Q", back: "A")
        educationAI.recordStudy(card: card, rating: .good, responseTime: 3.0)

        XCTAssertGreaterThan(educationAI.gamification.totalXP, 0)
        XCTAssertEqual(educationAI.gamification.currentStreak, 1)
    }

    func testRecordStudyUpdatesAdaptiveEngine() {
        let card = Flashcard(subjectID: subjectID, front: "Q", back: "A")

        // Multiple study events
        for _ in 0..<25 {
            educationAI.recordStudy(card: card, rating: .easy, responseTime: 2.0)
        }

        let snapshot = educationAI.adaptiveEngine.performanceMetrics(for: subjectID)
        XCTAssertGreaterThan(snapshot.eventCount, 0)
        XCTAssertEqual(snapshot.accuracy, 1.0, accuracy: 0.01)
    }

    // MARK: - Full Workflow

    func testFullStudyWorkflow() {
        // 1. Create flashcards
        let cards = (0..<20).map { i in
            Flashcard(subjectID: subjectID, front: "Question \(i)", back: "Answer \(i)")
        }

        // 2. Generate a quiz
        let quiz = educationAI.quizEngine.generate(from: cards, count: 5)
        XCTAssertEqual(quiz.questions.count, 5)

        // 3. Get study queue
        let queue = educationAI.spacedRepetition.studyQueue(from: cards, maxNew: 10)
        XCTAssertFalse(queue.isEmpty)

        // 4. Study cards and record results
        var updatedCards: [Flashcard] = []
        for card in queue.prefix(5) {
            let result = educationAI.recordStudy(card: card, rating: .good, responseTime: 4.0)
            updatedCards.append(result.updatedCard)
        }

        // 5. Check progress
        let progress = educationAI.progressTracker.progress
        XCTAssertEqual(progress.totalReviews, 5)
        XCTAssertNotNil(progress.subjects[subjectID])

        // 6. Get recommendations
        let recs = educationAI.recommendationEngine.recommend(
            cards: cards,
            progress: progress
        )
        XCTAssertFalse(recs.isEmpty)

        // 7. Check gamification
        XCTAssertGreaterThan(educationAI.gamification.totalXP, 0)
        XCTAssertGreaterThanOrEqual(educationAI.gamification.currentLevel, 1)
    }

    // MARK: - Multi-Subject Workflow

    func testMultiSubjectStudy() {
        let subject1 = UUID()
        let subject2 = UUID()

        let cards1 = (0..<10).map { i in
            Flashcard(subjectID: subject1, front: "Math Q\(i)", back: "Math A\(i)")
        }
        let cards2 = (0..<10).map { i in
            Flashcard(subjectID: subject2, front: "Sci Q\(i)", back: "Sci A\(i)")
        }

        // Study subject 1
        for card in cards1.prefix(5) {
            educationAI.recordStudy(card: card, rating: .good, responseTime: 3.0)
        }

        // Study subject 2
        for card in cards2.prefix(3) {
            educationAI.recordStudy(card: card, rating: .easy, responseTime: 2.0)
        }

        let progress = educationAI.progressTracker.progress
        XCTAssertEqual(progress.totalReviews, 8)
        XCTAssertNotNil(progress.subjects[subject1])
        XCTAssertNotNil(progress.subjects[subject2])
    }

    // MARK: - Entity Tests

    func testFlashcardProperties() {
        let card = Flashcard(subjectID: subjectID, front: "Q", back: "A", tags: ["math"])
        XCTAssertTrue(card.isNew)
        XCTAssertFalse(card.isLapsed)
        XCTAssertEqual(card.accuracy, 0)
        XCTAssertEqual(card.tags, ["math"])
    }

    func testDifficultyLevelOrdering() {
        XCTAssertLessThan(DifficultyLevel.easy, DifficultyLevel.medium)
        XCTAssertLessThan(DifficultyLevel.medium, DifficultyLevel.hard)
        XCTAssertLessThan(DifficultyLevel.hard, DifficultyLevel.expert)
    }

    func testRecallRatingOrdering() {
        XCTAssertLessThan(RecallRating.again, RecallRating.hard)
        XCTAssertLessThan(RecallRating.hard, RecallRating.good)
        XCTAssertLessThan(RecallRating.good, RecallRating.easy)
    }

    func testRecallRatingCorrectness() {
        XCTAssertFalse(RecallRating.again.isCorrect)
        XCTAssertFalse(RecallRating.hard.isCorrect)
        XCTAssertTrue(RecallRating.good.isCorrect)
        XCTAssertTrue(RecallRating.easy.isCorrect)
    }

    func testBadgeTierOrdering() {
        XCTAssertLessThan(BadgeTier.bronze, BadgeTier.silver)
        XCTAssertLessThan(BadgeTier.silver, BadgeTier.gold)
        XCTAssertLessThan(BadgeTier.gold, BadgeTier.platinum)
        XCTAssertLessThan(BadgeTier.platinum, BadgeTier.diamond)
    }

    func testSubjectCategoryDisplayNames() {
        for category in SubjectCategory.allCases {
            XCTAssertFalse(category.displayName.isEmpty)
            XCTAssertFalse(category.systemImage.isEmpty)
        }
    }

    // MARK: - Performance

    func testStudyRecordingPerformance() {
        let card = Flashcard(subjectID: subjectID, front: "Q", back: "A")
        measure {
            for _ in 0..<100 {
                educationAI.recordStudy(card: card, rating: .good, responseTime: 3.0)
            }
        }
    }

    func testQuizGenerationPerformance() {
        let cards = (0..<1000).map { i in
            Flashcard(subjectID: subjectID, front: "Q\(i)", back: "A\(i)")
        }
        measure {
            _ = educationAI.quizEngine.generate(from: cards, count: 50)
        }
    }
}
