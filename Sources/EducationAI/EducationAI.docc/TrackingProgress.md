# Tracking progress

Show the coming workload, summarize reviews, count study streaks and adapt difficulty.

## Overview

The types in this article read the data a study app already has (due dates, review logs,
answers) and compute what a progress screen shows. They take the current date and a calendar,
so a test can check them for any day and time zone.

### Forecast the workload

``ReviewForecast`` counts how many items come due on each of the next days:

```swift
let forecast = ReviewForecast(dueDates: deck.map(\.review.due), days: 14)
for day in forecast.days {
    print(day.date.formatted(date: .abbreviated, time: .omitted), day.count)
}
```

The first day includes everything overdue; ``ReviewForecast/overdueCount`` says how much of it
was due before today. The days array plugs straight into a Swift Charts `BarMark`.

### Summarize reviews

Keep each review's ``ReviewLog`` and summarize any period:

```swift
let today = logs.filter { Calendar.current.isDateInToday($0.reviewedAt) }
let stats = ReviewStatistics(logs: today)
print(stats.reviewCount, stats.ratingCounts[.again] ?? 0, stats.retention ?? 0)
```

``ReviewStatistics/retention`` is the share of review-phase items the learner remembered. Over
a few weeks it should be close to the scheduler's desired retention. When it stays well below,
the default weights may not fit the learner, and weights trained on their own reviews help.

### Count streaks

```swift
let streak = StudyStreak(activityDates: logs.map(\.reviewedAt))
Text("\(streak.current)-day streak")
```

Days follow the calendar's time zone, so reviews at 23:50 and 00:10 count as two days, and
daylight saving changes do not break a streak. A streak stays alive until a whole day passes
without study, so "study today to keep your streak" is `streak.current > 0 && !streak.studiedToday`.

### Adapt difficulty

For practice that is not scheduled (drills, games, placement tests), ``DifficultyAdjuster``
keeps the learner's accuracy inside a target band:

```swift
var adjuster = try DifficultyAdjuster(levels: 1...5, targetAccuracy: 0.70...0.85)
switch adjuster.record(correct: answerWasRight) {
case .raised: print("Level up: \(adjuster.level)")
case .lowered: print("Easier questions for a while")
case .unchanged: break
}
```

The level moves one step when accuracy over the last answers (10 by default, at least 5 before
any change) leaves the band, and the window starts over after each change. The adjuster is
`Codable`; a saved adjuster whose level or window does not fit its settings fails to decode
instead of producing an impossible level.
