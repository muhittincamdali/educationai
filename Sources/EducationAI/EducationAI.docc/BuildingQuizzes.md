# Building quizzes

Turn flashcards into quizzes, grade typed answers fairly, and feed the results to the scheduler.

## Overview

A quiz is a ``QuizSession``: a list of ``QuizQuestion`` values and the graded answers so far.
Questions are multiple choice, true or false, or typed answers. ``QuizBuilder`` makes them from
flashcards, and each ``QuizResult`` suggests a ``Rating`` for the card behind the question.

### Make questions from cards

```swift
var generator = SystemRandomNumberGenerator()
let choices = QuizBuilder.multipleChoice(from: deck, choiceCount: 4, using: &generator)
let typed = QuizBuilder.typedAnswer(from: deck)
```

Wrong choices are answers of other cards. Two answers that differ only in case, accents or
punctuation are never offered together, so a learner never sees "Paris" and "paris" side by
side. A card whose answer no other card differs from gets no multiple-choice question. Use a
``SeededRandomNumberGenerator`` to give everyone the same quiz.

You can also write questions yourself. The initializer checks them, as does the decoder for
questions loaded from a file:

```swift
let question = try QuizQuestion(
    id: "boiling-point",
    prompt: "Water boils at 100 °C at sea level.",
    kind: .trueFalse(answer: true),
    explanation: "At 1 atm of pressure."
)
```

### Run the quiz

```swift
var quiz = try QuizSession(questions: typed)
while let question = quiz.currentQuestion {
    let result = try quiz.answer(.text(userInput(for: question)), to: question.id, duration: 4.2)
    showFeedback(result.evaluation, explanation: question.explanation)
}
print(quiz.score)   // 0...1
```

``QuizSession/answer(_:to:duration:)`` throws for a question that does not exist, a question
already answered, or a response that does not fit, such as a choice index outside the choices.
A session is `Codable`: save it to resume later. When it is loaded, the saved answers are
graded again, so an edited file cannot mark a wrong answer as right.

### Grade typed answers

``AnswerMatcher`` decides whether typed text matches an accepted answer:

- Case, accents and width are ignored (`"sao paulo"` matches `"São Paulo"`, `"ＴＯＫＹＯ"` matches
  `"Tokyo"`), without depending on the device's language.
- Punctuation is ignored, symbols are not: `"rock n roll"` matches `"Rock 'n' Roll"`, but `"C"`
  does not match `"C++"`.
- Typos are forgiven by answer length: none up to 3 characters, 1 up to 7, 2 beyond. A swap of
  two neighboring letters counts as one typo. A fixed tolerance such as `.fixed(1)` is also
  capped below half of the answer's characters, so a two-letter answer must be typed exactly.

```swift
let matcher = AnswerMatcher(typoTolerance: .fixed(1))
switch matcher.evaluate("Nairbi", acceptedAnswers: ["Nairobi"]) {
case .correct: print("Right")
case .almostCorrect(let expected, _): print("Almost: \(expected)")
case .incorrect: print("Not quite")
}
```

Answers are user input, so the work is capped: text over 500 characters is not compared, and the
typo count is only computed close to the answer's length, so grading takes time proportional to
the answer even for long or hostile input.

### Give hints

``AnswerHint/masked(_:revealing:mask:)`` shows the shape of an answer:

```swift
AnswerHint.masked("Kathmandu", revealing: 2)   // "Ka_______"
```

Each visible character becomes one mask, including letters with combining accents and emoji
sequences, and invisible characters such as direction overrides are removed, so nothing hidden
leaks through the hint.

### Schedule from quiz results

``QuizResult/suggestedRating`` maps a wrong answer to ``Rating/again``, an answer accepted with
typos to ``Rating/hard`` and a right answer to ``Rating/good``:

```swift
if let index = deck.firstIndex(where: { $0.id == result.questionID }) {
    deck[index].review = try scheduler.review(deck[index].review, rating: result.suggestedRating).state
}
```
