import Foundation

/// How many items come due on each of the next days, for a workload chart.
///
/// ```swift
/// let forecast = ReviewForecast(dueDates: cards.map(\.review.due), days: 14)
/// for day in forecast.days { print(day.date, day.count) }
/// ```
///
/// Days are calendar days in `calendar`'s time zone. The first day counts everything due by the
/// end of today, including overdue items; ``overdueCount`` says how many of those were due before
/// today started.
public struct ReviewForecast: Sendable, Hashable {
    /// One calendar day of the forecast.
    public struct Day: Sendable, Hashable {
        /// The start of the day.
        public let date: Date
        /// The number of items due on that day.
        public let count: Int
    }

    /// The longest forecast, in days (about ten years).
    public static let maximumDays = 3_650

    /// The forecast days, starting today.
    public let days: [Day]
    /// The number of items that were due before today started.
    public let overdueCount: Int

    /// Counts due dates per day.
    ///
    /// - Parameters:
    ///   - dueDates: The due date of each item. Dates that are not finite are ignored.
    ///   - date: Any time on the first day. Defaults to now.
    ///   - days: The number of days, from 1 to ``maximumDays``; other values are clamped.
    ///   - calendar: The calendar and time zone that define days.
    public init(
        dueDates: some Sequence<Date>,
        from date: Date = .now,
        days: Int = 30,
        calendar: Calendar = .current
    ) {
        let dayCount = min(max(days, 1), Self.maximumDays)
        let today = calendar.startOfDay(for: date)
        // A generous bound in seconds keeps calendar arithmetic away from extreme dates.
        let horizon = TimeInterval(dayCount + 2) * .secondsPerDay
        var counts = Array(repeating: 0, count: dayCount)
        var overdue = 0
        for due in dueDates where SafeNumerics.isFinite(due) {
            let offset = due.timeIntervalSince(today)
            if offset < 0 {
                overdue += 1
                counts[0] += 1
                continue
            }
            guard offset < horizon,
                  let index = calendar.dateComponents([.day], from: today, to: calendar.startOfDay(for: due)).day,
                  index < dayCount
            else { continue }
            counts[index] += 1
        }
        self.overdueCount = overdue
        self.days = counts.enumerated().map { index, count in
            Day(date: calendar.date(byAdding: .day, value: index, to: today) ?? today, count: count)
        }
    }

    /// The total number of items due over the forecast.
    public var totalCount: Int { days.reduce(0) { $0 + $1.count } }
}
