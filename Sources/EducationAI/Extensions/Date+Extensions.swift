import Foundation

extension Date {

    /// Returns a human-readable relative time string.
    ///
    /// Examples: "just now", "5 minutes ago", "2 hours ago", "3 days from now"
    public var relativeDescription: String {
        let interval = timeIntervalSinceNow
        let absInterval = abs(interval)
        let isFuture = interval > 0

        if absInterval < 60 {
            return "just now"
        } else if absInterval < 3600 {
            let minutes = Int(absInterval / 60)
            let unit = minutes == 1 ? "minute" : "minutes"
            return isFuture ? "in \(minutes) \(unit)" : "\(minutes) \(unit) ago"
        } else if absInterval < 86_400 {
            let hours = Int(absInterval / 3600)
            let unit = hours == 1 ? "hour" : "hours"
            return isFuture ? "in \(hours) \(unit)" : "\(hours) \(unit) ago"
        } else {
            let days = Int(absInterval / 86_400)
            let unit = days == 1 ? "day" : "days"
            return isFuture ? "in \(days) \(unit)" : "\(days) \(unit) ago"
        }
    }

    /// Whether this date falls on the same calendar day as another.
    public func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }

    /// Whether this date is today.
    public var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// Whether this date is yesterday.
    public var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }

    /// Start of the calendar day for this date.
    public var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// Number of calendar days until this date (negative if in the past).
    public var daysFromNow: Int {
        Calendar.current.dateComponents([.day], from: Date().startOfDay, to: startOfDay).day ?? 0
    }
}
