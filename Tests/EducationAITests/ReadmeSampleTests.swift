import Foundation
import SwiftUI
import Testing
import EducationAI

/// Runs the README samples (ReadmeSamples.swift, linked from the example app) and checks that
/// they do what the README says.
@MainActor
struct ReadmeSampleTests {
    let now = Date(timeIntervalSince1970: 1_760_500_000)

    @Test func quickStartViewBuilds() {
        _ = FlashcardsView().body
    }

    @Test func buttonLabelsShowTheIntervalOfEachRating() throws {
        let labels = try buttonLabels(for: Flashcard(front: "Capital of Japan", back: "Tokyo"), scheduler: .default)
        #expect(labels.count == 4)
        #expect(labels[0].hasPrefix("Again"))
        #expect(labels[2].hasPrefix("Good"))
        #expect(labels[2].contains("10"))
    }

    @Test func customSettingsAreValid() throws {
        let scheduler = try makeScheduler()
        #expect(scheduler.desiredRetention == 0.85)
        #expect(scheduler.maximumInterval == 365)
    }

    @Test func typedAnswerFeedback() {
        let card = Flashcard(front: "Capital of Kenya", back: "Nairobi")
        #expect(feedback(for: "nairobi", card: card) == "Correct")
        #expect(feedback(for: "Nairbi", card: card) == "Almost: it is spelled Nairobi")
        #expect(feedback(for: "Mombasa", card: card) == "The answer is Nairobi")
    }

    @Test func quizResultsRescheduleTheCards() throws {
        var deck = [
            Flashcard(id: "jp", front: "Capital of Japan", back: "Tokyo", review: ReviewState(due: now)),
            Flashcard(id: "ke", front: "Capital of Kenya", back: "Nairobi", review: ReviewState(due: now))
        ]
        let score = try quizAndReschedule(deck: &deck, answers: ["jp": "tokyo", "ke": "Lagos"], at: now)
        #expect(score == 0.5)
        #expect(deck.allSatisfy { $0.review.reviewCount == 1 })
        #expect(deck[0].review.step == 1)   // Good: second learning step
        #expect(deck[1].review.step == 0)   // Again: first learning step
    }

    @Test func migrationKeepsTheDueDate() throws {
        let state = try migrate(easeFactor: 2.5, intervalDays: 20, due: now, lastReview: now.addingTimeInterval(-20 * 86_400))
        #expect(state.due == now)
        #expect(state.phase == .review)
    }

    @Test func progressSummaryCountsStreakAndDueCards() throws {
        let scheduler = FSRSScheduler.default
        var card = Flashcard(front: "Capital of Peru", back: "Lima", review: ReviewState(due: now.addingTimeInterval(-86_400)))
        let outcome = try scheduler.review(card.review, rating: .good, at: now.addingTimeInterval(-86_400))
        card.review = outcome.state
        let summary = progressSummary(deck: [card], logs: [outcome.log], now: now)
        #expect(summary.hasPrefix("1-day streak, 1 due today"))
    }
}
