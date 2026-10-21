import Charts
import EducationAI
import SwiftUI

/// Streak, retention and the reviews due over the next two weeks.
struct StatsView: View {
    @Environment(DeckStore.self) private var store

    var body: some View {
        let streak = StudyStreak(activityDates: store.logs.map(\.reviewedAt), now: store.now)
        let stats = ReviewStatistics(logs: store.logs)
        let forecast = ReviewForecast(dueDates: store.cards.filter { !$0.review.isNew }.map(\.review.due), from: store.now, days: 14)

        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        tile(value: "\(streak.current)", label: "day streak", symbol: "flame.fill")
                        tile(value: "\(streak.longest)", label: "best streak", symbol: "trophy.fill")
                    }
                    HStack(spacing: 16) {
                        tile(
                            value: stats.retention.map { $0.formatted(.percent.precision(.fractionLength(0))) } ?? "–",
                            label: "retention",
                            symbol: "brain.head.profile"
                        )
                        tile(value: "\(stats.reviewCount)", label: "reviews", symbol: "rectangle.stack.fill")
                    }
                    forecastChart(forecast)
                    if streak.current > 0 && !streak.studiedToday {
                        Label("Study today to keep your \(streak.current)-day streak.", systemImage: "calendar.badge.clock")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Progress")
        }
    }

    private func tile(value: String, label: String, symbol: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: symbol).foregroundStyle(Color.studyBlue)
            Text(value).font(.system(.title, design: .rounded).weight(.bold))
            Text(label).font(.subheadline).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground()
    }

    private func forecastChart(_ forecast: ReviewForecast) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Due in the next 14 days").font(.headline)
            Chart(forecast.days, id: \.date) { day in
                BarMark(
                    x: .value("Day", day.date, unit: .day),
                    y: .value("Cards", day.count)
                )
                .foregroundStyle(Color.studyBlue.gradient)
                .cornerRadius(4)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 3)) { _ in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                }
            }
            .frame(height: 180)
            Text("\(forecast.totalCount) reviews, \(forecast.overdueCount) overdue")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .cardBackground()
    }
}

/// Every card with its next review and how well it is remembered now.
struct DeckListView: View {
    @Environment(DeckStore.self) private var store

    var body: some View {
        NavigationStack {
            // Studied cards by due date, then the cards not studied yet.
            List(store.cards.sorted { ($0.review.isNew ? 1 : 0, $0.review.due) < ($1.review.isNew ? 1 : 0, $1.review.due) }) { card in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(card.back).font(.body.weight(.semibold))
                        Text(card.front).font(.footnote).foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(dueText(card)).font(.footnote)
                        if !card.review.isNew {
                            Text(store.retrievability(of: card), format: .percent.precision(.fractionLength(0)))
                                .font(.caption.monospacedDigit())
                                .foregroundStyle(Color.studyBlue)
                        }
                    }
                }
                .swipeActions {
                    if !card.review.isNew {
                        Button("Reset", role: .destructive) { store.reset(cardID: card.id) }
                    }
                }
            }
            .navigationTitle("Deck")
        }
    }

    private func dueText(_ card: Flashcard) -> String {
        if card.review.isNew { return "New" }
        if card.review.due <= store.now { return "Due now" }
        return "Due in " + IntervalText.short(card.review.due.timeIntervalSince(store.now))
    }
}
