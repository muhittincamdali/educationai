import Foundation

/// The learner's run of consecutive study days.
///
/// ```swift
/// let streak = StudyStreak(activityDates: logs.map(\.reviewedAt))
/// print("\(streak.current) days in a row, best \(streak.longest)")
/// ```
///
/// Days are calendar days in `calendar`'s time zone, so a review at 23:50 and one at 00:10 count
/// as two days. A streak stays current through today even if the learner has not studied yet
/// today; it breaks once a whole day passes without study.
public struct StudyStreak: Sendable, Hashable {
    /// Consecutive study days ending today, or yesterday if the learner has not studied today.
    public let current: Int
    /// The longest run of consecutive study days in the dates given.
    public let longest: Int
    /// Whether any activity happened today.
    public let studiedToday: Bool

    /// Dates further than this from `now` (about 100 years) are ignored.
    static let horizon: TimeInterval = 100 * 366 * .secondsPerDay

    /// Computes the streak.
    ///
    /// - Parameters:
    ///   - activityDates: When the learner studied, in any order and with repeats. Dates that are
    ///     not finite, later than today or about a century away are ignored.
    ///   - now: The current time.
    ///   - calendar: The calendar and time zone that define days.
    public init(activityDates: some Sequence<Date>, now: Date = .now, calendar: Calendar = .current) {
        let today = calendar.startOfDay(for: now)
        var daysAgo = Set<Int>()
        for date in activityDates where SafeNumerics.isFinite(date) && abs(date.timeIntervalSince(now)) < Self.horizon {
            guard let offset = calendar.dateComponents([.day], from: calendar.startOfDay(for: date), to: today).day,
                  offset >= 0
            else { continue }
            daysAgo.insert(offset)
        }
        let sorted = daysAgo.sorted()

        var longest = 0
        var run = 0
        var previous: Int?
        for day in sorted {
            run = previous.map { day == $0 + 1 } == true ? run + 1 : 1
            longest = max(longest, run)
            previous = day
        }

        var current = 0
        if let first = sorted.first, first <= 1 {
            current = 1
            for (earlier, later) in zip(sorted, sorted.dropFirst()) {
                guard later == earlier + 1 else { break }
                current += 1
            }
        }
        self.current = current
        self.longest = longest
        self.studiedToday = sorted.first == 0
    }
}
