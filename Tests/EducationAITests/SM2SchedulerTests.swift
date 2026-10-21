import Foundation
import Testing
@testable import EducationAI

struct SM2SchedulerTests {
    let start = Date(timeIntervalSince1970: 1_700_000_000)

    @Test func perfectAnswersFollowTheSM2Sequence() throws {
        let scheduler = try SM2Scheduler()
        var state = SM2State(due: start)
        var intervals: [Int] = []
        var factors: [Double] = []
        for _ in 0..<4 {
            state = try scheduler.review(state, quality: 5, at: state.due)
            intervals.append(state.interval)
            factors.append(state.easeFactor)
        }
        // 1 day, 6 days, then round(previous × factor before this review): 6 × 2.7 = 16.2, 16 × 2.8 = 44.8.
        #expect(intervals == [1, 6, 16, 45])
        #expect(zip(factors, [2.6, 2.7, 2.8, 2.9]).allSatisfy { abs($0 - $1) < 1e-12 })
        #expect(state.repetitions == 4)
        #expect(state.due == state.lastReview!.addingTimeInterval(45 * 86_400))
    }

    @Test(arguments: [(5, 0.1), (4, 0.0), (3, -0.14), (2, -0.32), (1, -0.54), (0, -0.8)])
    func easeFactorChangesByQuality(quality: Int, change: Double) throws {
        let state = SM2State(easeFactor: 2.5, repetitions: 3, interval: 10, due: start, lastReview: start.addingTimeInterval(-10 * 86_400))
        let next = try SM2Scheduler().review(state, quality: quality, at: start)
        #expect(abs(next.easeFactor - (2.5 + change)) < 1e-12)
    }

    @Test(arguments: [0, 1, 2])
    func aFailedRecallRestartsAtOneDay(quality: Int) throws {
        let state = SM2State(easeFactor: 2.5, repetitions: 5, interval: 120, due: start, lastReview: start.addingTimeInterval(-120 * 86_400))
        let next = try SM2Scheduler().review(state, quality: quality, at: start)
        #expect(next.repetitions == 0)
        #expect(next.interval == 1)
    }

    @Test func hardIsAPassNotALapse() throws {
        let state = SM2State(easeFactor: 2.5, repetitions: 2, interval: 6, due: start, lastReview: start.addingTimeInterval(-6 * 86_400))
        let next = try SM2Scheduler().review(state, rating: .hard, at: start)
        #expect(next.repetitions == 3)
        #expect(next.interval == 15)
        #expect(SM2Scheduler.quality(for: .again) == 1)
        #expect(SM2Scheduler.quality(for: .easy) == 5)
    }

    @Test func easeFactorNeverFallsBelowTheMinimum() throws {
        let scheduler = try SM2Scheduler()
        var state = SM2State(due: start)
        for _ in 0..<20 { state = try scheduler.review(state, quality: 0, at: state.due) }
        #expect(state.easeFactor == SM2Scheduler.minimumEaseFactor)
    }

    @Test func intervalStopsAtTheMaximum() throws {
        let scheduler = try SM2Scheduler(maximumInterval: 90)
        var state = SM2State(due: start)
        for _ in 0..<12 { state = try scheduler.review(state, quality: 5, at: state.due) }
        #expect(state.interval == 90)
    }

    @Test func aHugeStoredIntervalIsClampedWithoutTrapping() throws {
        let state = SM2State(easeFactor: 3, repetitions: .max, interval: .max, due: start, lastReview: start)
        let next = try SM2Scheduler().review(state, quality: 5, at: start)
        #expect(next.interval == 36_500)
        #expect(next.repetitions == .max)
    }

    @Test(arguments: [-1, 6, Int.min, Int.max])
    func rejectsQualityOutsideZeroToFive(quality: Int) throws {
        #expect(throws: SchedulingError.self) { try SM2Scheduler().review(SM2State(due: start), quality: quality, at: start) }
    }

    @Test(arguments: [
        SM2State(easeFactor: .nan, repetitions: 0, interval: 0, due: Date(timeIntervalSince1970: 0), lastReview: nil),
        SM2State(easeFactor: 1.0, repetitions: 0, interval: 0, due: Date(timeIntervalSince1970: 0), lastReview: nil),
        SM2State(easeFactor: 2.5, repetitions: -1, interval: 0, due: Date(timeIntervalSince1970: 0), lastReview: nil),
        SM2State(easeFactor: 2.5, repetitions: 0, interval: -4, due: Date(timeIntervalSince1970: 0), lastReview: nil),
        SM2State(easeFactor: 2.5, repetitions: 0, interval: 0, due: Date(timeIntervalSinceReferenceDate: .nan), lastReview: nil)
    ])
    func rejectsStatesNoReviewCouldProduce(state: SM2State) throws {
        #expect(throws: SchedulingError.self) { try SM2Scheduler().review(state, quality: 4, at: start) }
    }

    @Test func rejectsANonFiniteDateAndAnInvalidMaximum() {
        #expect(throws: SchedulingError.invalidDate) {
            try SM2Scheduler().review(SM2State(due: start), quality: 4, at: Date(timeIntervalSinceReferenceDate: .nan))
        }
        #expect(throws: SchedulingError.self) { try SM2Scheduler(maximumInterval: 0) }
        #expect(throws: SchedulingError.self) {
            try JSONDecoder().decode(SM2Scheduler.self, from: Data(#"{"maximumInterval":99999}"#.utf8))
        }
    }

    // MARK: Migration to FSRS

    @Test(arguments: [(2.5, 10), (1.3, 3), (2.8, 120), (2.0, 1), (3.5, 365)])
    func migratedStateRemembersAtTheSM2RetentionAfterTheSM2Interval(easeFactor: Double, interval: Int) throws {
        let scheduler = try FSRSScheduler(fuzzEnabled: false)
        let lastReview = start.addingTimeInterval(-Double(interval) * 86_400)
        let sm2 = SM2State(easeFactor: easeFactor, repetitions: 4, interval: interval, due: start, lastReview: lastReview)
        let state = try ReviewState(migrating: sm2, scheduler: scheduler, sm2Retention: 0.9)
        #expect(state.phase == .review)
        #expect(state.due == start)
        #expect(state.lastReview == lastReview)
        #expect(abs(scheduler.retrievability(of: state, at: start) - 0.9) < 1e-9)
    }

    @Test func migratedDifficultyMakesTheNextGoodReviewGrowStabilityByTheEaseFactor() throws {
        let scheduler = try FSRSScheduler(fuzzEnabled: false)
        let sm2 = SM2State(easeFactor: 2.3, repetitions: 5, interval: 30, due: start, lastReview: start.addingTimeInterval(-30 * 86_400))
        let state = try ReviewState(migrating: sm2, scheduler: scheduler, sm2Retention: 0.9)
        let next = try scheduler.review(state, rating: .good, at: start).state
        let growth = try #require(next.stability) / (try #require(state.stability))
        #expect(abs(growth - 2.3) < 1e-9)
    }

    @Test func anUnreviewedSM2ItemBecomesANewItem() throws {
        let state = try ReviewState(migrating: SM2State(due: start), scheduler: FSRSScheduler())
        #expect(state == ReviewState(due: start))
    }

    @Test func migrationWithoutALastReviewDateInfersItFromTheInterval() throws {
        let sm2 = SM2State(easeFactor: 2.5, repetitions: 3, interval: 12, due: start, lastReview: nil)
        let state = try ReviewState(migrating: sm2, scheduler: FSRSScheduler())
        #expect(state.lastReview == start.addingTimeInterval(-12 * 86_400))
    }

    @Test(arguments: [0.0, 1.0, .nan, -0.5])
    func migrationRejectsRetentionOutsideZeroToOne(retention: Double) throws {
        let sm2 = SM2State(easeFactor: 2.5, repetitions: 3, interval: 12, due: start, lastReview: start)
        #expect(throws: SchedulingError.self) { try ReviewState(migrating: sm2, scheduler: FSRSScheduler(), sm2Retention: retention) }
    }

    @Test func migratingExtremeValuesGivesAValidState() throws {
        let scheduler = try FSRSScheduler()
        let sm2 = SM2State(easeFactor: 1e300, repetitions: .max, interval: .max, due: start, lastReview: nil)
        let state = try ReviewState(migrating: sm2, scheduler: scheduler)
        _ = try scheduler.review(state, rating: .good, at: start)
        #expect(state.difficulty.map(FSRSWeights.difficultyRange.contains) == true)
    }

    // Near the largest Double the difficulty formula overflows to minus infinity. SM-2 reviews such
    // a state, so migrating it must work too, as the easiest difficulty.
    @Test(arguments: [1e307, .greatestFiniteMagnitude])
    func everyEaseFactorSM2AcceptsCanBeMigrated(easeFactor: Double) throws {
        let scheduler = try FSRSScheduler()
        let sm2 = SM2State(easeFactor: easeFactor, repetitions: 9, interval: .max, due: start, lastReview: start)
        _ = try SM2Scheduler().review(sm2, quality: 4, at: start)
        let state = try ReviewState(migrating: sm2, scheduler: scheduler)
        #expect(state.difficulty == FSRSWeights.difficultyRange.lowerBound)
        #expect(try scheduler.review(state, rating: .good, at: start).state.phase == .review)
    }
}
