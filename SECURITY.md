# Security policy

EducationAI runs inside apps and reads values that come from storage, sync and user input:
review states, scheduler settings, saved quizzes and typed answers. It promises that no such
value can crash the app, hang it or make it use memory without bound, and that saved data
cannot be edited to change a grade. A way around that promise is a vulnerability.

## In scope

- A value that makes the package crash (a trap on NaN, infinity, integer overflow or an index
  out of range), for example in a decoded `ReviewState`, `SM2State`, `FSRSScheduler`,
  `QuizSession`, `QuizQuestion` or `DifficultyAdjuster`, or in a date passed to any API.
- Input that makes the package hang or use time or memory out of proportion to its size: a
  typed answer, a list of accepted answers, a deck passed to `QuizBuilder` or `StudyQueue`, a
  set of dates passed to `ReviewForecast` or `StudyStreak`.
- A saved `QuizSession` that decodes with a grade different from the one its answers earn.
- An `AnswerHint` that shows characters it should hide.

Results that are wrong but harmless (an interval that differs from `py-fsrs`, a typed answer
judged differently than you expected) are bugs: report them in an issue.

## Supported versions

Security fixes are made for the latest release. 1.x is no longer maintained.

## Reporting a vulnerability

Please report vulnerabilities privately, not in a public issue, pull request or discussion.

1. **Preferred:** open the repository's **Security** tab and choose
   **Report a vulnerability** ([how private reporting works](https://docs.github.com/en/code-security/how-tos/report-and-fix-vulnerabilities/report-privately)).
2. **Or** email [muhittincamdali@gmail.com](mailto:muhittincamdali@gmail.com) with
   "Security" in the subject.

Include the version (tag or commit), the input that shows the problem (for example the JSON
that is decoded) and what happened.

## What happens next

- You get a reply within 7 days confirming that the report arrived.
- The issue is confirmed, fixed with a test that reproduces it, and released together with a
  GitHub security advisory on a disclosure date agreed with you.
- You are credited in the advisory unless you prefer not to be.
