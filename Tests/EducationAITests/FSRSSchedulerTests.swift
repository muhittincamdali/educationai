import Foundation
import Testing
@testable import EducationAI

/// Behavior of the FSRS scheduler. The expected numbers in the first tests are the ones in
/// py-fsrs's own test suite (tests/test_basic.py, version 6.3.2).
struct FSRSSchedulerTests {
    let start = Date(timeIntervalSince1970: 1_669_725_000) // 2022-11-29 12:30 UTC

    func days(_ interval: TimeInterval) -> Int { Int((interval / 86_400).rounded(.down)) }

    @Test func intervalsForAFixedRatingSequenceMatchPyFSRS() throws {
        let scheduler = try FSRSScheduler(fuzzEnabled: false)
        let ratings: [Rating] = [.good, .good, .good, .good, .good, .good, .again, .again, .good, .good, .good, .good, .good]
        var state = ReviewState(due: start)
        var date = start
        var intervals: [Int] = []
        for rating in ratings {
            let outcome = try scheduler.review(state, rating: rating, at: date)
            intervals.append(days(outcome.interval))
            state = outcome.state
            date = state.due
        }
        #expect(intervals == [0, 2, 11, 46, 163, 498, 0, 0, 2, 4, 7, 12, 21])
    }

    @Test func memoryStateMatchesPyFSRS() throws {
        let scheduler = try FSRSScheduler()
        let reviews: [(Rating, Int)] = [(.again, 0), (.good, 0), (.good, 1), (.good, 3), (.good, 8), (.good, 21)]
        var state = ReviewState(due: start)
        var date = start
        for (rating, gap) in reviews {
            date = date.addingTimeInterval(TimeInterval(gap) * 86_400)
            state = try scheduler.review(state, rating: rating, at: date).state
        }
        #expect(abs(try #require(state.stability) - 53.62691) < 1e-4)
        #expect(abs(try #require(state.difficulty) - 6.3574867) < 1e-4)
    }

    @Test func repeatedEasyRatingsReachTheLowestDifficulty() throws {
        let scheduler = try FSRSScheduler(fuzzEnabled: false)
        var state = ReviewState(due: start)
        for offset in 0..<10 {
            state = try scheduler.review(state, rating: .easy, at: start.addingTimeInterval(TimeInterval(offset) / 1_000_000)).state
        }
        #expect(state.difficulty == 1)
    }

    @Test func newItemMovesThroughTheLearningSteps() throws {
        let scheduler = try FSRSScheduler()
        let first = try scheduler.review(ReviewState(due: start), rating: .good, at: start)
        #expect(first.state.phase == .learning)
        #expect(first.state.step == 1)
        #expect(first.interval == 600)

        let second = try scheduler.review(first.state, rating: .good, at: first.state.due)
        #expect(second.state.phase == .review)
        #expect(second.state.step == nil)
        #expect(second.interval >= 86_400)
    }

    @Test(arguments: [
        (Rating.again, ReviewState.Phase.learning, 0, 60.0),
        (.hard, .learning, 0, 330),
        (.good, .learning, 1, 600)
    ])
    func firstReviewOfANewItem(rating: Rating, phase: ReviewState.Phase, step: Int, interval: TimeInterval) throws {
        let outcome = try FSRSScheduler().review(ReviewState(due: start), rating: rating, at: start)
        #expect(outcome.state.phase == phase)
        #expect(outcome.state.step == step)
        #expect(outcome.interval == interval)
    }

    @Test func easyOnANewItemSkipsTheLearningSteps() throws {
        let outcome = try FSRSScheduler().review(ReviewState(due: start), rating: .easy, at: start)
        #expect(outcome.state.phase == .review)
        #expect(outcome.interval >= 86_400)
    }

    @Test func hardOnTheFirstOfASingleStepWaitsOneAndAHalfSteps() throws {
        let scheduler = try FSRSScheduler(learningSteps: [600])
        let outcome = try scheduler.review(ReviewState(due: start), rating: .hard, at: start)
        #expect(outcome.state.phase == .learning)
        #expect(outcome.interval == 900)
    }

    @Test func hardOnALaterStepRepeatsThatStep() throws {
        let scheduler = try FSRSScheduler(learningSteps: [60, 600])
        let first = try scheduler.review(ReviewState(due: start), rating: .good, at: start)
        let second = try scheduler.review(first.state, rating: .hard, at: first.state.due)
        #expect(second.state.step == 1)
        #expect(second.interval == 600)
    }

    @Test func forgettingAReviewItemStartsRelearningAndCountsALapse() throws {
        let scheduler = try FSRSScheduler(relearningSteps: [60, 600], fuzzEnabled: false)
        var state = try scheduler.review(ReviewState(due: start), rating: .easy, at: start).state
        let lapse = try scheduler.review(state, rating: .again, at: state.due)
        #expect(lapse.state.phase == .relearning)
        #expect(lapse.state.step == 0)
        #expect(lapse.state.lapseCount == 1)
        #expect(lapse.interval == 60)

        let hard = try scheduler.review(lapse.state, rating: .hard, at: lapse.state.due)
        #expect(hard.interval == 330)
        state = try scheduler.review(hard.state, rating: .good, at: hard.state.due).state
        #expect(state.step == 1)
        state = try scheduler.review(state, rating: .easy, at: state.due).state
        #expect(state.phase == .review)
        #expect(state.lapseCount == 1)
    }

    @Test func withoutLearningStepsEveryFirstRatingGraduates() throws {
        let scheduler = try FSRSScheduler(learningSteps: [], relearningSteps: [])
        let first = try scheduler.review(ReviewState(due: start), rating: .again, at: start)
        #expect(first.state.phase == .review)
        #expect(first.interval >= 86_400)
        let lapse = try scheduler.review(first.state, rating: .again, at: first.state.due)
        #expect(lapse.state.phase == .review)
        #expect(lapse.interval >= 86_400)
    }

    @Test func intervalsNeverExceedTheMaximum() throws {
        let scheduler = try FSRSScheduler(maximumInterval: 100)
        var state = ReviewState(due: start)
        for rating in [Rating.easy, .good, .easy, .good, .easy, .easy] {
            let outcome = try scheduler.review(state, rating: rating, at: state.due)
            #expect(outcome.interval <= 100 * 86_400)
            state = outcome.state
        }
    }

    @Test func stabilityNeverFallsBelowTheMinimum() throws {
        let scheduler = try FSRSScheduler()
        var state = ReviewState(due: start)
        for _ in 0..<1_000 {
            state = try scheduler.review(state, rating: .again, at: state.due.addingTimeInterval(86_400)).state
            #expect(try #require(state.stability) >= FSRSWeights.minimumStability)
        }
    }

    @Test func sameDayHardReviewKeepsStability() throws {
        let scheduler = try FSRSScheduler(learningSteps: [])
        let first = try scheduler.review(ReviewState(due: start), rating: .good, at: start).state
        let second = try scheduler.review(first, rating: .hard, at: start.addingTimeInterval(60)).state
        #expect(second.stability == first.stability)
    }

    @Test func retrievabilityIsZeroBeforeTheFirstReviewAndFallsWithTime() throws {
        let scheduler = try FSRSScheduler()
        #expect(scheduler.retrievability(of: ReviewState(due: start), at: start) == 0)
        let state = try scheduler.review(ReviewState(due: start), rating: .easy, at: start).state
        let soon = scheduler.retrievability(of: state, at: start.addingTimeInterval(86_400))
        let later = scheduler.retrievability(of: state, at: start.addingTimeInterval(30 * 86_400))
        #expect(soon > later)
        #expect((0...1).contains(later))
        #expect(scheduler.retrievability(of: state, at: start) == 1)
    }

    @Test func retrievabilityAtTheIntervalIsTheDesiredRetention() throws {
        let scheduler = try FSRSScheduler(desiredRetention: 0.85, fuzzEnabled: false)
        var state = ReviewState(due: start)
        for _ in 0..<4 { state = try scheduler.review(state, rating: .good, at: state.due).state }
        let lastReview = try #require(state.lastReview)
        let stability = try #require(state.stability)
        let atDue = scheduler.retrievability(of: state, at: state.due)
        // The interval is rounded to whole days, so the probability is close to, not exactly, 0.85.
        #expect(abs(atDue - 0.85) < 0.01)
        #expect(state.due.timeIntervalSince(lastReview) > stability * 86_400 * 0.5)
    }

    @Test func fuzzStaysInsideItsRangeAndIsReproducible() throws {
        let fuzzed = try FSRSScheduler()
        let plain = try FSRSScheduler(fuzzEnabled: false)
        var state = ReviewState(due: start)
        for _ in 0..<3 { state = try plain.review(state, rating: .good, at: state.due).state }
        let base = days(try plain.review(state, rating: .good, at: state.due).interval)
        #expect(base == 46)

        var seen = Set<Int>()
        for seed in 0..<200 as Range<UInt64> {
            var first = SeededRandomNumberGenerator(seed: seed)
            var second = SeededRandomNumberGenerator(seed: seed)
            let a = days(try fuzzed.review(state, rating: .good, at: state.due, using: &first).interval)
            let b = days(try fuzzed.review(state, rating: .good, at: state.due, using: &second).interval)
            #expect(a == b)
            // py-fsrs for 46 days: delta = 1 + 0.15 * 4.5 + 0.1 * 13 + 0.05 * 26 = 4.275, bounds
            // round(41.725) = 42 and round(50.275) = 50, and a draw in [42, 51) rounded to a day,
            // so 51 is possible too.
            #expect((42...51).contains(a), "\(a)")
            seen.insert(a)
        }
        #expect(seen.count > 5)
    }

    @Test func shortIntervalsAreNotFuzzed() throws {
        let scheduler = try FSRSScheduler()
        var generator = SeededRandomNumberGenerator(seed: 7)
        #expect(scheduler.fuzzedIntervalDays(1, using: &generator) == 1)
        #expect(scheduler.fuzzedIntervalDays(2, using: &generator) == 2)
    }

    @Test func previewMatchesTheReviewOfEachRating() throws {
        let scheduler = try FSRSScheduler(fuzzEnabled: false)
        let state = try scheduler.review(ReviewState(due: start), rating: .easy, at: start).state
        let preview = try scheduler.preview(state, at: state.due)
        for rating in Rating.allCases {
            #expect(preview[rating] == (try scheduler.review(state, rating: rating, at: state.due)))
        }
        #expect(preview.again.interval < preview.hard.interval)
        #expect(preview.hard.interval < preview.good.interval)
        #expect(preview.good.interval < preview.easy.interval)
    }

    @Test func replayGivesTheSameStateAsReviewingInOrder() throws {
        let scheduler = try FSRSScheduler(fuzzEnabled: false)
        var state = ReviewState(due: start)
        var logs: [ReviewLog] = []
        for rating in [Rating.good, .good, .again, .good, .easy, .hard] {
            let outcome = try scheduler.review(state, rating: rating, at: state.due, duration: 4.5)
            logs.append(outcome.log)
            state = outcome.state
        }
        #expect(try scheduler.replay(logs.shuffled()) == state)
        #expect(logs.allSatisfy { $0.duration == 4.5 })
        #expect(logs.map(\.phase) == [.learning, .learning, .review, .relearning, .review, .review])
    }

    @Test func replayingWithAnotherRetentionChangesTheSchedule() throws {
        let original = try FSRSScheduler(fuzzEnabled: false)
        var state = ReviewState(due: start)
        var logs: [ReviewLog] = []
        for _ in 0..<5 {
            let outcome = try original.review(state, rating: .good, at: state.due)
            logs.append(outcome.log)
            state = outcome.state
        }
        let stricter = try FSRSScheduler(desiredRetention: 0.95, fuzzEnabled: false)
        let replayed = try stricter.replay(logs)
        #expect(replayed.lastReview == state.lastReview)
        #expect(replayed.due < state.due)
    }

    @Test func reviewCountsEveryReview() throws {
        let scheduler = try FSRSScheduler()
        var state = ReviewState(due: start)
        #expect(state.isNew)
        for _ in 0..<5 { state = try scheduler.review(state, rating: .good, at: state.due).state }
        #expect(state.reviewCount == 5)
        #expect(!state.isNew)
        #expect(state.isDue(at: state.due))
        #expect(!state.isDue(at: state.due.addingTimeInterval(-1)))
    }

    @Test func schedulerAndStatesRoundTripThroughJSON() throws {
        let scheduler = try FSRSScheduler(desiredRetention: 0.87, learningSteps: [30, 300], maximumInterval: 400)
        let decoded = try JSONDecoder().decode(FSRSScheduler.self, from: JSONEncoder().encode(scheduler))
        #expect(decoded == scheduler)

        let state = try scheduler.review(ReviewState(due: start), rating: .good, at: start).state
        #expect(try JSONDecoder().decode(ReviewState.self, from: JSONEncoder().encode(state)) == state)
    }
}
