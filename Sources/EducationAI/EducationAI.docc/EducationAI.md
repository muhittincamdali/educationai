# ``EducationAI``

Schedule flashcard reviews with FSRS-6 or SM-2, grade quizzes and typed answers, adapt difficulty
and track study streaks, on device and without dependencies.

## Overview

EducationAI is the learning logic of a study app as plain Swift values. ``FSRSScheduler``
decides when each item comes back with FSRS-6, the memory model behind Anki's FSRS scheduler;
its results match the reference implementation, `py-fsrs` 6.3.2, review for review.
``SM2Scheduler`` keeps data from SM-2 apps working and
``ReviewState/init(migrating:scheduler:sm2Retention:)`` moves it to FSRS. ``StudyQueue`` picks
what to study now, ``AnswerMatcher`` grades typed answers with typo tolerance, ``QuizSession``
runs a quiz, ``DifficultyAdjuster`` keeps accuracy in a target band and ``StudyStreak`` counts
study days.

Every type is a `Sendable` value, every stored state is `Codable`, and every function takes the
date it works with, so results can be tested for any day. Values read back from storage are
checked before use: NaN, infinite or out-of-range values throw an error instead of crashing.

```swift
import EducationAI

let scheduler = try FSRSScheduler()
var card = Flashcard(front: "Capital of Japan", back: "Tokyo")

let preview = try scheduler.preview(card.review)
print(preview.good.interval)        // 600.0 seconds: the second learning step
card.review = preview.good.state    // the learner chose Good
```

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:SchedulingReviews>
- <doc:BuildingQuizzes>
- <doc:TrackingProgress>

### Scheduling with FSRS

- ``FSRSScheduler``
- ``FSRSWeights``
- ``ReviewState``
- ``Rating``
- ``ReviewOutcome``
- ``ReviewPreview``
- ``ReviewLog``
- ``SchedulingError``

### Scheduling with SM-2

- ``SM2Scheduler``
- ``SM2State``

### Study sessions

- ``Flashcard``
- ``StudyQueue``
- ``ReviewForecast``
- ``ReviewStatistics``

### Quizzes and typed answers

- ``QuizSession``
- ``QuizQuestion``
- ``QuizResponse``
- ``QuizResult``
- ``QuizBuilder``
- ``QuizError``
- ``AnswerMatcher``
- ``AnswerEvaluation``
- ``AnswerHint``

### Adapting and motivating

- ``DifficultyAdjuster``
- ``AdaptiveError``
- ``StudyStreak``

### Reproducible randomness

- ``SeededRandomNumberGenerator``
