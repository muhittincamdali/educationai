import Foundation
import Testing
@testable import EducationAI

struct SessionTests {
    let now = Date(timeIntervalSince1970: 1_760_500_000)

    var utc: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }

    struct Card: Equatable {
        let name: String
        let review: ReviewState
    }

    func reviewItem(_ name: String, dueIn seconds: TimeInterval, phase: ReviewState.Phase = .review) -> Card {
        let state = ReviewState(
            phase: phase, step: phase == .review ? nil : 0, stability: 5, difficulty: 5,
            due: now.addingTimeInterval(seconds), lastReview: now.addingTimeInterval(-86_400),
            reviewCount: 2, lapseCount: 0
        )
        return Card(name: name, review: state)
    }

    // MARK: Study queue

    @Test func ordersStepsThenOverdueReviewsThenNewItems() {
        let cards = [
            Card(name: "new 1", review: ReviewState(due: now.addingTimeInterval(-10))),
            reviewItem("review late", dueIn: -3 * 86_400),
            reviewItem("not due", dueIn: 3_600),
            reviewItem("relearning", dueIn: -60, phase: .relearning),
            reviewItem("review", dueIn: -60),
            Card(name: "new 2", review: ReviewState(due: now)),
            Card(name: "new later", review: ReviewState(due: now.addingTimeInterval(60))),
            reviewItem("learning early", dueIn: -600, phase: .learning)
        ]
        let queue = StudyQueue.items(from: cards, at: now) { $0.review }
        #expect(queue.map(\.name) == ["learning early", "relearning", "review late", "review", "new 1", "new 2"])
    }

    @Test func limitsNewAndReviewItemsButNotItemsInSteps() {
        let cards = (0..<5).map { reviewItem("review \($0)", dueIn: -Double($0)) }
            + (0..<5).map { Card(name: "new \($0)", review: ReviewState(due: now)) }
            + (0..<3).map { reviewItem("step \($0)", dueIn: -1, phase: .learning) }
        let queue = StudyQueue.items(from: cards, at: now, newLimit: 2, reviewLimit: 1) { $0.review }
        #expect(queue.filter { $0.name.hasPrefix("step") }.count == 3)
        #expect(queue.filter { $0.name.hasPrefix("review") }.map(\.name) == ["review 4"])
        #expect(queue.filter { $0.name.hasPrefix("new") }.map(\.name) == ["new 0", "new 1"])
    }

    @Test(arguments: [-1, Int.min])
    func negativeLimitsCountAsZero(limit: Int) {
        let states = [ReviewState(due: now), reviewItem("r", dueIn: -1).review]
        #expect(StudyQueue.states(from: states, at: now, newLimit: limit, reviewLimit: limit).isEmpty)
    }

    @Test func leavesOutItemsWithNonFiniteDueDates() {
        let broken = ReviewState(phase: .review, step: nil, stability: 5, difficulty: 5,
                                 due: Date(timeIntervalSinceReferenceDate: .nan), lastReview: now, reviewCount: 1, lapseCount: 0)
        let queue = StudyQueue.states(from: [broken, ReviewState(due: now)], at: now)
        #expect(queue == [ReviewState(due: now)])
    }

    // MARK: Forecast

    @Test func countsDueDatesPerCalendarDay() {
        let today = utc.startOfDay(for: now)
        let dues = [
            today.addingTimeInterval(-5 * 86_400),      // overdue
            today.addingTimeInterval(-1),               // overdue
            today.addingTimeInterval(3_600),            // today
            today.addingTimeInterval(86_400),           // tomorrow, first second
            today.addingTimeInterval(2 * 86_400 - 1),   // tomorrow, last second
            today.addingTimeInterval(6 * 86_400 + 5),   // day 6
            today.addingTimeInterval(7 * 86_400)        // outside a 7-day forecast
        ]
        let forecast = ReviewForecast(dueDates: dues, from: now, days: 7, calendar: utc)
        #expect(forecast.days.map(\.count) == [3, 2, 0, 0, 0, 0, 1])
        #expect(forecast.overdueCount == 2)
        #expect(forecast.totalCount == 6)
        #expect(forecast.days[1].date == today.addingTimeInterval(86_400))
    }

    @Test func daysFollowTheCalendarTimeZone() {
        var tokyo = Calendar(identifier: .gregorian)
        tokyo.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        // 2025-10-15 05:00 UTC is 14:00 in Tokyo; 16:00 UTC the same day is already the 16th there.
        let morning = Date(timeIntervalSince1970: 1_760_504_400)
        let evening = morning.addingTimeInterval(11 * 3_600)
        #expect(ReviewForecast(dueDates: [evening], from: morning, days: 2, calendar: tokyo).days.map(\.count) == [0, 1])
        #expect(ReviewForecast(dueDates: [evening], from: morning, days: 2, calendar: utc).days.map(\.count) == [1, 0])
    }

    @Test(arguments: [0, -5, Int.min, Int.max])
    func dayCountIsClamped(days: Int) {
        let forecast = ReviewForecast(dueDates: [now], from: now, days: days, calendar: utc)
        #expect((1...ReviewForecast.maximumDays).contains(forecast.days.count))
    }

    @Test func ignoresDatesThatAreNotFiniteOrFarAway() {
        let dues = [
            Date(timeIntervalSinceReferenceDate: .nan), Date(timeIntervalSinceReferenceDate: .infinity),
            Date(timeIntervalSinceReferenceDate: 1e300), .distantFuture, Date(timeIntervalSinceReferenceDate: -1e300)
        ]
        let forecast = ReviewForecast(dueDates: dues, from: now, days: 30, calendar: utc)
        #expect(forecast.totalCount == 1)
        #expect(forecast.overdueCount == 1)
    }

    // MARK: Statistics

    @Test func countsRatingsAndRetentionOfReviewPhaseItems() {
        func log(_ rating: Rating, _ phase: ReviewState.Phase, _ duration: TimeInterval? = nil) -> ReviewLog {
            ReviewLog(rating: rating, reviewedAt: now, phase: phase, scheduledInterval: 60, duration: duration)
        }
        let logs = [
            log(.again, .learning, 4), log(.good, .learning, 6),
            log(.good, .review, 2), log(.easy, .review), log(.again, .review, .nan), log(.hard, .review, -3),
            log(.good, .relearning, 8)
        ]
        let stats = ReviewStatistics(logs: logs)
        #expect(stats.reviewCount == 7)
        #expect(stats.ratingCounts == [.again: 2, .good: 3, .easy: 1, .hard: 1])
        #expect(stats.retention == 0.75)
        #expect(stats.averageDuration == 5)
    }

    @Test func emptyAndExtremeLogsGiveNilsAndFiniteMeans() {
        let empty = ReviewStatistics(logs: [])
        #expect(empty.reviewCount == 0)
        #expect(empty.retention == nil)
        #expect(empty.averageDuration == nil)

        let huge = (0..<4).map { _ in
            ReviewLog(rating: .good, reviewedAt: now, phase: .learning, scheduledInterval: 0, duration: .greatestFiniteMagnitude)
        }
        #expect(ReviewStatistics(logs: huge).averageDuration == .greatestFiniteMagnitude)
    }
}
