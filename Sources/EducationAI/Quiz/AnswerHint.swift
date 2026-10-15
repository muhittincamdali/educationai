/// Builds a hint that shows the shape of an answer without giving it away.
///
/// ```swift
/// AnswerHint.masked("New York", revealing: 1)   // "N__ ____"
/// ```
///
/// Each user-perceived character (grapheme cluster) other than white space becomes one mask
/// character, so a letter with combining accents or an emoji sequence never leaks through as
/// separate pieces. Invisible format and control characters (zero-width spaces, direction
/// overrides) are left out, so they cannot reorder or pad the hint.
public enum AnswerHint {
    /// The answer with all but the first `revealedCount` visible characters replaced by `mask`.
    ///
    /// - Parameters:
    ///   - answer: The answer to hide.
    ///   - revealedCount: How many visible characters to show from the start. Negative values
    ///     count as 0.
    ///   - mask: The character shown in place of hidden ones.
    public static func masked(_ answer: String, revealing revealedCount: Int = 0, mask: Character = "_") -> String {
        var remaining = max(0, revealedCount)
        var hint = ""
        for character in answer {
            if isInvisible(character) { continue }
            if character.isWhitespace {
                hint.append(" ")
            } else if remaining > 0 {
                hint.append(character)
                remaining -= 1
            } else {
                hint.append(mask)
            }
        }
        return hint
    }

    private static func isInvisible(_ character: Character) -> Bool {
        character.unicodeScalars.allSatisfy { scalar in
            let category = scalar.properties.generalCategory
            return category == .format || (category == .control && !scalar.properties.isWhitespace)
        }
    }
}
