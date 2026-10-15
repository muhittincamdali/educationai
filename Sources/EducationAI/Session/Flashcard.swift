import Foundation

/// A ready-made flashcard: a prompt, an answer and its review state.
///
/// Use it as your model, or keep your own type and store a ``ReviewState`` in it; every API
/// that takes flashcards has a variant that takes a closure returning the state instead.
///
/// ```swift
/// var deck = [
///     Flashcard(front: "Capital of Japan", back: "Tokyo"),
///     Flashcard(front: "Capital of Kenya", back: "Nairobi")
/// ]
/// deck[0].review = try scheduler.review(deck[0].review, rating: .good).state
/// ```
public struct Flashcard: Identifiable, Codable, Sendable, Hashable {
    /// A stable identifier. Defaults to a new UUID string.
    public var id: String
    /// The prompt shown first.
    public var front: String
    /// The answer.
    public var back: String
    /// Other answers that also count as right in a typed quiz, such as spelling variants.
    public var alternativeAnswers: [String]
    /// The card's scheduling state.
    public var review: ReviewState

    /// Creates a new card, due now unless `review` says otherwise.
    public init(
        id: String = UUID().uuidString,
        front: String,
        back: String,
        alternativeAnswers: [String] = [],
        review: ReviewState = ReviewState()
    ) {
        self.id = id
        self.front = front
        self.back = back
        self.alternativeAnswers = alternativeAnswers
        self.review = review
    }

    /// The answer and the alternatives, in that order.
    public var acceptedAnswers: [String] { [back] + alternativeAnswers }
}

extension StudyQueue {
    /// The flashcards to study at `date`; see ``items(from:at:newLimit:reviewLimit:state:)``.
    public static func cards(
        from cards: some Sequence<Flashcard>,
        at date: Date = .now,
        newLimit: Int = 20,
        reviewLimit: Int = 200
    ) -> [Flashcard] {
        items(from: cards, at: date, newLimit: newLimit, reviewLimit: reviewLimit) { $0.review }
    }
}
