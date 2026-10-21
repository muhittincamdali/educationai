import EducationAI
import Foundation
import Observation

/// The app's model: the cards, the review log and the scheduler, saved as one JSON file.
@MainActor
@Observable
final class DeckStore {
    private(set) var cards: [Flashcard]
    private(set) var logs: [ReviewLog]
    let scheduler = FSRSScheduler.default

    /// The current time. A fixed time in demo mode, so screenshots show the same schedule.
    let clock: @MainActor () -> Date
    /// Interval fuzz: seeded in demo mode, system randomness otherwise.
    private var generator: AnyGenerator
    private let fileURL: URL?

    private struct SavedDeck: Codable {
        var cards: [Flashcard]
        var logs: [ReviewLog]
    }

    /// The store the app uses: the saved deck, or the sample deck on first launch.
    init() {
        let url = URL.applicationSupportDirectory.appending(path: "StudyDeck/deck.json")
        let saved = (try? Data(contentsOf: url)).flatMap { try? JSONDecoder().decode(SavedDeck.self, from: $0) }
        cards = saved?.cards ?? SampleDeck.capitals()
        logs = saved?.logs ?? []
        clock = { .now }
        generator = AnyGenerator(SystemRandomNumberGenerator())
        fileURL = url
    }

    /// A store with three weeks of simulated study before a fixed date, for screenshots and
    /// previews. Nothing is saved.
    init(demoEndingAt now: Date) {
        var generator = SeededRandomNumberGenerator(seed: 2026)
        let history = SampleDeck.simulatedHistory(endingAt: now, scheduler: scheduler, using: &generator)
        cards = history.cards
        logs = history.logs
        clock = { now }
        self.generator = AnyGenerator(generator)
        fileURL = nil
    }

    var now: Date { clock() }

    /// The cards to study now.
    var queue: [Flashcard] { StudyQueue.cards(from: cards, at: now, newLimit: 10) }

    /// The outcome of each rating for a card, computed once when its answer is shown.
    func preview(for card: Flashcard) -> ReviewPreview? {
        try? scheduler.preview(card.review, at: now, using: &generator)
    }

    /// Stores the outcome the learner chose.
    func apply(_ outcome: ReviewOutcome, to cardID: String) {
        guard let index = cards.firstIndex(where: { $0.id == cardID }) else { return }
        cards[index].review = outcome.state
        logs.append(outcome.log)
        save()
    }

    /// Reviews a card with a rating suggested by a quiz result.
    func review(cardID: String, rating: Rating, duration: TimeInterval?) {
        guard let card = cards.first(where: { $0.id == cardID }),
              let outcome = try? scheduler.review(card.review, rating: rating, at: now, duration: duration, using: &generator)
        else { return }
        apply(outcome, to: cardID)
    }

    /// Makes a card new again, keeping its review and lapse counts; its reviews stay in the log.
    func reset(cardID: String) {
        guard let index = cards.firstIndex(where: { $0.id == cardID }) else { return }
        cards[index].review = cards[index].review.reset(dueAt: now, keepingCounts: true)
        save()
    }

    func retrievability(of card: Flashcard) -> Double {
        scheduler.retrievability(of: card.review, at: now)
    }

    private func save() {
        guard let fileURL else { return }
        do {
            try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            try JSONEncoder().encode(SavedDeck(cards: cards, logs: logs)).write(to: fileURL, options: .atomic)
        } catch {
            print("Saving the deck failed: \(error)")
        }
    }
}

/// A random number generator of either kind, so the store can hold one without being generic.
struct AnyGenerator: RandomNumberGenerator {
    private var nextValue: () -> UInt64

    init<Generator: RandomNumberGenerator>(_ generator: Generator) {
        var generator = generator
        nextValue = { generator.next() }
    }

    mutating func next() -> UInt64 { nextValue() }
}
