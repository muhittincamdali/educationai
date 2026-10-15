/// Turns flashcards into quiz questions.
///
/// ```swift
/// var generator = SystemRandomNumberGenerator()
/// let questions = QuizBuilder.multipleChoice(from: deck, choiceCount: 4, using: &generator)
/// var quiz = try QuizSession(questions: questions)
/// ```
public enum QuizBuilder {
    /// Multiple-choice questions whose wrong choices are other cards' answers.
    ///
    /// Each card's question shows its front and its answer among up to `choiceCount - 1` answers
    /// of other cards, in random order. Wrong choices never equal the right answer or each other
    /// once normalized with `matcher`, so "Paris" and "paris" are never both offered. A card gets
    /// no question when no other card has a different answer.
    ///
    /// The work per card is bounded, so building questions for a large deck takes time
    /// proportional to the deck's size.
    ///
    /// - Parameters:
    ///   - cards: The cards to ask about, in order.
    ///   - choiceCount: Choices per question, clamped to 2...``QuizQuestion/maximumChoices``.
    ///   - matcher: Decides which answers count as the same.
    ///   - generator: The source of randomness for picking and ordering choices.
    public static func multipleChoice<Generator: RandomNumberGenerator>(
        from cards: [Flashcard],
        choiceCount: Int = 4,
        matcher: AnswerMatcher = AnswerMatcher(),
        using generator: inout Generator
    ) -> [QuizQuestion] {
        let count = min(max(choiceCount, 2), QuizQuestion.maximumChoices)
        let pool = distinctAnswers(of: cards, matcher: matcher)
        return cards.compactMap { card in
            let key = matcher.normalized(card.back)
            let distractors = pickDistractors(count: count - 1, excluding: key, from: pool, using: &generator)
            guard !distractors.isEmpty else { return nil }
            var choices = distractors + [card.back]
            choices.shuffle(using: &generator)
            guard let correctIndex = choices.lastIndex(of: card.back) else { return nil }
            return try? QuizQuestion(id: card.id, prompt: card.front, kind: .multipleChoice(choices: choices, correctIndex: correctIndex))
        }
    }

    /// Multiple-choice questions with system randomness. See ``multipleChoice(from:choiceCount:matcher:using:)``.
    public static func multipleChoice(from cards: [Flashcard], choiceCount: Int = 4, matcher: AnswerMatcher = AnswerMatcher()) -> [QuizQuestion] {
        var generator = SystemRandomNumberGenerator()
        return multipleChoice(from: cards, choiceCount: choiceCount, matcher: matcher, using: &generator)
    }

    /// Typed-answer questions that accept each card's answer and its alternatives.
    ///
    /// A card gets no question when `matcher` can match none of its answers, for example when
    /// they are blank, or only punctuation and `matcher` ignores punctuation. Pass the matcher
    /// the ``QuizSession`` will use, which rejects such questions.
    public static func typedAnswer(from cards: [Flashcard], matcher: AnswerMatcher = AnswerMatcher()) -> [QuizQuestion] {
        cards.compactMap { card in
            guard card.acceptedAnswers.contains(where: matcher.canMatch) else { return nil }
            return try? QuizQuestion(id: card.id, prompt: card.front, kind: .typedAnswer(acceptedAnswers: card.acceptedAnswers))
        }
    }

    /// Each normalized answer once, with the first spelling seen.
    private static func distinctAnswers(of cards: [Flashcard], matcher: AnswerMatcher) -> [(key: String, text: String)] {
        var seen = Set<String>()
        var pool: [(key: String, text: String)] = []
        for card in cards {
            let key = matcher.normalized(card.back)
            if !key.isEmpty, seen.insert(key).inserted { pool.append((key, card.back)) }
        }
        return pool
    }

    /// Up to `count` answers from `pool` other than `excluded`. Small pools are shuffled whole;
    /// large ones are sampled with a fixed number of draws, so a large deck does not make each
    /// question cost as much as the whole deck.
    private static func pickDistractors<Generator: RandomNumberGenerator>(
        count: Int,
        excluding excluded: String,
        from pool: [(key: String, text: String)],
        using generator: inout Generator
    ) -> [String] {
        let smallPool = 64
        if pool.count <= smallPool {
            return Array(pool.filter { $0.key != excluded }.shuffled(using: &generator).prefix(count).map(\.text))
        }
        var picked: [String] = []
        var pickedIndices = Set<Int>()
        for _ in 0..<(count * 16) where picked.count < count {
            let index = Int.random(in: pool.indices, using: &generator)
            guard pool[index].key != excluded, pickedIndices.insert(index).inserted else { continue }
            picked.append(pool[index].text)
        }
        return picked
    }
}
