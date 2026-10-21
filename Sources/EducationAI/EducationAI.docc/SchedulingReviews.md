# Scheduling reviews

Choose FSRS settings, understand the learning phases, and move SM-2 data to FSRS.

## Overview

``FSRSScheduler`` implements FSRS-6, the Free Spaced Repetition Scheduler. FSRS describes each
item's memory with two numbers: **stability**, the number of days after which the chance of
recalling the item falls to 90 %, and **difficulty**, from 1 to 10. Each review updates both
from the rating and from how long it has been since the last review, and schedules the next
review for the day recall probability reaches ``FSRSScheduler/desiredRetention``.

The formulas, defaults and parameter bounds are those of `py-fsrs` 6.3.2, the reference
implementation. The package's tests replay 2,400 reviews computed by it and compare
stability, difficulty, due date and retrievability after every review.

### Learning, review and relearning

A new item is in the ``ReviewState/Phase/learning`` phase and goes through the learning steps
(1 and 10 minutes by default):

| Rating | In a learning step |
| --- | --- |
| Again | back to the first step |
| Hard | the same step again; on the first step, halfway between the first two steps, or 1.5 times a single step |
| Good | the next step; after the last step the item graduates to the review phase |
| Easy | graduates at once |

In the ``ReviewState/Phase/review`` phase the interval is computed from stability, rounded to
whole days and capped by ``FSRSScheduler/maximumInterval``. Rating a review item **Again** counts
a lapse and moves it to ``ReviewState/Phase/relearning``, which works like learning with the
relearning steps. With no steps, items go straight to the review phase.

A review less than a day after the previous one uses FSRS's short-term formula, so a quick
second look at a card changes its stability only a little.

### Choose the settings

```swift
let scheduler = try FSRSScheduler(
    desiredRetention: 0.85,            // fewer reviews, more forgetting
    learningSteps: [60, 600, 3_600],   // 1 minute, 10 minutes, 1 hour
    relearningSteps: [600],
    maximumInterval: 365,              // never wait more than a year
    fuzzEnabled: true
)
```

- **Desired retention** is the main trade-off. With the default weights, intervals at 0.95 are
  about 40 % as long as at 0.9, and intervals at 0.8 about 3.3 times as long.
- **Weights.** ``FSRSWeights/defaults`` are trained on many learners. Weights trained for your
  own users with an FSRS optimizer (Anki's, for example) can be passed in; a 19-weight set
  from FSRS-5 is accepted and extended.
- **Fuzz** spreads intervals of three days or more by a few days. Pass a
  ``SeededRandomNumberGenerator`` to ``FSRSScheduler/review(_:rating:at:duration:using:)`` for
  results that do not change between runs, for example in tests or screenshots.

### Show retrievability

``FSRSScheduler/retrievability(of:at:)`` is the predicted chance, from 0 to 1, that the learner
remembers the item now. It is 1 right after a review and falls to about the desired retention
by the due date, which makes it a good number for a "memory strength" label.

### Replay a history

Keep the ``ReviewLog`` of each review. After changing settings, ``FSRSScheduler/replay(_:using:)``
rebuilds an item's state as if the new settings had always been used; the same works for review
histories imported from another app.

### Reset an item or undo a review

To learn an item from scratch, as Anki's **Forget** does, replace its state with
``ReviewState/reset(dueAt:keepingCounts:)``. The memory state is dropped and the next review
starts the learning steps as for a new item; pass `keepingCounts: true` to keep the review and
lapse counts for statistics. A reset leaves the item's logs alone, so replaying the whole log
would bring the old state back; replay only the reviews made after the reset.

```swift
card.review = card.review.reset(dueAt: .now)
```

Undoing a single review needs no special call: a review returns a new state and leaves the old
one unchanged, so keep the state from before the review and store it again.

### Keep SM-2 data

Apps that already store SM-2 values (easiness factor, repetitions, interval) can keep using them
with ``SM2Scheduler``, which follows the published algorithm. To switch to FSRS without losing
progress, convert each item:

```swift
let sm2 = SM2State(easeFactor: 2.3, repetitions: 5, interval: 30, due: dueDate, lastReview: lastReview)
let state = try ReviewState(migrating: sm2, scheduler: scheduler, sm2Retention: 0.9)
```

The new state keeps the item's due date. Its stability makes recall probability reach the
given retention after the SM-2 interval, and its difficulty makes the next **Good** review
grow stability by the easiness factor, so the schedule continues smoothly. This is the
conversion `fsrs-rs`, the FSRS library inside Anki, uses for cards without a full history.

### Stored values are checked

States come back from files and databases, so every review first checks the state it is given.
NaN or infinite numbers and dates, negative counts, a missing step in a learning phase or a
difficulty outside 1...10 throw ``SchedulingError/invalidState(_:)``. Counters stop at `Int.max`
and intervals are clamped before any conversion to an integer, so even extreme values cannot
crash the app.
