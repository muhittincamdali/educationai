import Foundation
import Testing
@testable import EducationAI

struct AnswerMatcherTests {
    let matcher = AnswerMatcher()

    @Test(arguments: [
        ("paris", "Paris"),
        ("  PARIS!! ", "Paris"),
        ("Sao Paulo", "São Paulo"),
        ("são   paulo", "Sao Paulo"),
        ("rock n roll", "Rock 'n' Roll"),
        ("ＴＯＫＹＯ", "Tokyo"),                       // full-width letters
        ("cafe\u{301}", "café"),                      // decomposed accent
        ("Ne\u{200B}w York", "New York\u{FEFF}"),     // zero-width characters are ignored
        ("istanbul", "İstanbul"),                     // dotted capital I, without a Turkish locale
        ("C++", "c++"),                               // symbols are kept
        ("e = mc²", "E = mc2")                        // superscript two is a compatibility form of 2
    ])
    func acceptsAnswersThatDifferOnlyInForm(response: String, accepted: String) {
        #expect(matcher.evaluate(response, acceptedAnswers: [accepted]) == .correct)
    }

    @Test func zeroWidthSpaceJoinsWordsRatherThanSeparatingThem() {
        #expect(matcher.normalized("new\u{200B}york") == "newyork")
        #expect(matcher.normalized("New York") == "new york")
    }

    @Test(arguments: [("C", "C++"), ("4", "four"), ("Paris", "London"), ("", "Paris"), ("   ", "Paris"), ("!!!", "Paris")])
    func rejectsDifferentAnswers(response: String, accepted: String) {
        #expect(matcher.evaluate(response, acceptedAnswers: [accepted]) == .incorrect)
    }

    @Test func eachOptionCanBeTurnedOff() {
        let strict = AnswerMatcher(ignoresCase: false, ignoresDiacritics: false, ignoresPunctuation: false, typoTolerance: .none)
        #expect(strict.evaluate("paris", acceptedAnswers: ["Paris"]) == .incorrect)
        #expect(strict.evaluate("Sao Paulo", acceptedAnswers: ["São Paulo"]) == .incorrect)
        #expect(strict.evaluate("rock n roll", acceptedAnswers: ["rock 'n' roll"]) == .incorrect)
        #expect(strict.evaluate("Paris ", acceptedAnswers: ["Paris"]) == .correct)
    }

    @Test(arguments: [
        ("Pari", "Paris", 1),            // deletion
        ("Parris", "Paris", 1),          // insertion
        ("Parid", "Paris", 1),           // substitution
        ("Prais", "Paris", 1),           // adjacent swap counts once
        ("Amsterdma", "Amsterdam", 1),
        ("Amstredma", "Amsterdam", 2)
    ])
    func forgivesTyposByLength(response: String, accepted: String, typos: Int) {
        #expect(matcher.evaluate(response, acceptedAnswers: [accepted]) == .almostCorrect(expected: accepted, typos: typos))
    }

    @Test func automaticToleranceDependsOnTheAnswerLength() {
        #expect(matcher.evaluate("cta", acceptedAnswers: ["cat"]) == .incorrect)
        #expect(matcher.evaluate("Prs", acceptedAnswers: ["Paris"]) == .incorrect)
        #expect(matcher.evaluate("Amstrdm", acceptedAnswers: ["Amsterdam"]) == .almostCorrect(expected: "Amsterdam", typos: 2))
        #expect(matcher.evaluate("Amstrd", acceptedAnswers: ["Amsterdam"]) == .incorrect)
    }

    @Test func fixedToleranceIsClamped() {
        #expect(AnswerMatcher(typoTolerance: .fixed(-4)).allowedTypos(forLength: 20) == 0)
        #expect(AnswerMatcher(typoTolerance: .fixed(99)).allowedTypos(forLength: 20) == AnswerMatcher.maximumTypos)
        #expect(AnswerMatcher(typoTolerance: .fixed(.max)).evaluate("abcdefghij", acceptedAnswers: ["abcdefg"]) == .almostCorrect(expected: "abcdefg", typos: 3))
    }

    @Test func fixedToleranceLeavesMostOfTheAnswerRight() {
        let lenient = AnswerMatcher(typoTolerance: .fixed(3))
        #expect(lenient.evaluate("x", acceptedAnswers: ["ab"]) == .incorrect)
        #expect(lenient.evaluate("xyz", acceptedAnswers: ["abc"]) == .incorrect)
        #expect(lenient.evaluate("abx", acceptedAnswers: ["abc"]) == .almostCorrect(expected: "abc", typos: 1))
        #expect(lenient.evaluate("xbcd", acceptedAnswers: ["abcd"]) == .almostCorrect(expected: "abcd", typos: 1))
        #expect(lenient.evaluate("xycd", acceptedAnswers: ["abcd"]) == .incorrect)
        #expect([1, 2, 3, 4, 5, 6, 7, 20].map(lenient.allowedTypos(forLength:)) == [0, 0, 1, 1, 2, 2, 3, 3])
    }

    @Test func picksTheClosestAcceptedAnswer() {
        let result = matcher.evaluate("colour", acceptedAnswers: ["colr", "color", "colour"])
        #expect(result == .correct)
        let close = matcher.evaluate("Kathmandoo", acceptedAnswers: ["Katmandu", "Kathmandu"])
        #expect(close == .almostCorrect(expected: "Kathmandu", typos: 2))
    }

    /// Full optimal-string-alignment table, to check the banded version against.
    func referenceDistance(_ a: [Character], _ b: [Character]) -> Int {
        var table = Array(repeating: Array(repeating: 0, count: b.count + 1), count: a.count + 1)
        for i in 0...a.count { table[i][0] = i }
        for j in 0...b.count { table[0][j] = j }
        for i in stride(from: 1, through: a.count, by: 1) {
            for j in stride(from: 1, through: b.count, by: 1) {
                let cost = a[i - 1] == b[j - 1] ? 0 : 1
                table[i][j] = min(table[i - 1][j] + 1, table[i][j - 1] + 1, table[i - 1][j - 1] + cost)
                if i > 1, j > 1, a[i - 1] == b[j - 2], a[i - 2] == b[j - 1] {
                    table[i][j] = min(table[i][j], table[i - 2][j - 2] + 1)
                }
            }
        }
        return table[a.count][b.count]
    }

    @Test func bandedTypoCountAgreesWithTheFullTable() {
        var generator = SeededRandomNumberGenerator(seed: 99)
        let alphabet: [Character] = ["a", "b", "c", "d"]
        for _ in 0..<3_000 {
            let a = (0..<Int.random(in: 0...9, using: &generator)).map { _ in alphabet.randomElement(using: &generator)! }
            let b = (0..<Int.random(in: 0...9, using: &generator)).map { _ in alphabet.randomElement(using: &generator)! }
            let limit = Int.random(in: 0...3, using: &generator)
            let reference = referenceDistance(a, b)
            let banded = AnswerMatcher.typoCount(a, b, limit: limit)
            #expect(banded == (reference <= limit ? reference : nil), "\(String(a)) / \(String(b)) limit \(limit)")
        }
    }

    @Test func answersOverTheLengthLimitAreNotCompared() {
        let long = String(repeating: "a", count: AnswerMatcher.maximumLength + 1)
        #expect(matcher.evaluate(long, acceptedAnswers: [long]) == .incorrect)
        let atLimit = String(repeating: "a", count: AnswerMatcher.maximumLength)
        #expect(matcher.evaluate(atLimit, acceptedAnswers: [atLimit]) == .correct)
        // Megabytes of input are rejected by size before normalization.
        let huge = String(repeating: "x", count: 4_000_000)
        #expect(matcher.evaluate(huge, acceptedAnswers: ["x"]) == .incorrect)
    }

    @Test func stackedCombiningMarksAreFoldedOrRejectedBySize() {
        // 10,000 accents (20,001 bytes) fold away; 20,000 (40,001 bytes) exceed the input limit.
        let folded = "a" + String(repeating: "\u{0301}", count: 10_000)
        #expect(matcher.evaluate(folded, acceptedAnswers: ["a"]) == .correct)
        let oversized = "a" + String(repeating: "\u{0301}", count: 20_000)
        #expect(matcher.evaluate(oversized, acceptedAnswers: ["a"]) == .incorrect)
    }

    @Test func checkingAgainstThousandsOfLongAnswersStaysFast() {
        let accepted = (0..<5_000).map { String(repeating: "b", count: 400) + "\($0)" }
        let start = Date()
        #expect(matcher.evaluate(String(repeating: "c", count: 450), acceptedAnswers: accepted) == .incorrect)
        #expect(Date().timeIntervalSince(start) < 20)
    }
}

struct AnswerHintTests {
    @Test(arguments: [
        ("New York", 1, "N__ ____"),
        ("New York", 0, "___ ____"),
        ("New York", -5, "___ ____"),
        ("New York", .max, "New York"),
        ("Café", 3, "Caf_"),
        ("Cafe\u{301}", 3, "Caf_"),                       // the accent never shows without its letter
        ("👩‍👩‍👧 family", 0, "_ ______"),                  // an emoji sequence is one mask
        ("ab\u{202E}cd", 0, "____"),                      // a direction override is dropped
        ("a\u{200B}b\u{00AD}c", 1, "a__"),                // zero-width space and soft hyphen are dropped
        ("tab\there", 0, "___ ____")
    ])
    func masksEachVisibleCharacterOnce(answer: String, revealed: Int, hint: String) {
        #expect(AnswerHint.masked(answer, revealing: revealed) == hint)
    }

    @Test func hiddenCharactersNeverAppearInTheHint() {
        let answer = "Ünïcödé façade"
        let hint = AnswerHint.masked(answer, revealing: 2, mask: "•")
        #expect(hint == "Ün••••• ••••••")
        for hidden in "ïcödéfaçade" { #expect(!hint.contains(hidden)) }
    }
}
