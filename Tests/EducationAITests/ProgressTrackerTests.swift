import XCTest
@testable import EducationAI

final class ProgressTrackerTests: XCTestCase {

    var tracker: ProgressTracker!
    var storage: LocalStorage!
    let subjectID = UUID()
    let cardID = UUID()

    override func setUp() {
        super.setUp()
        storage = LocalStorage(suiteName: "com.educationai.test.progress")
        storage.removeAll()
        tracker = ProgressTracker(storage: storage)
    }

    override func tearDown() {
        storage.removeAll()
        super.tearDown()
    }

    // MARK: - Initial State

    func testInitialProgressIsEmpty() {
        let progress = tracker.progress
        XCTAssertTrue(progress.subjects.isEmpty)
        XCTAssertTrue(progress.recentEvents.isEmpty)
        XCTAssertEqual(progress.totalReviews, 0)
        XCTAssertEqual(progress.totalStudyTime, 0)
    }

    // MARK: - Recording Events

    func testRecordEventIncrementsReviewCount() {
        let event = StudyEvent(cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0)
        tracker.record(event: event)
        XCTAssertEqual(tracker.progress.totalReviews, 1)
    }

    func testRecordEventTracksStudyTime() {
        let event = StudyEvent(cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 5.0)
        tracker.record(event: event)
        XCTAssertEqual(tracker.progress.totalStudyTime, 5.0)
    }

    func testRecordEventAddsToRecentEvents() {
        let event = StudyEvent(cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0)
        tracker.record(event: event)
        XCTAssertEqual(tracker.progress.recentEvents.count, 1)
        XCTAssertEqual(tracker.progress.recentEvents.first?.cardID, cardID)
    }

    func testRecentEventsAreNewestFirst() {
        let event1 = StudyEvent(cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0)
        let card2 = UUID()
        let event2 = StudyEvent(cardID: card2, subjectID: subjectID, rating: .easy, responseTime: 2.0)
        tracker.record(event: event1)
        tracker.record(event: event2)
        XCTAssertEqual(tracker.progress.recentEvents.first?.cardID, card2)
    }

    func testRecentEventsMaxSize() {
        for i in 0..<600 {
            tracker.record(event: StudyEvent(
                cardID: UUID(), subjectID: subjectID, rating: .good, responseTime: Double(i)
            ))
        }
        XCTAssertLessThanOrEqual(tracker.progress.recentEvents.count, 500)
    }

    // MARK: - Subject Progress

    func testSubjectProgressCreatedOnFirstEvent() {
        tracker.record(event: StudyEvent(
            cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0
        ))
        let sp = tracker.subjectProgress(for: subjectID)
        XCTAssertNotNil(sp)
        XCTAssertEqual(sp?.subjectID, subjectID)
    }

    func testSubjectProgressTracksReviews() {
        tracker.record(event: StudyEvent(
            cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0
        ))
        tracker.record(event: StudyEvent(
            cardID: UUID(), subjectID: subjectID, rating: .easy, responseTime: 2.0
        ))
        let sp = tracker.subjectProgress(for: subjectID)
        XCTAssertEqual(sp?.reviewedCards, 2)
    }

    func testSubjectProgressTracksAccuracy() {
        // 2 correct, 1 wrong
        tracker.record(event: StudyEvent(cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0))
        tracker.record(event: StudyEvent(cardID: UUID(), subjectID: subjectID, rating: .easy, responseTime: 2.0))
        tracker.record(event: StudyEvent(cardID: UUID(), subjectID: subjectID, rating: .again, responseTime: 5.0))

        let sp = tracker.subjectProgress(for: subjectID)
        XCTAssertEqual(sp?.accuracy ?? 0, 2.0 / 3.0, accuracy: 0.01)
    }

    func testSubjectProgressTracksStudyTime() {
        tracker.record(event: StudyEvent(cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0))
        tracker.record(event: StudyEvent(cardID: UUID(), subjectID: subjectID, rating: .good, responseTime: 7.0))
        let sp = tracker.subjectProgress(for: subjectID)
        XCTAssertEqual(sp?.studyTime, 10.0)
    }

    func testSubjectProgressUpdatesLastStudied() {
        let event = StudyEvent(cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0)
        tracker.record(event: event)
        let sp = tracker.subjectProgress(for: subjectID)
        XCTAssertNotNil(sp?.lastStudied)
    }

    // MARK: - Multiple Subjects

    func testMultipleSubjectsTrackedIndependently() {
        let subject2 = UUID()
        tracker.record(event: StudyEvent(cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0))
        tracker.record(event: StudyEvent(cardID: UUID(), subjectID: subject2, rating: .again, responseTime: 5.0))

        let sp1 = tracker.subjectProgress(for: subjectID)
        let sp2 = tracker.subjectProgress(for: subject2)

        XCTAssertNotNil(sp1)
        XCTAssertNotNil(sp2)
        XCTAssertNotEqual(sp1?.accuracy, sp2?.accuracy)
    }

    // MARK: - Mastery

    func testUpdateMastery() {
        tracker.updateMastery(subjectID: subjectID, totalCards: 100, masteredCards: 75)
        let sp = tracker.subjectProgress(for: subjectID)
        XCTAssertEqual(sp?.totalCards, 100)
        XCTAssertEqual(sp?.masteredCards, 75)
        XCTAssertEqual(sp?.masteryScore ?? 0, 0.75, accuracy: 0.01)
    }

    // MARK: - Global Metrics

    func testOverallAccuracy() {
        tracker.record(event: StudyEvent(cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0))
        tracker.record(event: StudyEvent(cardID: UUID(), subjectID: subjectID, rating: .again, responseTime: 5.0))
        XCTAssertEqual(tracker.progress.overallAccuracy, 0.5, accuracy: 0.01)
    }

    func testGlobalMastery() {
        tracker.updateMastery(subjectID: subjectID, totalCards: 10, masteredCards: 8)
        let subject2 = UUID()
        tracker.updateMastery(subjectID: subject2, totalCards: 10, masteredCards: 6)
        XCTAssertEqual(tracker.progress.globalMastery, 0.7, accuracy: 0.01)
    }

    // MARK: - Date Queries

    func testTodayEvents() {
        tracker.record(event: StudyEvent(cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0))
        let today = tracker.todayEvents()
        XCTAssertEqual(today.count, 1)
    }

    func testStudyDays() {
        tracker.record(event: StudyEvent(cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0))
        let days = tracker.studyDays(inLast: 7)
        XCTAssertEqual(days, 1)
    }

    // MARK: - Persistence

    func testProgressPersistsAcrossInstances() {
        tracker.record(event: StudyEvent(cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0))
        let newTracker = ProgressTracker(storage: storage)
        XCTAssertEqual(newTracker.progress.totalReviews, 1)
    }

    // MARK: - Reset

    func testResetClearsProgress() {
        tracker.record(event: StudyEvent(cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 3.0))
        tracker.reset()
        XCTAssertEqual(tracker.progress.totalReviews, 0)
        XCTAssertTrue(tracker.progress.subjects.isEmpty)
    }
}
