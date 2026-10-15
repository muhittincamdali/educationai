import Foundation
import Testing
@testable import EducationAI

/// Settings and stored states that are out of range, NaN or at the limits of their types must be
/// rejected with an error or handled, never crash or loop.
struct FSRSValidationTests {
    let start = Date(timeIntervalSince1970: 1_669_725_000)

    func isInvalidConfiguration(_ error: any Error) -> Bool {
        if case SchedulingError.invalidConfiguration = error { return true }
        return false
    }

    func isInvalidState(_ error: any Error) -> Bool {
        if case SchedulingError.invalidState = error { return true }
        return false
    }

    // MARK: Configuration

    @Test(arguments: [0, 1, 20, 22])
    func rejectsAWrongNumberOfWeights(count: Int) {
        #expect(throws: SchedulingError.self) { try FSRSScheduler(weights: Array(repeating: 1, count: count)) }
    }

    @Test(arguments: [Double.nan, .infinity, -.infinity, -1, 101])
    func rejectsAnInitialStabilityWeightOutOfBounds(value: Double) {
        var weights = FSRSWeights.defaults
        weights[0] = value
        #expect(performing: { try FSRSScheduler(weights: weights) }, throws: isInvalidConfiguration)
    }

    @Test func namesEveryWeightOutOfBounds() {
        var weights = FSRSWeights.defaults
        weights[7] = 0.9
        weights[20] = .nan
        do {
            _ = try FSRSScheduler(weights: weights)
            Issue.record("expected an error")
        } catch {
            let message = String(describing: error)
            #expect(message.contains("w[7]"))
            #expect(message.contains("w[20]"))
        }
    }

    @Test func acceptsNineteenFSRS5WeightsAndAddsTheFSRS5Decay() throws {
        let fsrs5 = Array(FSRSWeights.defaults.prefix(19))
        let scheduler = try FSRSScheduler(weights: fsrs5)
        #expect(scheduler.weights.count == 21)
        #expect(scheduler.weights[19] == 0)
        #expect(scheduler.weights[20] == 0.5)
    }

    @Test(arguments: [0, 1, -0.1, 1.5, Double.nan, .infinity])
    func rejectsDesiredRetentionOutsideZeroToOne(value: Double) {
        #expect(performing: { try FSRSScheduler(desiredRetention: value) }, throws: isInvalidConfiguration)
    }

    @Test(arguments: [1e-300, 0.000_001, 0.999_999_999])
    func extremeButValidRetentionGivesIntervalsInRange(value: Double) throws {
        let scheduler = try FSRSScheduler(desiredRetention: value, fuzzEnabled: false)
        let outcome = try scheduler.review(ReviewState(due: start), rating: .easy, at: start)
        #expect((86_400...36_500 * 86_400).contains(outcome.interval))
    }

    @Test(arguments: [[0.0], [-60], [Double.nan], [.infinity], [60, 36_500 * 86_400 + 1]])
    func rejectsStepsThatAreNotPositiveAndFinite(steps: [Double]) {
        #expect(performing: { try FSRSScheduler(learningSteps: steps) }, throws: isInvalidConfiguration)
        #expect(performing: { try FSRSScheduler(relearningSteps: steps) }, throws: isInvalidConfiguration)
    }

    @Test(arguments: [0, -1, 36_501, Int.max, Int.min])
    func rejectsMaximumIntervalOutOfRange(value: Int) {
        #expect(performing: { try FSRSScheduler(maximumInterval: value) }, throws: isInvalidConfiguration)
    }

    @Test func decodingChecksTheSettings() throws {
        let json = #"{"weights":[1],"desiredRetention":0.9,"learningSteps":[60],"relearningSteps":[],"maximumInterval":10,"fuzzEnabled":true}"#
        #expect(throws: SchedulingError.self) { try JSONDecoder().decode(FSRSScheduler.self, from: Data(json.utf8)) }
        let retention = String(decoding: try JSONEncoder().encode(try FSRSScheduler()), as: UTF8.self)
            .replacingOccurrences(of: #""desiredRetention":0.9"#, with: #""desiredRetention":7"#)
        #expect(throws: SchedulingError.self) { try JSONDecoder().decode(FSRSScheduler.self, from: Data(retention.utf8)) }
    }

    // MARK: Stored states

    static let invalidStates: [ReviewState] = {
        let date = Date(timeIntervalSince1970: 1_669_725_000)
        func state(
            phase: ReviewState.Phase = .review, step: Int? = nil, stability: Double? = 5, difficulty: Double? = 5,
            due: Date = date, lastReview: Date? = date, reviews: Int = 1, lapses: Int = 0
        ) -> ReviewState {
            ReviewState(phase: phase, step: step, stability: stability, difficulty: difficulty,
                        due: due, lastReview: lastReview, reviewCount: reviews, lapseCount: lapses)
        }
        return [
            state(stability: .nan), state(stability: .infinity), state(stability: 0), state(stability: -3),
            state(difficulty: .nan), state(difficulty: 0.5), state(difficulty: 11),
            state(stability: nil), state(difficulty: nil), state(stability: nil, difficulty: nil),
            state(phase: .learning, step: nil), state(phase: .relearning, step: -1), state(step: 0),
            state(due: Date(timeIntervalSinceReferenceDate: .nan)),
            state(lastReview: Date(timeIntervalSinceReferenceDate: .infinity)),
            state(reviews: -1), state(lapses: Int.min)
        ]
    }()

    @Test(arguments: invalidStates)
    func rejectsStatesNoReviewCouldProduce(state: ReviewState) throws {
        let scheduler = try FSRSScheduler()
        #expect(performing: { try scheduler.review(state, rating: .good, at: start) }, throws: isInvalidState)
        #expect(performing: { try scheduler.preview(state, at: start) }, throws: isInvalidState)
    }

    @Test func retrievabilityOfAnInvalidStateIsZero() throws {
        let scheduler = try FSRSScheduler()
        for state in Self.invalidStates where state.stability.map({ !($0 > 0 && $0.isFinite) }) ?? true {
            #expect(scheduler.retrievability(of: state, at: start) == 0)
        }
        let nanDate = Date(timeIntervalSinceReferenceDate: .nan)
        let valid = try scheduler.review(ReviewState(due: start), rating: .good, at: start).state
        #expect(scheduler.retrievability(of: valid, at: nanDate) == 0)
    }

    @Test(arguments: [Double.nan, .infinity, -.infinity])
    func rejectsANonFiniteReviewDate(seconds: Double) throws {
        let date = Date(timeIntervalSinceReferenceDate: seconds)
        #expect(throws: SchedulingError.invalidDate) { try FSRSScheduler().review(ReviewState(due: start), rating: .good, at: date) }
    }

    @Test func countersStopAtIntMaxInsteadOfOverflowing() throws {
        let scheduler = try FSRSScheduler()
        let state = ReviewState(phase: .review, step: nil, stability: 10, difficulty: 5, due: start,
                                lastReview: start.addingTimeInterval(-10 * 86_400), reviewCount: .max, lapseCount: .max)
        let outcome = try scheduler.review(state, rating: .again, at: start)
        #expect(outcome.state.reviewCount == .max)
        #expect(outcome.state.lapseCount == .max)
    }

    @Test func aHugeStepIndexGraduatesInsteadOfOverflowing() throws {
        let scheduler = try FSRSScheduler()
        let state = ReviewState(phase: .learning, step: .max, stability: 3, difficulty: 5, due: start,
                                lastReview: start.addingTimeInterval(-60), reviewCount: 1, lapseCount: 0)
        #expect(try scheduler.review(state, rating: .good, at: start).state.phase == .review)
        #expect(try scheduler.review(state, rating: .again, at: start).state.step == 0)
    }

    @Test(arguments: [Date.distantPast, .distantFuture, Date(timeIntervalSinceReferenceDate: 1e300), Date(timeIntervalSinceReferenceDate: -1e300)])
    func farApartDatesDoNotTrap(date: Date) throws {
        let scheduler = try FSRSScheduler()
        var state = try scheduler.review(ReviewState(due: start), rating: .easy, at: start).state
        state = try scheduler.review(state, rating: .good, at: date).state
        #expect(state.stability.map { $0.isFinite && $0 > 0 } == true)
        #expect((0...1).contains(scheduler.retrievability(of: state, at: start)))
    }

    @Test func largeStabilityIsCappedAtTheMaximumInterval() throws {
        let scheduler = try FSRSScheduler(maximumInterval: 365, fuzzEnabled: false)
        let state = ReviewState(phase: .review, step: nil, stability: 1e300, difficulty: 1, due: start,
                                lastReview: start, reviewCount: 3, lapseCount: 0)
        let outcome = try scheduler.review(state, rating: .easy, at: start.addingTimeInterval(86_400 * 3))
        #expect(outcome.interval == 365 * 86_400)
    }

    @Test(arguments: [1e308, Double.greatestFiniteMagnitude, FSRSWeights.maximumStability * 10])
    func hugeStoredStabilityStaysFiniteThroughLaterReviews(stability: Double) throws {
        var weights = FSRSWeights.defaults
        weights[19] = 0   // short-term reviews then never shrink the stability's growth
        let scheduler = try FSRSScheduler(weights: weights, fuzzEnabled: false)
        for rating in Rating.allCases {
            for gap: TimeInterval in [0, 30 * 86_400] {
                var state = ReviewState(phase: .review, step: nil, stability: stability, difficulty: 1, due: start,
                                        lastReview: start, reviewCount: 3, lapseCount: 0)
                for review in 1...3 {
                    let date = start.addingTimeInterval(gap * Double(review))
                    state = try scheduler.review(state, rating: rating, at: date).state
                    let next = try #require(state.stability)
                    #expect(next.isFinite && next <= FSRSWeights.maximumStability)
                }
            }
        }
    }

    @Test func roundedIntHandlesEveryDouble() {
        #expect(SafeNumerics.roundedInt(.nan, clampedTo: 1...10) == 1)
        #expect(SafeNumerics.roundedInt(.infinity, clampedTo: 1...10) == 10)
        #expect(SafeNumerics.roundedInt(-.infinity, clampedTo: 1...10) == 1)
        #expect(SafeNumerics.roundedInt(1e300, clampedTo: 1...Int.max) == Int.max)
        #expect(SafeNumerics.roundedInt(2.5, clampedTo: 1...10) == 2)
        #expect(SafeNumerics.roundedInt(3.5, clampedTo: 1...10) == 4)
    }
}
