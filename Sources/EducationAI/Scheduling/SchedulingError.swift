/// Errors thrown when scheduler settings or stored states are not usable.
public enum SchedulingError: Error, Sendable, Hashable {
    /// A scheduler setting is outside its allowed range. The message names the setting and the range.
    case invalidConfiguration(String)
    /// A stored state holds a value no review could have produced (NaN, a negative count, a step
    /// index for the wrong phase). The message names the value.
    case invalidState(String)
    /// A date is NaN or infinite.
    case invalidDate
}

extension SchedulingError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidConfiguration(let message): "Invalid scheduler configuration: \(message)"
        case .invalidState(let message): "Invalid review state: \(message)"
        case .invalidDate: "The date is not a finite point in time."
        }
    }
}
