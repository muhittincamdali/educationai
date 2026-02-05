import XCTest
@testable import EducationAI

final class SpacedRepetitionTests: XCTestCase {

    var scheduler: SpacedRepetitionScheduler!
    var testCard: Flashcard!
    let subjectID = UUID()

    override func setUp() {
        super.setUp()
        scheduler = SpacedRepetitionScheduler()
        testCard = Flashcard(
            subjectID: subjectID,
            front: "What is 2+2?",
            back: "4"
        )
    }

    // MARK: - New Card Tests

    func testNewCardDefaults() {
        XCTAssertEqual(testCard.easinessFactor, 2.5)
        XCTAssertEqual(testCard.repetitionCount, 0)
        XCTAssertEqual(testCard.intervalDays, 0)
        XCTAssertTrue(testCard.isNew)
        XCTAssertEqual(testCard.totalReviews, 0)
    }

    func testFirstCorrectReviewSetsOneDayInterval() {
        let updated = scheduler.review(card: testCard, rating: .good)
        XCTAssertEqual(updated.intervalDays, 1.0, accuracy: 0.01)
        XCTAssertEqual(updated.repetitionCount, 1)
        XCTAssertEqual(updated.totalReviews, 1)
        XCTAssertEqual(updated.correctCount, 1)
    }

    func testSecondCorrectReviewSetsSixDayInterval() {
        var card = scheduler.review(card: testCard, rating: .good)
        card = scheduler.review(card: card, rating: .good)
        XCTAssertEqual(card.intervalDays, 6.0, accuracy: 0.01)
        XCTAssertEqual(card.repetitionCount, 2)
    }

    func testThirdCorrectReviewUsesEasinessFactor() {
        var card = scheduler.review(card: testCard, rating: .good)
        card = scheduler.review(card: card, rating: .good)
        card = scheduler.review(card: card, rating: .good)
        // interval = 6.0 * EF (EF should be around 2.5 after "good" ratings)
        XCTAssertGreaterThan(card.intervalDays, 6.0)
        XCTAssertEqual(card.repetitionCount, 3)
    }

    // MARK: - Rating Impact Tests

    func testEasyRatingGivesLongerInterval() {
        let good = scheduler.review(card: testCard, rating: .good)
        let easy = scheduler.review(card: testCard, rating: .easy)
        // Easy should have bonus applied
        XCTAssertGreaterThanOrEqual(easy.intervalDays, good.intervalDays)
    }

    func testAgainRatingResetsRepetitionCount() {
        var card = scheduler.review(card: testCard, rating: .good)
        card = scheduler.review(card: card, rating: .good)
        XCTAssertEqual(card.repetitionCount, 2)

        card = scheduler.review(card: card, rating: .again)
        XCTAssertEqual(card.repetitionCount, 0)
    }

    func testHardRatingResetsRepetitionCount() {
        var card = scheduler.review(card: testCard, rating: .good)
        card = scheduler.review(card: card, rating: .hard)
        XCTAssertEqual(card.repetitionCount, 0)
    }

    // MARK: - Easiness Factor Tests

    func testEasinessFactorIncreasesWithEasyRatings() {
        let updated = scheduler.review(card: testCard, rating: .easy)
        XCTAssertGreaterThan(updated.easinessFactor, testCard.easinessFactor)
    }

    func testEasinessFactorDecreasesWithAgainRatings() {
        let updated = scheduler.review(card: testCard, rating: .again)
        XCTAssertLessThan(updated.easinessFactor, testCard.easinessFactor)
    }

    func testEasinessFactorNeverBelowMinimum() {
        var card = testCard!
        for _ in 0..<20 {
            card = scheduler.review(card: card, rating: .again)
        }
        XCTAssertGreaterThanOrEqual(card.easinessFactor, 1.3)
    }

    // MARK: - Interval Bounds Tests

    func testIntervalNeverBelowMinimum() {
        let updated = scheduler.review(card: testCard, rating: .again)
        XCTAssertGreaterThanOrEqual(updated.intervalDays, 1.0)
    }

    func testIntervalNeverExceedsMaximum() {
        var card = testCard!
        card.intervalDays = 300
        card.repetitionCount = 10
        let updated = scheduler.review(card: card, rating: .easy)
        XCTAssertLessThanOrEqual(updated.intervalDays, 365.0)
    }

    // MARK: - Statistics Tests

    func testTotalReviewsIncrement() {
        var card = testCard!
        for i in 1...5 {
            card = scheduler.review(card: card, rating: .good)
            XCTAssertEqual(card.totalReviews, i)
        }
    }

    func testAccuracyCalculation() {
        var card = scheduler.review(card: testCard, rating: .good)  // correct
        card = scheduler.review(card: card, rating: .again)         // incorrect
        card = scheduler.review(card: card, rating: .good)          // correct
        // 2 correct out of 3
        XCTAssertEqual(card.accuracy, 2.0 / 3.0, accuracy: 0.01)
    }

    // MARK: - Queue Tests

    func testDueCardsReturnsOverdueCards() {
        var overdueCard = testCard!
        overdueCard.nextReviewDate = Date().addingTimeInterval(-86400)
        let futureCard = Flashcard(
            subjectID: subjectID,
            front: "Future",
            back: "Answer",
            nextReviewDate: Date().addingTimeInterval(86400)
        )

        let due = scheduler.dueCards(from: [overdueCard, futureCard])
        XCTAssertEqual(due.count, 1)
        XCTAssertEqual(due.first?.id, overdueCard.id)
    }

    func testNewCardsReturnsUnreviewedCards() {
        let reviewed = Flashcard(
            subjectID: subjectID,
            front: "Reviewed",
            back: "Answer",
            totalReviews: 5
        )
        let fresh = Flashcard(
            subjectID: subjectID,
            front: "New",
            back: "Answer"
        )

        let newCards = scheduler.newCards(from: [reviewed, fresh])
        XCTAssertEqual(newCards.count, 1)
        XCTAssertEqual(newCards.first?.id, fresh.id)
    }

    func testStudyQueueCombinesReviewAndNew() {
        // A card that has been reviewed before and is now overdue
        let reviewCard = Flashcard(
            subjectID: subjectID,
            front: "Review Me",
            back: "Answer",
            nextReviewDate: Date().addingTimeInterval(-86400),
            totalReviews: 3,
            correctCount: 2
        )

        // A brand new card with a future review date
        let newCard = Flashcard(
            subjectID: subjectID,
            front: "New",
            back: "A",
            nextReviewDate: Date().addingTimeInterval(86400)
        )

        let queue = scheduler.studyQueue(from: [reviewCard, newCard])
        // reviewCard is due for review, newCard is new (never reviewed)
        XCTAssertEqual(queue.count, 2)
    }

    func testStudyQueueRespectsLimits() {
        var cards: [Flashcard] = []
        for i in 0..<50 {
            cards.append(Flashcard(
                subjectID: subjectID,
                front: "Q\(i)",
                back: "A\(i)"
            ))
        }
        let queue = scheduler.studyQueue(from: cards, maxNew: 5, maxReview: 10)
        XCTAssertLessThanOrEqual(queue.count, 15)
    }

    // MARK: - Preview Intervals

    func testPreviewIntervalsReturnsAllRatings() {
        let previews = scheduler.previewIntervals(for: testCard)
        XCTAssertEqual(previews.count, RecallRating.allCases.count)
        for rating in RecallRating.allCases {
            XCTAssertNotNil(previews[rating])
        }
    }
}
