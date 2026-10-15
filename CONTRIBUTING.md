# Contributing

Thanks for taking the time to improve EducationAI.

## Reporting bugs

Open an issue with:

- what you called (the type, the settings, the rating, the date) and what you got,
- what you expected, and why: for a scheduling result, the `py-fsrs` result for the same
  review history is the most useful reference,
- the platform and OS version and the Xcode version.

A value that crashes or hangs the package, or a saved quiz that decodes with a different grade,
is a security issue: report it privately as described in [SECURITY.md](SECURITY.md), not in a
public issue.

## Pull requests

1. Fork the repository and branch from `main`.
2. Keep each pull request focused on one change.
3. Run the tests on macOS and on an iOS simulator:

    ```sh
    swift test
    xcodebuild test -scheme EducationAI \
      -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
    ```

4. If you change a README code sample, change the copy in
   `Examples/StudyDeck/StudyDeck/ReadmeSamples.swift` as well. That file is what gets compiled:
   by the example app, and by `swift test` through the link
   `Tests/EducationAITests/ReadmeSamples.swift`. Build the app with:

    ```sh
    cd Examples/StudyDeck
    xcodebuild build -scheme StudyDeck -destination 'generic/platform=iOS Simulator'
    ```

5. If the example app looks different after your change, recapture the README screenshots with
   `scripts/capture-screens.sh`.
6. `README.md` has translations (`README.<language>.md`). Each one records the version of
   `README.md` it follows, and CI fails while a translation is behind. If you change `README.md`
   and cannot update the translations, say so in the pull request and they will be updated
   before it is merged.

## Where things are

| Folder | Contents |
| --- | --- |
| `Sources/EducationAI/Scheduling` | `FSRSScheduler` (settings, formulas, the state machine), `ReviewState`, `SM2Scheduler`, the SM-2 migration |
| `Sources/EducationAI/Session` | `Flashcard`, `StudyQueue`, `ReviewForecast`, `ReviewStatistics` |
| `Sources/EducationAI/Quiz` | `AnswerMatcher`, `AnswerHint`, `QuizQuestion`, `QuizSession`, `QuizBuilder` |
| `Sources/EducationAI/Adaptive`, `Progress` | `DifficultyAdjuster`, `StudyStreak` |
| `Tests/EducationAITests/Fixtures` | Reference reviews from `py-fsrs`, written by `scripts/generate-fsrs-fixtures.py` |

## Rules the code keeps

- **FSRS matches the reference.** Scheduling changes keep `FSRSReferenceTests` green. To compare
  with a newer `py-fsrs`, regenerate the fixtures (the script's header says how) and explain any
  difference in the pull request.
- **Stored values are checked before use.** Anything `Codable` is validated when decoded or
  before it is used. A new stored field needs a test with NaN, infinite, negative and huge
  values.
- **Conversions cannot trap.** A `Double` is checked for NaN, infinity and range before it
  becomes an `Int`; counters saturate instead of overflowing.
- **Work is bounded.** Code that handles user input or whole decks has a limit or runs in time
  proportional to its input, with a test at the limit.
- **Dates and randomness come from the caller.** Functions take the date they work with and,
  where randomness is involved, a generator, so tests are reproducible.

## Code style

- Follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/).
- The package builds in the Swift 6 language mode with strict concurrency; new code should not
  add warnings.
- Document public API with DocC comments (`///`).
- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)
  (`feat:`, `fix:`, `docs:`, `test:`, `refactor:`, `ci:`, `chore:`).
