/// How well the learner remembered an item, as chosen after seeing the answer.
///
/// The four grades match the answer buttons in Anki and the ratings of the FSRS algorithm. The raw
/// values (1 to 4) are the ones FSRS uses in its formulas and in exported review logs.
public enum Rating: Int, CaseIterable, Codable, Sendable, Hashable, Comparable {
    /// The learner did not remember the answer.
    case again = 1
    /// The learner remembered the answer with serious difficulty.
    case hard = 2
    /// The learner remembered the answer after some thought.
    case good = 3
    /// The learner remembered the answer immediately.
    case easy = 4

    /// Whether the learner remembered the answer (every rating except ``again``).
    public var isSuccessfulRecall: Bool { self != .again }

    public static func < (lhs: Rating, rhs: Rating) -> Bool { lhs.rawValue < rhs.rawValue }
}
