import Foundation

/// Conversions that cannot trap. `Int(_:)` on a `Double` crashes for NaN, infinity and values
/// outside `Int`'s range, and `+ 1` crashes at `Int.max`; values decoded from storage can be any
/// of these.
enum SafeNumerics {
    /// `value` rounded to the nearest whole number (ties to even, like Python's `round`) and
    /// clamped to `range`. NaN maps to the lower bound, infinities to the nearest bound.
    static func roundedInt(_ value: Double, clampedTo range: ClosedRange<Int>) -> Int {
        guard !value.isNaN else { return range.lowerBound }
        let rounded = value.rounded(.toNearestOrEven)
        if rounded <= Double(range.lowerBound) { return range.lowerBound }
        if rounded >= Double(range.upperBound) { return range.upperBound }
        return Int(rounded)
    }

    /// `value + 1`, staying at `Int.max` instead of overflowing.
    static func incremented(_ value: Int) -> Int {
        value == .max ? .max : value + 1
    }

    /// Whether a date holds a finite time (a decoded `Date` can hold NaN or infinity).
    static func isFinite(_ date: Date) -> Bool {
        date.timeIntervalSinceReferenceDate.isFinite
    }
}

extension TimeInterval {
    /// Seconds in a day, as used by every interval calculation in the package.
    static let secondsPerDay: TimeInterval = 86_400
}
