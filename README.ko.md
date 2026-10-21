<!-- i18n-source: README.md@f9244ae8b5ee36d676748f903909a5d507c7a923 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-ko-light.svg" alt="EducationAI: Swift 앱을 위한 FSRS-6·SM-2 간격 반복, 퀴즈, 적응형 난이도, 연속 학습 기록."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml/badge.svg" alt="CI 상태"></a>
<a href="https://github.com/muhittincamdali/educationai/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg" alt="최신 버전: v2.1.0"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg" alt="지원 플랫폼: iOS 17+ · macOS 14+ · tvOS 17+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg" alt="언어 버전: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg" alt="라이선스: MIT"></picture></a>
</p>

<p align="center">
<a href="#빠른-시작"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-ko-light.svg" alt="시작하기"></picture></a>
<a href="https://muhittincamdali.github.io/educationai/documentation/educationai/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-ko-light.svg" alt="문서"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-ko-light.svg" alt="예제"></picture></a>
</p>

> 이 문서는 영어 README의 번역본입니다. 내용이 다를 경우 영어 버전이 최신입니다.

<!-- brand:end -->

플래시카드나 학습 앱의 학습 로직을 담은 Swift 패키지입니다. `FSRSScheduler`는 Anki의 FSRS 스케줄러에 쓰이는 기억 모델인 FSRS-6으로 각 카드가 언제 다시 나올지 결정하며, 참조 구현인 `py-fsrs` 6.3.2와 같은 결과를 냅니다. `SM2Scheduler`는 SM-2 데이터를 그대로 사용할 수 있게 하고, 진행 상황을 잃지 않고 FSRS로 변환합니다. 스케줄러 주변에는 학습 큐, 오타를 허용하는 입력형 답안 채점, 퀴즈, 난이도 조절기, 학습량 예측, 복습 통계, 연속 학습 기록이 있습니다. 모든 것이 기기에서 실행되고, 의존성이 없으며, Swift 6 strict concurrency에 맞춰 작성되었습니다.

<p align="center">
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/review-dark.png"><img src="docs/images/review-light.png" width="300" alt="예제 앱의 복습 화면: Capital of Vietnam 카드와 정답 Hanoi, 기억률 90%, 10m Again, 1mo Hard, 2mo Good, 3mo Easy라고 적힌 평가 버튼 네 개"></picture>
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/quiz-dark.png"><img src="docs/images/quiz-light.png" width="300" alt="입력형 퀴즈 문제 Capital of Morocco에 Raba라고 답한 화면: 피드백은 &quot;Almost, it is spelled Rabat&quot;(오타 하나)이며 카드는 Hard로 예약됩니다"></picture>
</p>

## 주요 기능

- **참조 구현과 대조한 FSRS-6** — 테스트는 `py-fsrs` 6.3.2가 계산한 2,400번의 복습을 여덟 가지 설정으로 재현하고, 복습할 때마다 stability, difficulty, 기한, retrievability를 비교합니다. 학습·재학습 단계, 목표 기억률, 최대 간격, 간격 fuzz, 사용자 지정 가중치(FSRS-6의 21개 또는 FSRS-5의 19개)를 지원합니다.
- **서비스가 아니라 값** — 스케줄러, 상태, 퀴즈, 조절기는 모두 `Sendable`이고 `Codable`인 값 타입입니다. 모든 함수는 작업 기준이 되는 날짜를 인자로 받고, 무작위성은 seed를 지정할 수 있는 생성기에서 나오므로 어떤 날짜에 대해서도 결과를 테스트할 수 있습니다.
- **저장된 데이터에도 안전** — 파일이나 데이터베이스에서 다시 읽은 상태는 사용하기 전에 검사합니다. NaN, 무한대, 음수 값은 크래시 대신 오류를 던지고, 카운터는 `Int.max`에서 멈추며, 저장된 퀴즈는 불러올 때 다시 채점됩니다.
- **공정한 입력형 답안 채점** — `AnswerMatcher`는 기기 언어와 상관없이 대소문자, 악센트, 문자 너비, 문장 부호를 무시하고, 답안 길이에 따라 오타를 허용하며, 악의적인 입력에서도 답안 길이에 비례하는 만큼만 작업합니다.
- **스케줄러 주변의 모든 것** — 일일 한도가 있는 학습 큐, SM-2와 FSRS로의 이전, 카드에서 만드는 객관식·입력형 퀴즈, 답안 힌트, 난이도 조절기, 하루 단위 예측, 기억률 통계, 학습자의 시간대를 기준으로 한 연속 학습 기록.
- **테스트됨** — README 예제를 포함한 127개의 테스트를 macOS와 iOS 시뮬레이터에서 실행합니다.

## 빠른 시작

**1. 패키지 추가**

Xcode에서 **File › Add Package Dependencies…**를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/educationai.git
```

창 오른쪽 위의 검색란에 붙여 넣으세요. **Dependency Rule**은 `2.0.0`부터의 **Up to Next Major Version**으로 두고 **Add Package**를 클릭하세요. 다음 창에서 **EducationAI** 옆에 앱 타깃을 선택하고 **Add Package**를 다시 클릭하세요.

**2. 모듈 가져오기**

```swift
import EducationAI
```

이 줄은 카드를 보여 줄 Swift 파일의 맨 위, `import SwiftUI` 아래에 넣으세요.

**3. 카드를 표시하고 평가하기**

이 뷰를 파일에 추가하고 앱에서 표시하세요. 예를 들어 `WindowGroup`의 콘텐츠로 사용할 수 있습니다.

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

앱을 실행하면 **Capital of Japan**이 표시됩니다. **Show Answer**를 탭한 다음 **Good**을 탭하세요. 카드는 10분 학습 단계로 넘어가고 **Capital of Kenya**가 나타납니다. 세 장을 모두 평가하면 뷰에 **All done for now**가 표시됩니다. 여기서는 카드가 `@State`에 있으므로 다음 실행 때 처음부터 다시 시작합니다. 카드를 보관하는 방법은 아래 [덱 저장하기](#덱-저장하기)에서 설명합니다.

## 설치

### Swift Package Manager

Xcode에서 **File › Add Package Dependencies…**를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/educationai.git
```

또는 `Package.swift`의 `dependencies`에 추가하세요.

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

## 사용법

아래 예제는 [ReadmeSamples.swift](Examples/StudyDeck/StudyDeck/ReadmeSamples.swift)에서 가져왔습니다. 이 파일은 예제 앱과 테스트 스위트가 컴파일하고, 테스트가 실행합니다.

### 버튼마다 다음 간격 표시하기

미리 보기는 네 가지 평가 각각의 결과를 알려 줍니다. 이를 버튼 라벨에 사용하고, 학습자가 탭한 평가의 결과를 저장하세요. 그 평가로 복습했을 때 나오는 결과와 같습니다.

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

영어로 표시하면 새 카드에 대해 `Again · 1m`, `Hard · 6m`, `Good · 10m`이 나오고, `Easy`는 약 일주일입니다(fuzz가 정확한 날짜를 분산시킵니다).

### 설정 고르기

기억률이 높을수록 간격은 짧아지고 복습은 늘어납니다. 범위를 벗어난 설정은 오류를 던집니다.

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

### 입력한 답안 채점하기

```swift
func feedback(for answer: String, card: Flashcard) -> String {
    switch AnswerMatcher().evaluate(answer, acceptedAnswers: card.acceptedAnswers) {
    case .correct: "Correct"
    case .almostCorrect(let expected, _): "Almost: it is spelled \(expected)"
    case .incorrect: "The answer is \(card.back)"
    }
}
```

`Nairobi`에 대해 `"nairobi"`는 정답이고, `"Nairbi"`는 거의 정답(오타 하나)이며, `"Mombasa"`는 오답입니다. 악센트, 대소문자, 문장 부호는 무시되므로 `"Sao Paulo"`는 `"São Paulo"`와 일치합니다.

### 퀴즈를 풀고 결과로 일정 잡기

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

틀린 답은 **Again**, 오타가 있는 답은 **Hard**, 맞은 답은 **Good**으로 예약됩니다. `QuizBuilder.multipleChoice(from:choiceCount:using:)`는 오답 선택지가 다른 카드의 정답으로 채워진 객관식 문제를 만듭니다.

### SM-2 데이터를 FSRS로 옮기기

```swift
func migrate(easeFactor: Double, intervalDays: Int, due: Date, lastReview: Date) throws -> ReviewState {
    let sm2 = SM2State(easeFactor: easeFactor, repetitions: 4, interval: intervalDays, due: due, lastReview: lastReview)
    return try ReviewState(migrating: sm2, scheduler: .default)
}
```

카드는 기한을 그대로 유지하며, 다음번에 잘 복습하면 간격이 이전의 쉬움 계수(easiness factor)만큼 대략 늘어납니다.

### 진행 상황 표시하기

```swift
func progressSummary(deck: [Flashcard], logs: [ReviewLog], now: Date) -> String {
    let streak = StudyStreak(activityDates: logs.map(\.reviewedAt), now: now)
    let forecast = ReviewForecast(dueDates: deck.map(\.review.due), from: now, days: 7)
    let retention = ReviewStatistics(logs: logs).retention ?? 0
    return "\(streak.current)-day streak, \(forecast.days[0].count) due today, "
        + "\(forecast.totalCount) this week, \(Int((retention * 100).rounded())) % retained"
}
```

복습할 때마다 새 상태와 함께 `ReviewLog`가 반환됩니다(`outcome.log`). 통계와 연속 학습 기록을 위해 이 로그를 보관하세요.

### 덱 저장하기

`Flashcard`, `ReviewState`, `ReviewLog`, `FSRSScheduler`, `QuizSession`은 `Codable`이므로 덱을 JSON 파일에 담을 수 있습니다. 예를 들어 `URL.documentsDirectory.appending(path: "deck.json")`에 저장합니다.

```swift
func save(_ deck: [Flashcard], to url: URL) throws {
    try JSONEncoder().encode(deck).write(to: url, options: .atomic)
}

func loadDeck(from url: URL) throws -> [Flashcard] {
    try JSONDecoder().decode([Flashcard].self, from: Data(contentsOf: url))
}
```

어떤 복습으로도 만들어질 수 없는 상태(NaN, 음수 카운트)가 파일에 있으면, 앱이 크래시하는 대신 그 카드의 다음 복습이 `SchedulingError.invalidState`를 던집니다.

자체 모델을 유지하려면 모델에 `ReviewState` 프로퍼티를 추가하고(단일 `Codable` 값이라 SwiftData 속성에 들어갑니다) `StudyQueue.items(from:at:newLimit:reviewLimit:state:)`를 사용하세요.

## 데모

<table>
<tr>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/progress-dark.png"><img src="docs/images/progress-light.png" width="260" alt="진행 화면: 21일 연속 학습, 최고 기록 21일, 기억률 91%, 복습 84회, 앞으로 14일 동안 날마다 기한이 되는 카드 수를 보여 주는 막대 차트"></picture></td>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/deck-dark.png"><img src="docs/images/deck-light.png" width="260" alt="덱 목록: 각 수도와 해당 국가, 기한과 현재 얼마나 기억하는지. 예를 들어 Hanoi는 지금 기한이며 90%"></picture></td>
</tr>
</table>

스크린샷은 iOS 27이 설치된 iPhone 17 Pro 시뮬레이터에서 [예제 앱](Examples)을 실행하여 [`scripts/capture-screens.sh`](scripts/capture-screens.sh)로 캡처한 것입니다. 앱은 고정된 seed로 3주 동안의 학습을 시뮬레이션하는 데모 모드로 실행되므로, 캡처할 때마다 같은 카드가 나옵니다. 실행하려면 `Examples/StudyDeck/StudyDeck.xcodeproj`를 열고 iPhone 시뮬레이터나 **My Mac**을 선택한 뒤 실행하세요.

## 문서

API 레퍼런스와 문서:

- [API 레퍼런스](https://muhittincamdali.github.io/educationai/documentation/educationai/)
  — 모든 공개 타입을 매개변수와 제한 사항과 함께 설명합니다.

## 가이드

- [시작하기](https://muhittincamdali.github.io/educationai/documentation/educationai/gettingstarted)
  — 패키지 추가, 카드마다 복습 상태 보관, 큐, 복습, 저장.
- [복습 일정 잡기](https://muhittincamdali.github.io/educationai/documentation/educationai/schedulingreviews)
  — FSRS의 동작 방식, 학습 단계, 설정과 그에 따른 절충, SM-2와 이전.
- [퀴즈 만들기](https://muhittincamdali.github.io/educationai/documentation/educationai/buildingquizzes)
  — 카드에서 만드는 문제, 퀴즈 세션, 입력형 채점이 허용하는 것, 힌트.
- [진행 상황 추적하기](https://muhittincamdali.github.io/educationai/documentation/educationai/trackingprogress)
  — 예측, 통계, 연속 학습 기록, 적응형 난이도.

## 요구 사항

| 플랫폼 | 최소 버전 |
| ------------------- | ------------------ |
| iOS | 17 |
| macOS | 14 |
| tvOS | 17 |
| watchOS | 10 |
| visionOS | 1 |
| 툴체인 | Swift 6.2 · Xcode 26+ |

이 패키지는 Foundation만 사용합니다. 예제 앱은 iOS와 macOS용입니다.

## 아키텍처

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

- `FSRSScheduler`는 설정(`FSRSScheduler.swift`), `py-fsrs`를 연산 하나하나 따라 작성한 FSRS-6 공식(`+Formulas`), 저장된 값에 대한 검사를 포함한 상태 머신(`+Transition`)으로 나뉩니다.
- 참조나 락을 보유하는 것은 없습니다. 각 호출은 값을 받아 값을 반환하므로, 이 타입들은 어떤 스레드나 actor에서도 쓸 수 있고 SwiftData, Core Data, 파일, iCloud에 저장할 수 있습니다.
- 한계는 명시되어 있습니다. 500자를 넘는 답안은 비교하지 않고, 예측은 최대 3,650일까지 다루며, 조절기 윈도우는 최대 1,000개의 답안을 보관하고, 퀴즈를 만들 때는 고정된 횟수만큼 추첨해 오답 선택지를 뽑습니다.

## 로드맵

계획 중인 항목이며 순서는 정해져 있지 않습니다. 학습자의 복습 로그로 FSRS 가중치를 학습하는 기능(`py-fsrs`와 `fsrs-rs`에 있는 optimizer), 참조 구현이 스케줄링에 FSRS-7을 채택한 뒤의 FSRS-7 지원, Anki 복습 로그 가져오기, 기한을 여러 날에 고르게 분산하는 부하 분산입니다. 제안은 [issues](https://github.com/muhittincamdali/educationai/issues)에서 환영합니다.

## 기여하기

기여를 환영합니다. pull request를 열기 전에 [기여 가이드](https://github.com/muhittincamdali/educationai/blob/main/CONTRIBUTING.md)와 [행동 강령](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)을 읽어 주세요. 보안 문제는 [보안 정책](https://github.com/muhittincamdali/educationai/blob/main/SECURITY.md)에 따라 비공개로 제보해 주세요.

## 라이선스

MIT 라이선스로 배포됩니다. 자세한 내용은 [LICENSE](LICENSE)를 참고하세요.

Design notes: https://muhittincamdali.com/en/open-source/educationai/
