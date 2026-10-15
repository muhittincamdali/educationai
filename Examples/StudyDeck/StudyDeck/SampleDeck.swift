import EducationAI
import Foundation

/// The sample cards and a simulated study history for demo mode.
enum SampleDeck {
    static func capitals() -> [Flashcard] {
        let pairs: [(country: String, capital: String, alternatives: [String])] = [
            ("Japan", "Tokyo", []), ("Kenya", "Nairobi", []), ("Peru", "Lima", []),
            ("Canada", "Ottawa", []), ("Australia", "Canberra", []), ("Brazil", "Brasília", []),
            ("Egypt", "Cairo", []), ("Norway", "Oslo", []), ("Vietnam", "Hanoi", ["Ha Noi"]),
            ("Morocco", "Rabat", []), ("Chile", "Santiago", []), ("Türkiye", "Ankara", []),
            ("Germany", "Berlin", []), ("Argentina", "Buenos Aires", []), ("India", "New Delhi", []),
            ("Thailand", "Bangkok", []), ("Nigeria", "Abuja", []), ("Portugal", "Lisbon", ["Lisboa"]),
            ("South Korea", "Seoul", []), ("New Zealand", "Wellington", []), ("Mexico", "Mexico City", []),
            ("Ghana", "Accra", []), ("Iceland", "Reykjavík", []), ("Nepal", "Kathmandu", []),
            ("Switzerland", "Bern", ["Berne"]), ("Mongolia", "Ulaanbaatar", ["Ulan Bator"]),
            ("Colombia", "Bogotá", []), ("Finland", "Helsinki", []), ("Indonesia", "Jakarta", []),
            ("Ethiopia", "Addis Ababa", [])
        ]
        return pairs.map { pair in
            Flashcard(
                id: pair.country.lowercased().replacingOccurrences(of: " ", with: "-"),
                front: "Capital of \(pair.country)",
                back: pair.capital,
                alternativeAnswers: pair.alternatives
            )
        }
    }

    /// Three weeks of daily study before the day of `now`: each morning at 7:30 the learner
    /// reviews what is due for an hour and adds one new card, rating mostly Good, sometimes Again,
    /// Hard or Easy. On the day of `now` the reviews from those mornings and the cards never
    /// studied are due.
    static func simulatedHistory(
        endingAt now: Date,
        scheduler: FSRSScheduler,
        using generator: inout SeededRandomNumberGenerator
    ) -> (cards: [Flashcard], logs: [ReviewLog]) {
        let calendar = Calendar.current
        let days = 21
        let today = calendar.startOfDay(for: now)
        let firstMorning = (calendar.date(byAdding: .day, value: -days, to: today) ?? today).addingTimeInterval(7.5 * 3_600)
        var cards = capitals().map { card in
            var card = card
            card.review = ReviewState(due: firstMorning)
            return card
        }
        var logs: [ReviewLog] = []
        for day in 0..<days {
            var time = calendar.date(byAdding: .day, value: day, to: firstMorning) ?? firstMorning
            let end = time.addingTimeInterval(3_600)
            var newCardsLeft = 1
            // One hour of study: review whatever is due, step through learning steps as they come due.
            while time < end {
                guard let card = StudyQueue.cards(from: cards, at: time, newLimit: newCardsLeft).first,
                      let index = cards.firstIndex(where: { $0.id == card.id })
                else {
                    time.addTimeInterval(60)
                    continue
                }
                if card.review.isNew { newCardsLeft -= 1 }
                let rating = randomRating(using: &generator)
                let duration = Double.random(in: 2...9, using: &generator)
                guard let outcome = try? scheduler.review(card.review, rating: rating, at: time, duration: duration, using: &generator)
                else { break }
                cards[index].review = outcome.state
                logs.append(outcome.log)
                time.addTimeInterval(30)
            }
        }
        return (cards, logs)
    }

    private static func randomRating(using generator: inout SeededRandomNumberGenerator) -> Rating {
        switch Int.random(in: 0..<20, using: &generator) {
        case 0..<2: .again
        case 2: .hard
        case 3: .easy
        default: .good
        }
    }
}
