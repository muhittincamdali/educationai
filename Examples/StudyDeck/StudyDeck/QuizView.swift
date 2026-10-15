import EducationAI
import SwiftUI

/// A five-question quiz on the weakest cards: typed answers with hints, or multiple choice whose
/// number of choices follows a DifficultyAdjuster. Each answer is also a review of its card.
struct QuizView: View {
    enum Mode: String, CaseIterable {
        case typed = "Typed"
        case choices = "Choices"
    }

    @Environment(DeckStore.self) private var store
    @State private var mode = Mode.typed
    @State private var quiz: QuizSession?
    @State private var answer = ""
    @State private var revealedLetters = 0
    @State private var lastResult: QuizResult?
    @State private var adjuster = try! DifficultyAdjuster(levels: 1...5, startingLevel: 2, minimumAnswers: 3)
    @State private var generator = SeededRandomNumberGenerator(seed: 15)
    let answersWithTypo: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Picker("Mode", selection: $mode) {
                    ForEach(Mode.allCases, id: \.self) { Text($0.rawValue) }
                }
                .pickerStyle(.segmented)

                if let quiz, let question = displayedQuestion(in: quiz) {
                    progressHeader(quiz)
                    Text(question.prompt)
                        .font(.title2.weight(.semibold))
                        .multilineTextAlignment(.center)
                        .cardBackground()
                    if let lastResult, lastResult.questionID == question.id {
                        FeedbackView(result: lastResult, question: question)
                        Button(quiz.isComplete ? "See Score" : "Next Question") { self.lastResult = nil }
                            .buttonStyle(.borderedProminent)
                    } else {
                        answerControls(for: question)
                    }
                } else if let quiz {
                    scoreView(quiz)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Quiz")
        }
        .onAppear(perform: startIfNeeded)
        .onChange(of: mode) { start() }
    }

    /// The question being answered, or the one whose feedback is showing.
    private func displayedQuestion(in quiz: QuizSession) -> QuizQuestion? {
        if let lastResult { return quiz.questions.first { $0.id == lastResult.questionID } }
        return quiz.currentQuestion
    }

    private func progressHeader(_ quiz: QuizSession) -> some View {
        HStack {
            Text("Question \(min(quiz.results.count + (lastResult == nil ? 1 : 0), quiz.questions.count)) of \(quiz.questions.count)")
            Spacer()
            if mode == .choices { Text("Level \(adjuster.level) of 5") }
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private func answerControls(for question: QuizQuestion) -> some View {
        switch question.kind {
        case .typedAnswer(let accepted):
            VStack(spacing: 12) {
                TextField("Your answer", text: $answer)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .onSubmit { submit(.text(answer), to: question) }
                if revealedLetters > 0, let first = accepted.first {
                    Text("Hint: \(AnswerHint.masked(first, revealing: revealedLetters))")
                        .font(.body.monospaced())
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Button("Hint") { revealedLetters += 1 }
                        .buttonStyle(.bordered)
                    Button("Check") { submit(.text(answer), to: question) }
                        .buttonStyle(.borderedProminent)
                        .disabled(answer.allSatisfy(\.isWhitespace))
                }
            }
        case .multipleChoice(let choices, _):
            VStack(spacing: 10) {
                ForEach(Array(choices.enumerated()), id: \.offset) { index, choice in
                    Button { submit(.choice(index), to: question) } label: {
                        Text(choice).frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
            }
        case .trueFalse:
            EmptyView()
        }
    }

    private func scoreView(_ quiz: QuizSession) -> some View {
        VStack(spacing: 16) {
            Text(quiz.score, format: .percent.precision(.fractionLength(0)))
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .foregroundStyle(Color.studyBlue)
            Text("\(quiz.correctCount) of \(quiz.questions.count) right")
                .foregroundStyle(.secondary)
            Button("New Quiz", action: start)
                .buttonStyle(.borderedProminent)
        }
        .cardBackground()
    }

    private func submit(_ response: QuizResponse, to question: QuizQuestion) {
        guard var current = quiz, let result = try? current.answer(response, to: question.id) else { return }
        quiz = current
        lastResult = result
        answer = ""
        revealedLetters = 0
        store.review(cardID: question.id, rating: result.suggestedRating, duration: nil)
        if mode == .choices { adjuster.record(correct: result.evaluation.isAccepted) }
    }

    private func startIfNeeded() {
        guard quiz == nil else { return }
        start()
        if answersWithTypo, let question = quiz?.currentQuestion,
           case .typedAnswer(let accepted) = question.kind, var typo = accepted.first, typo.count > 4 {
            typo.remove(at: typo.index(before: typo.endIndex))
            submit(.text(typo), to: question)
        }
    }

    /// Five cards the learner is most likely to have forgotten.
    private func start() {
        let learned = store.cards.filter { !$0.review.isNew }
        let pool = learned.count >= 5 ? learned : store.cards
        let weakest = Array(pool.sorted { store.retrievability(of: $0) < store.retrievability(of: $1) }.prefix(5))
        let ids = Set(weakest.map(\.id))
        let questions: [QuizQuestion] = switch mode {
        case .typed:
            QuizBuilder.typedAnswer(from: weakest)
        case .choices:
            QuizBuilder.multipleChoice(from: store.cards, choiceCount: adjuster.level + 1, using: &generator)
                .filter { ids.contains($0.id) }
        }
        quiz = try? QuizSession(questions: questions)
        lastResult = nil
        answer = ""
        revealedLetters = 0
    }
}

private struct FeedbackView: View {
    let result: QuizResult
    let question: QuizQuestion

    var body: some View {
        VStack(spacing: 8) {
            Label(title, systemImage: symbol)
                .font(.headline)
                .foregroundStyle(result.evaluation == .incorrect ? Color.secondary : Color.studyBlue)
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .cardBackground()
    }

    private var title: String {
        switch result.evaluation {
        case .correct: "Correct"
        case .almostCorrect: "Almost"
        case .incorrect: "Not quite"
        }
    }

    private var symbol: String {
        switch result.evaluation {
        case .correct: "checkmark.circle.fill"
        case .almostCorrect: "checkmark.circle"
        case .incorrect: "xmark.circle"
        }
    }

    private var detail: String {
        var typed = ""
        if case .text(let text) = result.response { typed = "You typed \u{201C}\(text)\u{201D}. " }
        return typed + verdict
    }

    private var verdict: String {
        let rating = String(describing: result.suggestedRating).capitalized
        switch (result.evaluation, question.kind) {
        case (.almostCorrect(let expected, let typos), _):
            return "It is spelled \(expected) (\(typos == 1 ? "1 typo" : "\(typos) typos")). Scheduled as \(rating)."
        case (.incorrect, .typedAnswer(let accepted)):
            return "The answer is \(accepted.first ?? ""). Scheduled as \(rating)."
        case (.incorrect, .multipleChoice(let choices, let index)):
            return "The answer is \(choices[index]). Scheduled as \(rating)."
        default:
            return "Scheduled as \(rating)."
        }
    }
}
