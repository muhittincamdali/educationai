import Foundation

/// The result of comparing a typed answer with the accepted answers.
public enum AnswerEvaluation: Codable, Sendable, Hashable {
    /// The answer matches an accepted answer after normalization.
    case correct
    /// The answer is within the allowed number of typos of `expected`.
    case almostCorrect(expected: String, typos: Int)
    /// The answer matches no accepted answer.
    case incorrect

    /// Whether the answer counts as right (``correct`` or ``almostCorrect(expected:typos:)``).
    public var isAccepted: Bool { self != .incorrect }
}

/// Compares typed answers with accepted answers, forgiving case, accents, punctuation and typos.
///
/// ```swift
/// let matcher = AnswerMatcher()
/// matcher.evaluate("  paris!", acceptedAnswers: ["Paris"])     // .correct
/// matcher.evaluate("Pari", acceptedAnswers: ["Paris"])         // .almostCorrect(expected: "Paris", typos: 1)
/// matcher.evaluate("São Paulo", acceptedAnswers: ["Sao Paulo"]) // .correct
/// ```
///
/// Both sides are normalized the same way: Unicode compatibility forms are unified (full-width
/// letters, ligatures), case and diacritics are folded without regard to locale, invisible format
/// characters are removed, punctuation is dropped and runs of white space become one space.
/// Typos are counted as insertions, deletions, substitutions and swaps of adjacent characters.
///
/// Work is bounded: an answer longer than ``maximumLength`` characters is ``AnswerEvaluation/incorrect``
/// without being compared, and the typo count is computed only within ``maximumTypos`` of the
/// diagonal, so checking an answer costs time proportional to its length.
public struct AnswerMatcher: Codable, Sendable, Hashable {
    /// How many typos an answer may have and still count.
    public enum TypoTolerance: Codable, Sendable, Hashable {
        /// Only exact matches after normalization count.
        case none
        /// No typos for answers of up to 3 characters, 1 up to 7, 2 for longer answers.
        case automatic
        /// A fixed number of typos, clamped to 0...``AnswerMatcher/maximumTypos`` and to fewer
        /// than half of the accepted answer's characters, so that most of an answer must be right:
        /// `.fixed(3)` allows no typo in "ab", 1 in "abc" and 3 from 7 characters on.
        case fixed(Int)
    }

    /// The longest answer, in characters after normalization, that is compared.
    public static let maximumLength = 500
    /// The most typos any tolerance allows.
    public static let maximumTypos = 3
    /// The largest input, in UTF-8 bytes, that is normalized at all. Anything larger cannot
    /// normalize to ``maximumLength`` characters of ordinary text.
    static let maximumInputBytes = maximumLength * 64

    /// Whether "Paris" and "paris" match.
    public var ignoresCase: Bool
    /// Whether "São" and "Sao" match.
    public var ignoresDiacritics: Bool
    /// Whether "rock 'n' roll" and "rock n roll" match.
    public var ignoresPunctuation: Bool
    /// How many typos are forgiven.
    public var typoTolerance: TypoTolerance

    /// Creates a matcher. The defaults forgive case, diacritics, punctuation and a few typos.
    public init(
        ignoresCase: Bool = true,
        ignoresDiacritics: Bool = true,
        ignoresPunctuation: Bool = true,
        typoTolerance: TypoTolerance = .automatic
    ) {
        self.ignoresCase = ignoresCase
        self.ignoresDiacritics = ignoresDiacritics
        self.ignoresPunctuation = ignoresPunctuation
        self.typoTolerance = typoTolerance
    }

    /// Compares `response` with each accepted answer and returns the best result.
    public func evaluate(_ response: String, acceptedAnswers: [String]) -> AnswerEvaluation {
        guard let given = comparable(response), !given.isEmpty else { return .incorrect }
        var best: (expected: String, typos: Int)?
        for accepted in acceptedAnswers {
            guard let expected = comparable(accepted), !expected.isEmpty else { continue }
            if given == expected { return .correct }
            let allowed = allowedTypos(forLength: expected.count)
            guard allowed > 0, let typos = Self.typoCount(given, expected, limit: allowed) else { continue }
            if best.map({ typos < $0.typos }) ?? true { best = (accepted, typos) }
        }
        return best.map { .almostCorrect(expected: $0.expected, typos: $0.typos) } ?? .incorrect
    }

    /// The normalized form of `text` that answers are compared in.
    public func normalized(_ text: String) -> String {
        var options: String.CompareOptions = [.widthInsensitive]
        if ignoresCase { options.insert(.caseInsensitive) }
        if ignoresDiacritics { options.insert(.diacriticInsensitive) }
        let folded = text.precomposedStringWithCompatibilityMapping.folding(options: options, locale: nil)

        var result = String.UnicodeScalarView()
        var pendingSpace = false
        for scalar in folded.unicodeScalars {
            let properties = scalar.properties
            if properties.isWhitespace {
                pendingSpace = !result.isEmpty
                continue
            }
            if properties.generalCategory == .format || properties.generalCategory == .control { continue }
            if ignoresPunctuation, Self.isPunctuation(properties.generalCategory) { continue }
            if pendingSpace {
                result.append(" ")
                pendingSpace = false
            }
            result.append(scalar)
        }
        // Folding precomposed text can leave decomposed sequences; compare in one canonical form.
        return String(result).precomposedStringWithCanonicalMapping
    }

    /// Whether some response can match `accepted`: it keeps a character after normalization and
    /// is no longer than ``maximumLength``. An accepted answer that fails this matches nothing.
    func canMatch(_ accepted: String) -> Bool {
        comparable(accepted).map { !$0.isEmpty } ?? false
    }

    private func comparable(_ text: String) -> [Character]? {
        guard text.utf8.count <= Self.maximumInputBytes else { return nil }
        let characters = Array(normalized(text))
        return characters.count <= Self.maximumLength ? characters : nil
    }

    func allowedTypos(forLength length: Int) -> Int {
        switch typoTolerance {
        case .none: 0
        case .fixed(let count): min(max(count, 0), Self.maximumTypos, (length - 1) / 2)
        case .automatic: length <= 3 ? 0 : (length <= 7 ? 1 : 2)
        }
    }

    private static func isPunctuation(_ category: Unicode.GeneralCategory) -> Bool {
        switch category {
        case .connectorPunctuation, .dashPunctuation, .openPunctuation, .closePunctuation,
             .initialPunctuation, .finalPunctuation, .otherPunctuation:
            true
        default:
            false
        }
    }

    /// The optimal string alignment distance between `a` and `b` if it is at most `limit`,
    /// otherwise `nil`. Only cells within `limit` of the diagonal are computed.
    static func typoCount(_ a: [Character], _ b: [Character], limit: Int) -> Int? {
        guard abs(a.count - b.count) <= limit else { return nil }
        let unreachable = limit + 1
        var previous2 = [Int](repeating: unreachable, count: b.count + 1)
        var previous = (0...b.count).map { $0 <= limit ? $0 : unreachable }
        var current = [Int](repeating: unreachable, count: b.count + 1)
        for i in 1...max(a.count, 1) where i <= a.count {
            let low = max(1, i - limit)
            let high = min(b.count, i + limit)
            current[0] = i <= limit ? i : unreachable
            if low > 1 { current[low - 1] = unreachable }
            var rowMinimum = current[0]
            if low <= high {
                for j in low...high {
                    let cost = a[i - 1] == b[j - 1] ? 0 : 1
                    var value = min(previous[j] + 1, current[j - 1] + 1, previous[j - 1] + cost)
                    if i > 1, j > 1, a[i - 1] == b[j - 2], a[i - 2] == b[j - 1] {
                        value = min(value, previous2[j - 2] + 1)
                    }
                    current[j] = min(value, unreachable)
                    rowMinimum = min(rowMinimum, current[j])
                }
            }
            if high < b.count { current[high + 1] = unreachable }
            guard rowMinimum <= limit else { return nil }
            (previous2, previous, current) = (previous, current, previous2)
        }
        let distance = previous[b.count]
        return distance <= limit ? distance : nil
    }
}
