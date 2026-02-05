import XCTest
@testable import EducationAI

final class RecommendationTests: XCTestCase {

    var engine: RecommendationEngine!
    let subjectID = UUID()

    override func setUp() {
        super.setUp()
        engine = RecommendationEngine()
    }

    // MARK: - Empty State

    func testNoRecommendationsForEmptyCards() {
        let recs = engine.recommend(cards: [], progress: LearningProgress())
        XCTAssertTrue(recs.isEmpty)
    }

    // MARK: - Overdue Reviews

    func testOverdueCardsGenerateRecommendation() {
        let overdueCards = (0..<5).map { i -> Flashcard in
            Flashcard(
                subjectID: subjectID,
                front: "Q\(i)",
                back: "A\(i)",
                nextReviewDate: Date().addingTimeInterval(-86400), // 1 day overdue
                totalReviews: 3,
                correctCount: 2
            )
        }
        let recs = engine.recommend(cards: overdueCards, progress: LearningProgress())
        let overdueRec = recs.first { $0.type == .overdueReview }
        XCTAssertNotNil(overdueRec)
        XCTAssertEqual(overdueRec?.priority, .critical)
    }

    // MARK: - New Content

    func testNewCardsGenerateRecommendation() {
        let newCards = (0..<10).map { i in
            Flashcard(subjectID: subjectID, front: "Q\(i)", back: "A\(i)")
        }
        let recs = engine.recommend(cards: newCards, progress: LearningProgress())
        let newRec = recs.first { $0.type == .newContent }
        XCTAssertNotNil(newRec)
        XCTAssertEqual(newRec?.priority, .medium)
    }

    // MARK: - Weak Areas

    func testWeakAreaGeneratesRecommendation() {
        var progress = LearningProgress()
        progress.subjects[subjectID] = SubjectProgress(
            subjectID: subjectID,
            totalCards: 50,
            reviewedCards: 30,
            accuracy: 0.4, // Below 60% threshold
            studyTime: 3600,
            lastStudied: Date()
        )

        let cards = (0..<10).map { i in
            Flashcard(
                subjectID: subjectID,
                front: "Q\(i)",
                back: "A\(i)",
                totalReviews: 5,
                correctCount: 2
            )
        }

        let recs = engine.recommend(cards: cards, progress: progress)
        let weakRec = recs.first { $0.type == .weakArea }
        XCTAssertNotNil(weakRec)
        XCTAssertEqual(weakRec?.priority, .high)
    }

    // MARK: - Lapsed Cards

    func testLapsedCardsGenerateRecommendation() {
        let lapsedCards = (0..<5).map { i -> Flashcard in
            Flashcard(
                subjectID: subjectID,
                front: "Q\(i)",
                back: "A\(i)",
                repetitionCount: 0,
                nextReviewDate: Date().addingTimeInterval(-86400),
                totalReviews: 5,
                correctCount: 3
            )
        }
        let recs = engine.recommend(cards: lapsedCards, progress: LearningProgress())
        let lapsedRec = recs.first { $0.type == .lapsedReview }
        XCTAssertNotNil(lapsedRec)
    }

    // MARK: - Priority Ordering

    func testRecommendationsSortedByPriority() {
        var progress = LearningProgress()
        progress.subjects[subjectID] = SubjectProgress(
            subjectID: subjectID,
            totalCards: 50,
            reviewedCards: 30,
            accuracy: 0.4,
            studyTime: 3600,
            lastStudied: Date()
        )

        var cards: [Flashcard] = []

        // Overdue cards
        cards += (0..<3).map { i -> Flashcard in
            Flashcard(
                subjectID: subjectID, front: "Overdue\(i)", back: "A\(i)",
                nextReviewDate: Date().addingTimeInterval(-86400),
                totalReviews: 3, correctCount: 2
            )
        }

        // New cards
        cards += (0..<5).map { i in
            Flashcard(subjectID: subjectID, front: "New\(i)", back: "A\(i)")
        }

        let recs = engine.recommend(cards: cards, progress: progress)
        guard recs.count >= 2 else { return }
        // First recommendation should be highest priority
        XCTAssertLessThanOrEqual(recs[0].priority, recs[1].priority)
    }

    // MARK: - Limit

    func testRecommendationsRespectLimit() {
        let cards = (0..<50).map { i in
            Flashcard(subjectID: subjectID, front: "Q\(i)", back: "A\(i)")
        }
        let recs = engine.recommend(cards: cards, progress: LearningProgress(), limit: 3)
        XCTAssertLessThanOrEqual(recs.count, 3)
    }

    // MARK: - Estimated Time

    func testRecommendationsHaveEstimatedTime() {
        let cards = (0..<10).map { i in
            Flashcard(subjectID: subjectID, front: "Q\(i)", back: "A\(i)")
        }
        let recs = engine.recommend(cards: cards, progress: LearningProgress())
        for rec in recs {
            XCTAssertGreaterThan(rec.estimatedMinutes, 0)
        }
    }

    // MARK: - Recommendation Properties

    func testRecommendationHasUniqueID() {
        let cards = (0..<10).map { i in
            Flashcard(subjectID: subjectID, front: "Q\(i)", back: "A\(i)")
        }
        let recs = engine.recommend(cards: cards, progress: LearningProgress())
        let ids = recs.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count) // All unique
    }
}
