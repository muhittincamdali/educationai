import EducationAI
import SwiftUI

/// Shows the due cards one by one and schedules each with the rating the learner picks.
struct ReviewView: View {
    @Environment(DeckStore.self) private var store
    @State private var preview: ReviewPreview?
    @State private var shownCardID: String?
    let startsWithAnswer: Bool

    var body: some View {
        NavigationStack {
            Group {
                if let card = store.queue.first {
                    cardView(card)
                } else {
                    ContentUnavailableView(
                        "All caught up",
                        systemImage: "checkmark.circle",
                        description: Text(nextDueText)
                    )
                }
            }
            .navigationTitle("Review")
        }
        .onAppear {
            if startsWithAnswer, let card = store.queue.first { showAnswer(for: card) }
        }
    }

    private func cardView(_ card: Flashcard) -> some View {
        VStack(spacing: 20) {
            queueSummary
            VStack(spacing: 16) {
                Text(card.front)
                    .font(.title2.weight(.semibold))
                    .multilineTextAlignment(.center)
                if shownCardID == card.id {
                    Divider()
                    Text(card.back)
                        .font(.largeTitle.bold())
                        .foregroundStyle(Color.studyBlue)
                    if !card.review.isNew {
                        Text("Memory before this review: \(store.retrievability(of: card), format: .percent.precision(.fractionLength(0)))")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(minHeight: 220)
            .cardBackground()

            if shownCardID == card.id, let preview {
                ratingButtons(card: card, preview: preview)
            } else {
                Button("Show Answer") { showAnswer(for: card) }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
            }
            Spacer()
        }
        .padding()
    }

    private var queueSummary: some View {
        let queue = store.queue
        let newCount = queue.count { $0.review.isNew }
        return HStack {
            Label("\(queue.count - newCount) to review", systemImage: "arrow.clockwise")
            Spacer()
            Label("\(newCount) new", systemImage: "sparkles")
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }

    private func ratingButtons(card: Flashcard, preview: ReviewPreview) -> some View {
        HStack(spacing: 10) {
            ForEach(Rating.allCases, id: \.self) { rating in
                Button {
                    store.apply(preview[rating], to: card.id)
                    shownCardID = nil
                    self.preview = nil
                } label: {
                    VStack(spacing: 4) {
                        Text(IntervalText.short(preview[rating].interval)).font(.caption.monospacedDigit())
                        Text(String(describing: rating).capitalized).font(.subheadline.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                }
                .buttonStyle(.bordered)
                .tint(rating == .again ? .secondary : .studyBlue)
            }
        }
    }

    private func showAnswer(for card: Flashcard) {
        preview = store.preview(for: card)
        shownCardID = card.id
    }

    private var nextDueText: String {
        guard let next = store.cards.map(\.review.due).filter({ $0 > store.now }).min() else {
            return "No cards scheduled."
        }
        return "Next card \(RelativeDateTimeFormatter().localizedString(for: next, relativeTo: store.now))."
    }
}
