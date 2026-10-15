<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-light.svg" alt="EducationAI: Spaced repetition with FSRS-6 and SM-2, quizzes, adaptive difficulty and study streaks for Swift apps."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml/badge.svg" alt="CI status"></a>
<a href="https://github.com/muhittincamdali/educationai/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg" alt="Latest version: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg" alt="Supported platforms: iOS 17+ · macOS 14+ · tvOS 17+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg" alt="Language version: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg" alt="License: MIT"></picture></a>
</p>

<p align="center">
<a href="#quick-start"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-en-light.svg" alt="Get started"></picture></a>
<a href="https://muhittincamdali.github.io/educationai/documentation/educationai/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-en-light.svg" alt="Documentation"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-en-light.svg" alt="Examples"></picture></a>
</p>

<!-- brand:end -->

A Swift package with the learning logic of a flashcard or study app. `FSRSScheduler` decides
when each card comes back with FSRS-6, the memory model behind Anki's FSRS scheduler, and gives
the same results as the reference implementation, `py-fsrs` 6.3.2. `SM2Scheduler` keeps SM-2
data working and converts it to FSRS without losing progress. Around the scheduler there is a
study queue, typed-answer grading with typo tolerance, quizzes, a difficulty adjuster, a
workload forecast, review statistics and study streaks. Everything runs on the device, has no
dependencies, and is written for Swift 6 strict concurrency.

<p align="center">
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/review-dark.png"><img src="docs/images/review-light.png" width="300" alt="The review screen of the example app: the card Capital of Vietnam with its answer Hanoi, memory at 90 %, and four rating buttons labeled 10m Again, 1mo Hard, 2mo Good and 3mo Easy"></picture>
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/quiz-dark.png"><img src="docs/images/quiz-light.png" width="300" alt="A typed-answer quiz question, Capital of Morocco, answered Raba: the feedback says Almost, it is spelled Rabat with one typo, and the card is scheduled as Hard"></picture>
</p>

## Highlights

- **FSRS-6, checked against the reference** — the tests replay 2,400 reviews computed by
  `py-fsrs` 6.3.2 over eight configurations and compare stability, difficulty, due date and
  retrievability after every review. Learning and relearning steps, desired retention, maximum
  interval, interval fuzz and custom weights (21 from FSRS-6 or 19 from FSRS-5) are supported.
- **Values, not services** — schedulers, states, quizzes and adjusters are `Sendable`,
  `Codable` value types. Every function takes the date it works with, and randomness comes from
  a generator you can seed, so results can be tested for any day.
- **Safe with stored data** — states read back from a file or a database are checked before use.
  NaN, infinite or negative values throw an error instead of crashing, counters stop at
  `Int.max`, and a saved quiz is graded again when it is loaded.
- **Fair typed answers** — `AnswerMatcher` ignores case, accents, width and punctuation without
  depending on the device language, forgives typos by answer length, and does work proportional
  to the answer's length, even for hostile input.
- **Everything around the scheduler** — a study queue with daily limits, SM-2 and its migration
  to FSRS, multiple-choice and typed quizzes built from cards, answer hints, a difficulty
  adjuster, a per-day forecast, retention statistics and streaks in the learner's time zone.
- **Tested** — 124 tests, run on macOS and on an iOS simulator, including the README samples.

## Quick start

**1. Add the package**

In Xcode, choose **File › Add Package Dependencies…** and enter the repository URL:

```text
https://github.com/muhittincamdali/educationai.git
```

Paste it into the search field at the top right of the window. Leave **Dependency Rule** at
**Up to Next Major Version** from `2.0.0`, then click **Add Package**. In the next window, choose
your app target next to **EducationAI** and click **Add Package** again.

**2. Import the module**

```swift
import EducationAI
```

Put this line at the top of the Swift file where you will show the cards, below `import SwiftUI`.

**3. Show cards and rate them**

Add this view to the file and show it from your app, for example as the content of your
`WindowGroup`:

```swift
struct FlashcardsView: View {
    @State private var cards = [
        Flashcard(front: "Capital of Japan", back: "Tokyo"),
        Flashcard(front: "Capital of Kenya", back: "Nairobi"),
        Flashcard(front: "Capital of Peru", back: "Lima")
    ]
    @State private var showsAnswer = false
    private let scheduler = FSRSScheduler.default

    var body: some View {
        if let card = StudyQueue.cards(from: cards).first,
           let index = cards.firstIndex(where: { $0.id == card.id }) {
            VStack(spacing: 24) {
                Text(card.front).font(.title)
                if showsAnswer {
                    Text(card.back).font(.title2).bold()
                    HStack {
                        ForEach(Rating.allCases, id: \.self) { rating in
                            Button(String(describing: rating).capitalized) {
                                if let outcome = try? scheduler.review(card.review, rating: rating) {
                                    cards[index].review = outcome.state
                                }
                                showsAnswer = false
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                } else {
                    Button("Show Answer") { showsAnswer = true }
                        .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        } else {
            Text("All done for now")
        }
    }
}
```

Run the app. It shows **Capital of Japan**; tap **Show Answer**, then **Good**. The card moves to
its 10-minute learning step and **Capital of Kenya** appears. When all three are rated, the view
says **All done for now**. The cards live in `@State` here, so they start over on the next
launch; [Save the deck](#save-the-deck) below shows how to keep them.

## Installation

### Swift Package Manager

In Xcode, choose **File › Add Package Dependencies…** and enter the repository URL:

```text
https://github.com/muhittincamdali/educationai.git
```

Or add it to the `dependencies` in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/educationai.git", from: "2.0.0")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "EducationAI", package: "educationai")
    ])
]
```

## Usage

The samples below are copied from
[ReadmeSamples.swift](Examples/StudyDeck/StudyDeck/ReadmeSamples.swift), which the example app
and the test suite compile, and which the tests run.

### Show the next interval on each button

A preview gives the outcome of all four ratings. Label the buttons with it, and store the
outcome of the one the learner taps: it is the same result a review with that rating gives.

```swift
func buttonLabels(for card: Flashcard, scheduler: FSRSScheduler) throws -> [String] {
    let preview = try scheduler.preview(card.review)
    let format = Duration.UnitsFormatStyle(allowedUnits: [.days, .hours, .minutes], width: .narrow, maximumUnitCount: 1)
    return Rating.allCases.map { rating in
        let interval = Duration.seconds(preview[rating].interval)
        return "\(String(describing: rating).capitalized) · \(interval.formatted(format))"
    }
}
```

In English this gives `Again · 1m`, `Hard · 6m` and `Good · 10m` for a new card, and about a
week for `Easy` (fuzz spreads the exact day).

### Choose the settings

Higher retention means shorter intervals and more reviews. Settings out of range throw:

```swift
func makeScheduler() throws -> FSRSScheduler {
    try FSRSScheduler(
        desiredRetention: 0.85,
        learningSteps: [60, 600, 3_600],
        relearningSteps: [600],
        maximumInterval: 365
    )
}
```

### Grade a typed answer

```swift
func feedback(for answer: String, card: Flashcard) -> String {
    switch AnswerMatcher().evaluate(answer, acceptedAnswers: card.acceptedAnswers) {
    case .correct: "Correct"
    case .almostCorrect(let expected, _): "Almost: it is spelled \(expected)"
    case .incorrect: "The answer is \(card.back)"
    }
}
```

`"nairobi"` is correct for `Nairobi`, `"Nairbi"` is almost correct (one typo), `"Mombasa"` is
not. Accents, case and punctuation are ignored: `"Sao Paulo"` matches `"São Paulo"`.

### Run a quiz and schedule from the results

```swift
func quizAndReschedule(deck: inout [Flashcard], answers: [String: String], at date: Date) throws -> Double {
    var quiz = try QuizSession(questions: QuizBuilder.typedAnswer(from: deck))
    while let question = quiz.currentQuestion {
        let result = try quiz.answer(.text(answers[question.id] ?? ""), to: question.id)
        if let index = deck.firstIndex(where: { $0.id == result.questionID }) {
            deck[index].review = try FSRSScheduler.default.review(deck[index].review, rating: result.suggestedRating, at: date).state
        }
    }
    return quiz.score
}
```

A wrong answer is scheduled as **Again**, an answer with typos as **Hard**, a right one as
**Good**. `QuizBuilder.multipleChoice(from:choiceCount:using:)` makes multiple-choice questions
whose wrong choices are other cards' answers.

### Move SM-2 data to FSRS

```swift
func migrate(easeFactor: Double, intervalDays: Int, due: Date, lastReview: Date) throws -> ReviewState {
    let sm2 = SM2State(easeFactor: easeFactor, repetitions: 4, interval: intervalDays, due: due, lastReview: lastReview)
    return try ReviewState(migrating: sm2, scheduler: .default)
}
```

The card keeps its due date, and its next good review grows the interval by about its old
easiness factor.

### Show progress

```swift
func progressSummary(deck: [Flashcard], logs: [ReviewLog], now: Date) -> String {
    let streak = StudyStreak(activityDates: logs.map(\.reviewedAt), now: now)
    let forecast = ReviewForecast(dueDates: deck.map(\.review.due), from: now, days: 7)
    let retention = ReviewStatistics(logs: logs).retention ?? 0
    return "\(streak.current)-day streak, \(forecast.days[0].count) due today, "
        + "\(forecast.totalCount) this week, \(Int((retention * 100).rounded())) % retained"
}
```

Each review returns a `ReviewLog` next to the new state (`outcome.log`); keep the logs for
statistics and streaks.

### Save the deck

`Flashcard`, `ReviewState`, `ReviewLog`, `FSRSScheduler` and `QuizSession` are `Codable`, so a
deck fits in a JSON file, for example at `URL.documentsDirectory.appending(path: "deck.json")`:

```swift
func save(_ deck: [Flashcard], to url: URL) throws {
    try JSONEncoder().encode(deck).write(to: url, options: .atomic)
}

func loadDeck(from url: URL) throws -> [Flashcard] {
    try JSONDecoder().decode([Flashcard].self, from: Data(contentsOf: url))
}
```

A state in the file that no review could have produced (NaN, a negative count) makes its next
review throw `SchedulingError.invalidState` instead of crashing the app.

To keep your own model, add a `ReviewState` property to it (it is a single `Codable` value, so it
fits a SwiftData attribute) and use `StudyQueue.items(from:at:newLimit:reviewLimit:state:)`.

## Demo

<table>
<tr>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/progress-dark.png"><img src="docs/images/progress-light.png" width="260" alt="The progress screen: a 21-day streak, best streak 21, retention 91 %, 84 reviews, and a bar chart of the cards due on each of the next 14 days"></picture></td>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/deck-dark.png"><img src="docs/images/deck-light.png" width="260" alt="The deck list: each capital with its country, when it is due and how well it is remembered now, such as Hanoi due now at 90 %"></picture></td>
</tr>
</table>

The screenshots come from the [example app](Examples) on an iPhone 17 Pro simulator with iOS 27,
captured by [`scripts/capture-screens.sh`](scripts/capture-screens.sh). The app runs in demo mode
with three weeks of simulated study from a fixed seed, so every capture shows the same cards.
To run it, open `Examples/StudyDeck/StudyDeck.xcodeproj`, choose an iPhone simulator or
**My Mac**, and run.

## Documentation

Reference documentation and articles:

- [API reference](https://muhittincamdali.github.io/educationai/documentation/educationai/)
  — every public type with its parameters and limits.

## Guides

- [Getting started](https://muhittincamdali.github.io/educationai/documentation/educationai/gettingstarted)
  — add the package, keep a review state per card, queue, review, save.
- [Scheduling reviews](https://muhittincamdali.github.io/educationai/documentation/educationai/schedulingreviews)
  — how FSRS works, the learning phases, settings and their trade-offs, SM-2 and migration.
- [Building quizzes](https://muhittincamdali.github.io/educationai/documentation/educationai/buildingquizzes)
  — questions from cards, quiz sessions, what typed-answer grading forgives, hints.
- [Tracking progress](https://muhittincamdali.github.io/educationai/documentation/educationai/trackingprogress)
  — forecast, statistics, streaks and adaptive difficulty.

## Requirements

| Platform | Minimum version |
| ------------------- | ------------------ |
| iOS | 17 |
| macOS | 14 |
| tvOS | 17 |
| watchOS | 10 |
| visionOS | 1 |
| Toolchain | Swift 6.2 · Xcode 26+ |

The package uses only Foundation. The example app is for iOS and macOS.

## Architecture

```text
               Flashcard / your model ── ReviewState (Codable)
                          │
StudyQueue ──► what to study now
                          │
FSRSScheduler ──► review / preview ──► ReviewOutcome (new ReviewState + ReviewLog)
SM2Scheduler ───► SM2State ──► ReviewState(migrating:)
                          │
QuizBuilder ──► QuizSession ──► AnswerMatcher / AnswerHint ──► QuizResult.suggestedRating
                          │
ReviewLog[] ──► ReviewStatistics · StudyStreak        due dates ──► ReviewForecast
answers ──► DifficultyAdjuster
```

- `FSRSScheduler` is split into its settings (`FSRSScheduler.swift`), the FSRS-6 formulas
  written to follow `py-fsrs` operation by operation (`+Formulas`), and the state machine with
  the checks on stored values (`+Transition`).
- Nothing holds a reference or a lock: each call takes values and returns values, so the types
  can be used from any thread or actor, and stored in SwiftData, Core Data, files or iCloud.
- Limits are explicit: answers over 500 characters are not compared, forecasts cover at most
  3,650 days, adjuster windows hold at most 1,000 answers, and quiz building samples wrong
  choices with a fixed number of draws.

## Roadmap

Planned, in no fixed order: training FSRS weights from a learner's review logs (an optimizer,
as `py-fsrs` and `fsrs-rs` have), FSRS-7 once the reference implementations adopt it for
scheduling, importing Anki review logs, and load balancing of due dates across days.
Suggestions are welcome in [issues](https://github.com/muhittincamdali/educationai/issues).

## Contributing

Contributions are welcome. Read the [contributing guide](https://github.com/muhittincamdali/educationai/blob/main/CONTRIBUTING.md) and the [code of conduct](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) before opening a pull request. Report security issues privately as described in the [security policy](https://github.com/muhittincamdali/educationai/blob/main/SECURITY.md).

## License

Released under the MIT license. See [LICENSE](LICENSE).
