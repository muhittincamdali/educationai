# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.1.0] - 2026-10-21

### Added

- `ReviewState.reset(dueAt:keepingCounts:)` turns an item into a new one again, for a "forget"
  action: the next review starts the learning steps as for a card never seen. The review and
  lapse counts can be kept for statistics. The "Scheduling reviews" article explains it and
  how to undo a single review by keeping the previous state.

### Fixed

- `ReviewState(migrating:scheduler:sm2Retention:)` no longer throws for an SM-2 state with an
  easiness factor near `Double.greatestFiniteMagnitude`, which `SM2Scheduler` reviews without
  complaint. The difficulty formula overflows to minus infinity there; it is now clamped to the
  easiest difficulty, 1, like every other out-of-range difficulty.

## [2.0.0] - 2026-10-15

A new package with a new API: the learning logic of a flashcard or study app, centered on an
FSRS-6 scheduler that matches the reference implementation. The code on `main` before this
release (an SM-2 scheduler, quiz, progress, recommendation and gamification engines built on
lock-guarded classes) read the clock itself, converted intervals with `Int(days * 86_400)`,
which traps on NaN or large stored values, and treated a "hard" answer as a lapse. In June 2026
it also gained a dependency on a local folder (`../SwiftAI`), so the package no longer resolved
for anyone else, and placeholder "neural tutor" and "enterprise" types. None of that is kept.
Because every public name changes, this release is a new major version.

### Added

- `FSRSScheduler`: FSRS-6 with learning and relearning steps, desired retention, maximum
  interval, interval fuzz and custom weights (21 from FSRS-6, or 19 from FSRS-5 extended as
  `ts-fsrs` does). `review`, `preview` (the outcome of all four ratings), `retrievability` and
  `replay` (rebuild a state from logs). Results match `py-fsrs` 6.3.2; the tests compare 2,400
  reviews over eight configurations. `FSRSScheduler.default` gives the default settings
  without a throwing call.
- `ReviewState`, `ReviewLog`, `ReviewOutcome`, `ReviewPreview`, `Rating` and `FSRSWeights`.
- `SM2Scheduler` and `SM2State`: SM-2 as published (qualities 0–5, 1 and 6 days, then the
  interval times the easiness factor), and `ReviewState(migrating:scheduler:sm2Retention:)`,
  the conversion `fsrs-rs` uses to move SM-2 cards to FSRS.
- `Flashcard`, `StudyQueue` (learning steps, then due reviews, then new cards, with daily
  limits), `ReviewForecast` (items due per calendar day, up to 3,650 days) and
  `ReviewStatistics` (counts per rating, true retention, mean answer time).
- `AnswerMatcher` (case, accent, width and punctuation folding without a locale; typo
  tolerance by answer length, and a fixed tolerance that stays below half of the answer) and `AnswerHint` (masks whole grapheme clusters and drops
  invisible characters).
- `QuizQuestion`, `QuizSession`, `QuizResult` with a suggested rating, and `QuizBuilder` for
  multiple-choice and typed questions from flashcards. A typed question needs an accepted
  answer that the session's matcher can match.
- `DifficultyAdjuster`, which keeps accuracy inside a target band, and `StudyStreak`, which
  counts consecutive study days in the learner's calendar.
- `SeededRandomNumberGenerator` for reproducible fuzz and quiz order.
- A DocC catalog with four articles, the StudyDeck example app for iOS and macOS, and README
  samples that the tests compile and run.

### Security

- Values read back from storage are checked before use. NaN or infinite numbers and dates,
  negative counts, steps that do not fit the phase, out-of-range settings, invalid quiz
  questions and adjuster states throw an error instead of trapping. Counters saturate at
  `Int.max`, intervals are clamped before any conversion to an integer, and stability is kept
  between 0.001 and 10^10 days, so a huge stored value cannot grow to infinity.
- Saved quiz sessions are graded again when decoded, so an edited file cannot mark a wrong
  answer as right. Questions are looked up by identifier, so resuming a quiz takes time
  proportional to its size.
- Work on user input is bounded: typed answers over 32,000 bytes or 500 characters are not
  compared, the typo count is computed in a band around the diagonal, quiz building samples
  wrong choices with a fixed number of draws, and calendar arithmetic skips dates far outside
  the requested range.

### Changed

- Requires Swift 6.2 (Xcode 26) and iOS 17, macOS 14, tvOS 17, watchOS 10 or visionOS 1.
- CI runs on the shared workflows of `muhittincamdali/.github`: SwiftPM build and tests,
  xcodebuild for five platforms, tests on an iOS simulator, DocC on GitHub Pages, links, wording
  and README translations.

### Removed

- Every 1.x type: `EducationAI`, `EducationAIConfiguration`, `Flashcard`'s SM-2 fields,
  `SpacedRepetitionScheduler`, `SM2Parameters`, `QuizEngine`, `AdaptiveDifficultyEngine`,
  `ProgressTracker`, `RecommendationEngine`, `GamificationEngine`, `LocalStorage`,
  `AdaptiveNeuralTutor` and the circuit breaker, retry policy, event bus, metrics collector
  and error handler.

## [1.0.0] - 2025-08-07

First tagged release: an `EducationAI` class with learning models and basic tests, depending on
Alamofire, RxSwift, SnapKit and SDWebImage.

[Unreleased]: https://github.com/muhittincamdali/educationai/compare/v2.1.0...HEAD
[2.1.0]: https://github.com/muhittincamdali/educationai/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/muhittincamdali/educationai/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/muhittincamdali/educationai/releases/tag/v1.0.0
