<!-- i18n-source: README.md@db55f3d75ea7a74435145e329f03e181aefdd94d status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-zh-CN-light.svg" alt="EducationAI: 为 Swift 应用提供 FSRS-6 和 SM-2 间隔重复、测验、自适应难度和连续学习天数。"></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml/badge.svg" alt="CI 状态"></a>
<a href="https://github.com/muhittincamdali/educationai/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg" alt="最新版本: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg" alt="支持的平台: iOS 17+ · macOS 14+ · tvOS 17+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg" alt="语言版本: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg" alt="许可证: MIT"></picture></a>
</p>

<p align="center">
<a href="#快速开始"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-zh-CN-light.svg" alt="开始使用"></picture></a>
<a href="https://muhittincamdali.github.io/educationai/documentation/educationai/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-zh-CN-light.svg" alt="文档"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-zh-CN-light.svg" alt="示例"></picture></a>
</p>

> 本文是英文 README 的译文。如两者内容不一致，以英文版为准。

<!-- brand:end -->

这是一个 Swift 包，提供闪卡或学习类应用所需的学习逻辑。`FSRSScheduler` 使用 FSRS-6（Anki 的 FSRS 调度器背后的记忆模型）决定每张卡片何时再次出现，结果与参考实现 `py-fsrs` 6.3.2 完全一致。`SM2Scheduler` 让 SM-2 数据继续可用，并能在不丢失进度的前提下将其转换为 FSRS。围绕调度器，还提供学习队列、支持拼写容错的输入答案评分、测验、难度调节器、工作量预测、复习统计和连续学习天数。所有功能都在设备上运行，没有任何依赖，并按 Swift 6 严格并发（strict concurrency）编写。

<p align="center">
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/review-dark.png"><img src="docs/images/review-light.png" width="300" alt="示例应用的复习界面：卡片 Capital of Vietnam 及其答案 Hanoi，记忆率 90%，以及标有 10m Again、1mo Hard、2mo Good 和 3mo Easy 的四个评分按钮"></picture>
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/quiz-dark.png"><img src="docs/images/quiz-light.png" width="300" alt="一道输入答案的测验题 Capital of Morocco，回答为 Raba：反馈显示 &quot;Almost, it is spelled Rabat&quot;（有一处拼写错误），卡片按 Hard 安排"></picture>
</p>

## 亮点

- **以参考实现验证的 FSRS-6** — 测试在八种配置下重放由 `py-fsrs` 6.3.2 计算出的 2,400 次复习，并在每次复习后比较 stability、difficulty、到期日期和 retrievability。支持学习与重学步骤、目标记忆率、最大间隔、间隔 fuzz 以及自定义权重（FSRS-6 的 21 个或 FSRS-5 的 19 个）。
- **是值，而不是服务** — 调度器、状态、测验和调节器都是 `Sendable`、`Codable` 的值类型。每个函数都以所处理的日期作为参数，随机数来自可以设定 seed 的生成器，因此可以针对任意一天测试结果。
- **对存储数据安全** — 从文件或数据库读回的状态在使用前会先检查。NaN、无穷大或负值会抛出错误而不是崩溃，计数器停在 `Int.max`，保存的测验在加载时会重新评分。
- **公平的输入答案评分** — `AnswerMatcher` 忽略大小写、重音、字符宽度和标点，且不依赖设备语言；按答案长度容忍拼写错误，即使面对恶意输入，计算量也只与答案长度成正比。
- **调度器周边的一切** — 带每日上限的学习队列、SM-2 及其向 FSRS 的迁移、由卡片生成的选择题和输入答案题测验、答案提示、难度调节器、按天的预测、记忆率统计，以及按学习者所在时区计算的连续学习天数。
- **经过测试** — 124 个测试，在 macOS 和 iOS 模拟器上运行，其中包括 README 中的示例。

## 快速开始

**1. 添加软件包**

在 Xcode 中选择 **File › Add Package Dependencies…**，然后输入仓库地址：

```text
https://github.com/muhittincamdali/educationai.git
```

将其粘贴到窗口右上角的搜索框中。将 **Dependency Rule** 保持为从 `2.0.0` 起的 **Up to Next Major Version**，然后点击 **Add Package**。在下一个窗口中，在 **EducationAI** 旁选择你的应用 target，再次点击 **Add Package**。

**2. 导入模块**

```swift
import EducationAI
```

把这一行放在要显示卡片的 Swift 文件顶部，位于 `import SwiftUI` 下方。

**3. 显示卡片并评分**

将下面的视图添加到该文件中，并在应用里显示它，例如作为 `WindowGroup` 的内容：

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

运行应用。它会显示 **Capital of Japan**；点击 **Show Answer**，再点击 **Good**。这张卡片进入 10 分钟的学习步骤，随后出现 **Capital of Kenya**。三张卡片都评分后，视图会显示 **All done for now**。这里的卡片保存在 `@State` 中，所以下次启动时会重新开始；下面的[保存牌组](#保存牌组)一节介绍如何保留它们。

## 安装

### Swift Package Manager

在 Xcode 中选择 **File › Add Package Dependencies…**，然后输入仓库地址：

```text
https://github.com/muhittincamdali/educationai.git
```

或者将其添加到 `Package.swift` 的 `dependencies` 中：

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

## 使用方法

下面的示例复制自 [ReadmeSamples.swift](Examples/StudyDeck/StudyDeck/ReadmeSamples.swift)，示例应用和测试套件都会编译该文件，测试也会运行它。

### 在每个按钮上显示下一个间隔

预览会给出四种评分各自的结果。用它来标注按钮，并保存学习者所点按评分对应的结果：它与使用该评分进行一次复习得到的结果相同。

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

在英文界面下，新卡片会得到 `Again · 1m`、`Hard · 6m` 和 `Good · 10m`，`Easy` 则约为一周（fuzz 会打散具体的日期）。

### 选择设置

记忆率越高，间隔越短，复习也越多。超出范围的设置会抛出错误：

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

### 为输入的答案评分

```swift
func feedback(for answer: String, card: Flashcard) -> String {
    switch AnswerMatcher().evaluate(answer, acceptedAnswers: card.acceptedAnswers) {
    case .correct: "Correct"
    case .almostCorrect(let expected, _): "Almost: it is spelled \(expected)"
    case .incorrect: "The answer is \(card.back)"
    }
}
```

对于 `Nairobi`，`"nairobi"` 是正确的，`"Nairbi"` 几乎正确（一处拼写错误），`"Mombasa"` 则不正确。重音、大小写和标点会被忽略：`"Sao Paulo"` 可以匹配 `"São Paulo"`。

### 进行测验并根据结果安排复习

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

答错按 **Again** 安排，有拼写错误的答案按 **Hard** 安排，答对按 **Good** 安排。`QuizBuilder.multipleChoice(from:choiceCount:using:)` 生成选择题，错误选项来自其他卡片的答案。

### 将 SM-2 数据迁移到 FSRS

```swift
func migrate(easeFactor: Double, intervalDays: Int, due: Date, lastReview: Date) throws -> ReviewState {
    let sm2 = SM2State(easeFactor: easeFactor, repetitions: 4, interval: intervalDays, due: due, lastReview: lastReview)
    return try ReviewState(migrating: sm2, scheduler: .default)
}
```

卡片保留其到期日期，下一次良好的复习会让间隔按其旧的难易系数（easiness factor）大致增长。

### 显示进度

```swift
func progressSummary(deck: [Flashcard], logs: [ReviewLog], now: Date) -> String {
    let streak = StudyStreak(activityDates: logs.map(\.reviewedAt), now: now)
    let forecast = ReviewForecast(dueDates: deck.map(\.review.due), from: now, days: 7)
    let retention = ReviewStatistics(logs: logs).retention ?? 0
    return "\(streak.current)-day streak, \(forecast.days[0].count) due today, "
        + "\(forecast.totalCount) this week, \(Int((retention * 100).rounded())) % retained"
}
```

每次复习都会在新状态之外返回一个 `ReviewLog`（`outcome.log`）；请保留这些日志，用于统计和连续学习天数。

### 保存牌组

`Flashcard`、`ReviewState`、`ReviewLog`、`FSRSScheduler` 和 `QuizSession` 都是 `Codable`，因此牌组可以存入 JSON 文件，例如存到 `URL.documentsDirectory.appending(path: "deck.json")`：

```swift
func save(_ deck: [Flashcard], to url: URL) throws {
    try JSONEncoder().encode(deck).write(to: url, options: .atomic)
}

func loadDeck(from url: URL) throws -> [Flashcard] {
    try JSONDecoder().decode([Flashcard].self, from: Data(contentsOf: url))
}
```

如果文件中的状态是任何一次复习都不可能产生的（NaN、负数计数），它的下一次复习会抛出 `SchedulingError.invalidState`，而不会让应用崩溃。

如果要保留自己的模型，请为它添加一个 `ReviewState` 属性（它是单个 `Codable` 值，因此可以放进 SwiftData 属性），并使用 `StudyQueue.items(from:at:newLimit:reviewLimit:state:)`。

## 演示

<table>
<tr>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/progress-dark.png"><img src="docs/images/progress-light.png" width="260" alt="进度界面：连续学习 21 天，最长连续 21 天，记忆率 91%，84 次复习，以及未来 14 天每天到期卡片数量的柱状图"></picture></td>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/deck-dark.png"><img src="docs/images/deck-light.png" width="260" alt="牌组列表：每个首都及其所属国家、到期时间和当前的记忆程度，例如 Hanoi 现已到期，记忆率 90%"></picture></td>
</tr>
</table>

截图来自 [示例应用](Examples)，运行于 iOS 27 的 iPhone 17 Pro 模拟器，由 [`scripts/capture-screens.sh`](scripts/capture-screens.sh) 截取。应用以演示模式运行，使用固定的 seed 模拟三周的学习，因此每次截图显示的都是相同的卡片。要运行它，请打开 `Examples/StudyDeck/StudyDeck.xcodeproj`，选择一个 iPhone 模拟器或 **My Mac**，然后运行。

## 文档

API 参考文档与文章：

- [API 参考](https://muhittincamdali.github.io/educationai/documentation/educationai/)
  — 每个公开类型及其参数和限制。

## 指南

- [快速入门](https://muhittincamdali.github.io/educationai/documentation/educationai/gettingstarted)
  — 添加包、为每张卡片保存一个复习状态、排队、复习、保存。
- [安排复习](https://muhittincamdali.github.io/educationai/documentation/educationai/schedulingreviews)
  — FSRS 的工作原理、学习阶段、设置及其取舍、SM-2 与迁移。
- [构建测验](https://muhittincamdali.github.io/educationai/documentation/educationai/buildingquizzes)
  — 由卡片生成题目、测验会话、输入答案评分容忍什么、提示。
- [跟踪进度](https://muhittincamdali.github.io/educationai/documentation/educationai/trackingprogress)
  — 预测、统计、连续学习天数和自适应难度。

## 系统要求

| 平台 | 最低版本 |
| ------------------- | ------------------ |
| iOS | 17 |
| macOS | 14 |
| tvOS | 17 |
| watchOS | 10 |
| visionOS | 1 |
| 工具链 | Swift 6.2 · Xcode 26+ |

该包只使用 Foundation。示例应用面向 iOS 和 macOS。

## 架构

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

- `FSRSScheduler` 分为三部分：设置（`FSRSScheduler.swift`）、逐个运算对照 `py-fsrs` 编写的 FSRS-6 公式（`+Formulas`），以及包含存储值检查的状态机（`+Transition`）。
- 没有任何东西持有引用或锁：每次调用接收值并返回值，因此这些类型可以在任意线程或 actor 中使用，并可存储在 SwiftData、Core Data、文件或 iCloud 中。
- 限制是明确的：超过 500 个字符的答案不会比较，预测最多覆盖 3,650 天，调节器窗口最多保存 1,000 个答案，测验生成以固定次数的抽取来选取错误选项。

## 路线图

计划中的内容，不分先后：根据学习者的复习日志训练 FSRS 权重（optimizer，就像 `py-fsrs` 和 `fsrs-rs` 那样）、在参考实现将 FSRS-7 用于调度之后支持它、导入 Anki 复习日志，以及把到期日期均衡分配到各天。欢迎在 [issues](https://github.com/muhittincamdali/educationai/issues) 中提出建议。

## 参与贡献

欢迎参与贡献。提交 pull request 之前，请先阅读[贡献指南](https://github.com/muhittincamdali/educationai/blob/main/CONTRIBUTING.md)和[行为准则](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)。如发现安全问题，请按照[安全策略](https://github.com/muhittincamdali/educationai/blob/main/SECURITY.md)私下报告。

## 许可证

基于 MIT 许可证发布。详见 [LICENSE](LICENSE)。
