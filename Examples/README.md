# Examples

## StudyDeck

A SwiftUI flashcard app for iOS 17+ and macOS 14+ built on EducationAI. It has 30 cards (world
capitals) and four tabs:

- **Review** shows the due cards one at a time. After **Show Answer**, each rating button shows
  the interval it would schedule, from `FSRSScheduler.preview(_:at:using:)`, and tapping one
  stores that outcome.
- **Quiz** asks about the five cards the learner is most likely to have forgotten (lowest
  retrievability). **Typed** grades answers with `AnswerMatcher` and offers hints from
  `AnswerHint`; **Choices** builds multiple-choice questions with `QuizBuilder`, with 2 to 6
  choices set by a `DifficultyAdjuster`. Every answer is also a review of its card, rated with
  `QuizResult.suggestedRating`.
- **Progress** shows the `StudyStreak`, the retention from `ReviewStatistics` and a Swift Charts
  bar chart of the `ReviewForecast` for 14 days.
- **Deck** lists every card with its due date and current retrievability.

The deck and the review log are saved as JSON in Application Support after every review. The
app uses the package from this repository (`path: ../..`), so it always builds against the
current sources. CI builds it for iOS and macOS on every push.

### Run it

1. Open `StudyDeck/StudyDeck.xcodeproj` in Xcode 26 or later.
2. Choose the **StudyDeck** scheme and an iPhone simulator or **My Mac**.
3. Press **Run**. The first launch starts with the sample deck, all cards new.

### Files

| File | What it shows |
| --- | --- |
| [DeckStore.swift](StudyDeck/StudyDeck/DeckStore.swift) | An `@Observable` model that keeps the cards, the logs and the scheduler, previews and applies reviews, and saves to JSON |
| [ReviewView.swift](StudyDeck/StudyDeck/ReviewView.swift) | The review loop with interval labels on the rating buttons |
| [QuizView.swift](StudyDeck/StudyDeck/QuizView.swift) | Typed and multiple-choice quizzes, hints, adaptive choice count, scheduling from results |
| [StatsView.swift](StudyDeck/StudyDeck/StatsView.swift) | Streak, retention and the forecast chart; the deck list |
| [SampleDeck.swift](StudyDeck/StudyDeck/SampleDeck.swift) | The sample cards and the simulated history used by demo mode |
| [ReadmeSamples.swift](StudyDeck/StudyDeck/ReadmeSamples.swift) | The code samples in the README. `swift test` compiles and runs them too, through a link in `Tests/` |

### Launch arguments

[`scripts/capture-screens.sh`](../scripts/capture-screens.sh) uses these to open a screen in a
known state without tapping:

| Argument | Effect |
| --- | --- |
| `-demo` | Loads three weeks of simulated study (seeded, so every run is the same) ending at 09:41 on 15 October 2026; nothing is saved |
| `-tab review`, `-tab quiz`, `-tab progress`, `-tab deck` | Opens that tab |
| `-show-answer` | Starts the review screen with the first card's answer shown |
| `-quiz-typo` | Answers the first quiz question with its last letter missing |

### Regenerate the project

The Xcode project is generated from [`project.yml`](StudyDeck/project.yml) with
[XcodeGen](https://github.com/yonaskolb/XcodeGen). After changing `project.yml`, run `xcodegen`
in `Examples/StudyDeck`.
