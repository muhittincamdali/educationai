# Getting started

Add the package, review a card, and store its new state.

## Overview

This article builds the core loop of a flashcard app: show the cards that are due, let the
learner rate each one, and save when it comes back.

### Add the package

In Xcode, choose **File › Add Package Dependencies…**, enter
`https://github.com/muhittincamdali/educationai.git`, and add the **EducationAI** library to
your app target. In a `Package.swift`:

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

### Create a scheduler

``FSRSScheduler`` holds the settings. The defaults suit most apps: 90 % desired retention,
learning steps of 1 and 10 minutes, a relearning step of 10 minutes, and intervals spread by a
few days so that cards learned together do not all come back together.

```swift
let scheduler = try FSRSScheduler()
```

The initializer throws ``SchedulingError/invalidConfiguration(_:)`` for settings outside their
range, for example a desired retention of 1 or a negative step. With the default settings you
can also use ``FSRSScheduler/default``, which does not throw.

### Keep a review state for each card

Every item needs a ``ReviewState``. Use ``Flashcard``, which has one, or add a `ReviewState`
property to your own model. A new state is due immediately.

```swift
var deck = [
    Flashcard(front: "Capital of Japan", back: "Tokyo"),
    Flashcard(front: "Capital of Kenya", back: "Nairobi"),
    Flashcard(front: "Capital of Peru", back: "Lima")
]
```

### Pick the cards to study

``StudyQueue`` returns the due cards in the order to show them: cards in a learning step, then
due reviews, then new cards up to a daily limit.

```swift
let queue = StudyQueue.cards(from: deck, newLimit: 10)
```

### Review a card

After the learner sees the answer, preview the four outcomes to label the buttons, then keep the
one the learner picks. The preview is the review: storing `preview[rating].state` gives the same
result as calling ``FSRSScheduler/review(_:rating:at:duration:)`` with that rating.

```swift
let preview = try scheduler.preview(deck[0].review)
// Label the buttons: preview.again.interval, preview.hard.interval, ...
deck[0].review = preview[.good].state
```

### Save the deck

``Flashcard``, ``ReviewState`` and ``FSRSScheduler`` are `Codable`. Write the deck as JSON, or
store the review state in SwiftData or Core Data as one attribute.

```swift
let data = try JSONEncoder().encode(deck)
try data.write(to: URL.documentsDirectory.appending(path: "deck.json"))
```

When the file is read back, any state with values no review could have produced (NaN, negative
counts) makes the next review throw ``SchedulingError/invalidState(_:)`` rather than crash.

## Next steps

- <doc:SchedulingReviews> explains the settings, SM-2 and migration.
- <doc:BuildingQuizzes> turns the same cards into quizzes.
- <doc:TrackingProgress> adds a forecast, statistics, streaks and adaptive difficulty.
