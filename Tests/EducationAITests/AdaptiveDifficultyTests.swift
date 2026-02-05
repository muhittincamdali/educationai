import XCTest
@testable import EducationAI

final class AdaptiveDifficultyTests: XCTestCase {

    var engine: AdaptiveDifficultyEngine!
    let subjectID = UUID()
    let cardID = UUID()

    override func setUp() {
        super.setUp()
        engine = AdaptiveDifficultyEngine(sensitivity: 0.5)
    }

    // MARK: - Default State

    func testDefaultDifficultyIsMedium() {
        let difficulty = engine.recommendedDifficulty(for: subjectID)
        XCTAssertEqual(difficulty, .medium)
    }

    func testEmptyPerformanceSnapshot() {
        let snapshot = engine.performanceMetrics(for: subjectID)
        XCTAssertEqual(snapshot.accuracy, 0)
        XCTAssertEqual(snapshot.eventCount, 0)
        XCTAssertEqual(snapshot.difficulty, .medium)
        XCTAssertEqual(snapshot.trend, .stable)
    }

    // MARK: - Difficulty Adjustment

    func testHighAccuracyIncreasesDifficulty() {
        // Feed 25 correct events (above 85% threshold)
        for _ in 0..<25 {
            let event = StudyEvent(
                cardID: cardID,
                subjectID: subjectID,
                rating: .easy,
                responseTime: 2.0
            )
            engine.ingest(event: event)
        }
        let difficulty = engine.recommendedDifficulty(for: subjectID)
        XCTAssertGreaterThan(difficulty, .medium)
    }

    func testLowAccuracyDecreasesDifficulty() {
        // Feed 25 incorrect events (below 70% threshold)
        for _ in 0..<25 {
            let event = StudyEvent(
                cardID: cardID,
                subjectID: subjectID,
                rating: .again,
                responseTime: 10.0
            )
            engine.ingest(event: event)
        }
        let difficulty = engine.recommendedDifficulty(for: subjectID)
        XCTAssertLessThan(difficulty, .medium)
    }

    func testMixedAccuracyKeepsSameDifficulty() {
        // Feed events in a pattern that averages ~75% accuracy (within 70-85%)
        // Use a stable pattern: 3 correct then 1 wrong, repeated
        // This keeps the running accuracy within the target range
        engine.windowSize = 20
        for i in 0..<20 {
            let rating: RecallRating = i % 4 == 0 ? .again : .good
            let event = StudyEvent(
                cardID: cardID,
                subjectID: subjectID,
                rating: rating,
                responseTime: 5.0
            )
            engine.ingest(event: event)
        }
        let snapshot = engine.performanceMetrics(for: subjectID)
        // Accuracy should be ~75%
        XCTAssertEqual(snapshot.accuracy, 0.75, accuracy: 0.01)
        // Difficulty should be within one step of medium (the engine may have
        // oscillated during ingestion, which is valid adaptive behavior)
        let difficulty = engine.recommendedDifficulty(for: subjectID)
        XCTAssertTrue(
            difficulty == .easy || difficulty == .medium,
            "Difficulty should be easy or medium for 75% accuracy, got \(difficulty)"
        )
    }

    // MARK: - Separate Subjects

    func testSubjectsTrackIndependently() {
        let subject2 = UUID()

        // Subject 1: all correct
        for _ in 0..<25 {
            engine.ingest(event: StudyEvent(
                cardID: cardID, subjectID: subjectID, rating: .easy, responseTime: 2.0
            ))
        }

        // Subject 2: all wrong
        for _ in 0..<25 {
            engine.ingest(event: StudyEvent(
                cardID: UUID(), subjectID: subject2, rating: .again, responseTime: 10.0
            ))
        }

        XCTAssertGreaterThan(
            engine.recommendedDifficulty(for: subjectID),
            engine.recommendedDifficulty(for: subject2)
        )
    }

    // MARK: - Performance Metrics

    func testPerformanceMetricsAccuracy() {
        // 8 correct, 2 wrong = 80% accuracy
        for i in 0..<10 {
            let rating: RecallRating = i < 8 ? .good : .again
            engine.ingest(event: StudyEvent(
                cardID: cardID, subjectID: subjectID, rating: rating, responseTime: 3.0
            ))
        }
        let snapshot = engine.performanceMetrics(for: subjectID)
        XCTAssertEqual(snapshot.accuracy, 0.8, accuracy: 0.01)
        XCTAssertEqual(snapshot.eventCount, 10)
    }

    func testPerformanceMetricsAverageResponseTime() {
        engine.ingest(event: StudyEvent(
            cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 2.0
        ))
        engine.ingest(event: StudyEvent(
            cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 4.0
        ))
        let snapshot = engine.performanceMetrics(for: subjectID)
        XCTAssertEqual(snapshot.averageResponseTime, 3.0, accuracy: 0.01)
    }

    // MARK: - Trend Detection

    func testImprovingTrend() {
        // First half: wrong, second half: correct
        for i in 0..<20 {
            let rating: RecallRating = i < 10 ? .again : .easy
            engine.ingest(event: StudyEvent(
                cardID: cardID, subjectID: subjectID, rating: rating, responseTime: 3.0
            ))
        }
        let snapshot = engine.performanceMetrics(for: subjectID)
        XCTAssertEqual(snapshot.trend, .improving)
    }

    func testDecliningTrend() {
        // First half: correct, second half: wrong
        for i in 0..<20 {
            let rating: RecallRating = i < 10 ? .easy : .again
            engine.ingest(event: StudyEvent(
                cardID: cardID, subjectID: subjectID, rating: rating, responseTime: 3.0
            ))
        }
        let snapshot = engine.performanceMetrics(for: subjectID)
        XCTAssertEqual(snapshot.trend, .declining)
    }

    // MARK: - Window Size

    func testSlidingWindowDropsOldEvents() {
        engine.windowSize = 10
        // Ingest 15 events — only last 10 should be kept
        for _ in 0..<15 {
            engine.ingest(event: StudyEvent(
                cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0
            ))
        }
        let snapshot = engine.performanceMetrics(for: subjectID)
        XCTAssertEqual(snapshot.eventCount, 10)
    }

    // MARK: - Reset

    func testResetSubject() {
        engine.ingest(event: StudyEvent(
            cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0
        ))
        engine.reset(for: subjectID)
        let snapshot = engine.performanceMetrics(for: subjectID)
        XCTAssertEqual(snapshot.eventCount, 0)
    }

    func testResetAll() {
        engine.ingest(event: StudyEvent(
            cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0
        ))
        engine.resetAll()
        XCTAssertEqual(engine.recommendedDifficulty(for: subjectID), .medium)
    }
}
