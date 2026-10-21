<!-- i18n-source: README.md@f9244ae8b5ee36d676748f903909a5d507c7a923 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-ja-light.svg" alt="EducationAI: Swift アプリ向けの FSRS-6・SM-2 間隔反復、クイズ、難易度の自動調整、連続学習日数。"></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml/badge.svg" alt="CI ステータス"></a>
<a href="https://github.com/muhittincamdali/educationai/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg" alt="最新バージョン: v2.1.0"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg" alt="対応プラットフォーム: iOS 17+ · macOS 14+ · tvOS 17+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg" alt="言語バージョン: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg" alt="ライセンス: MIT"></picture></a>
</p>

<p align="center">
<a href="#クイックスタート"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-ja-light.svg" alt="はじめる"></picture></a>
<a href="https://muhittincamdali.github.io/educationai/documentation/educationai/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-ja-light.svg" alt="ドキュメント"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-ja-light.svg" alt="サンプル"></picture></a>
</p>

> このドキュメントは英語版 README の翻訳です。内容が異なる場合は英語版が最新です。

<!-- brand:end -->

フラッシュカードや学習アプリの学習ロジックをまとめた Swift パッケージです。`FSRSScheduler` は、Anki の FSRS スケジューラの基になっている記憶モデル FSRS-6 で各カードがいつ戻ってくるかを決め、リファレンス実装 `py-fsrs` 6.3.2 と同じ結果を返します。`SM2Scheduler` は SM-2 のデータをそのまま使い続けられるようにし、進捗を失わずに FSRS へ変換します。スケジューラの周りには、学習キュー、タイプミスを許容する入力式の回答判定、クイズ、難易度の調整、学習量の予測、復習の統計、連続学習日数がそろっています。すべて端末上で動作し、依存関係はなく、Swift 6 の strict concurrency に対応して書かれています。

<p align="center">
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/review-dark.png"><img src="docs/images/review-light.png" width="300" alt="サンプルアプリの復習画面：カード Capital of Vietnam とその答え Hanoi、記憶率 90%、10m Again・1mo Hard・2mo Good・3mo Easy と書かれた 4 つの評価ボタン"></picture>
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/quiz-dark.png"><img src="docs/images/quiz-light.png" width="300" alt="入力式クイズの問題 Capital of Morocco に Raba と答えた画面：フィードバックは &quot;Almost, it is spelled Rabat&quot;（タイプミスが 1 つ）で、カードは Hard として予定される"></picture>
</p>

## 主な特長

- **リファレンスと照合した FSRS-6** — テストでは、`py-fsrs` 6.3.2 が計算した 2,400 回の復習を 8 通りの設定で再現し、復習のたびに stability、difficulty、期日、retrievability を比較します。学習・再学習のステップ、目標保持率、最大間隔、間隔の fuzz、カスタムの重み（FSRS-6 の 21 個または FSRS-5 の 19 個）に対応しています。
- **サービスではなく値** — スケジューラ、状態、クイズ、調整機能はすべて `Sendable` かつ `Codable` な値型です。どの関数も処理の基準となる日時を引数に取り、乱数は seed を指定できるジェネレータから得るので、どの日についても結果をテストできます。
- **保存データに対して安全** — ファイルやデータベースから読み戻した状態は、使う前に検証されます。NaN、無限大、負の値はクラッシュせずにエラーを投げ、カウンタは `Int.max` で止まり、保存されたクイズは読み込み時に再び採点されます。
- **公平な入力式の回答判定** — `AnswerMatcher` は、端末の言語に依存せず、大文字小文字、アクセント、文字幅、句読点を無視します。タイプミスは回答の長さに応じて許容し、悪意のある入力に対しても、処理量は回答の長さに比例します。
- **スケジューラの周りのものがすべて** — 1 日の上限つきの学習キュー、SM-2 とその FSRS への移行、カードから作る選択式・入力式のクイズ、回答のヒント、難易度の調整、日ごとの予測、保持率の統計、学習者のタイムゾーンで数える連続学習日数。
- **テスト済み** — README のサンプルを含む 127 件のテストを macOS と iOS シミュレータで実行しています。

## クイックスタート

**1. パッケージを追加する**

Xcode で **File › Add Package Dependencies…** を選び、リポジトリの URL を入力します。

```text
https://github.com/muhittincamdali/educationai.git
```

ウィンドウ右上の検索欄に貼り付けます。**Dependency Rule** は `2.0.0` からの **Up to Next Major Version** のままにして、**Add Package** をクリックします。次のウィンドウで **EducationAI** の横にあるアプリのターゲットを選び、もう一度 **Add Package** をクリックします。

**2. モジュールをインポートする**

```swift
import EducationAI
```

この行は、カードを表示する Swift ファイルの先頭、`import SwiftUI` の下に置きます。

**3. カードを表示して評価する**

次のビューをファイルに追加し、アプリから表示します。たとえば `WindowGroup` の内容にします。

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

アプリを実行すると **Capital of Japan** が表示されます。**Show Answer** をタップし、続けて **Good** をタップします。カードは 10 分の学習ステップに移り、**Capital of Kenya** が表示されます。3 枚すべてを評価すると、ビューに **All done for now** と表示されます。ここではカードを `@State` に置いているため、次回の起動時には最初からになります。保存する方法は、下の[デッキを保存する](#デッキを保存する)で説明します。

## インストール

### Swift Package Manager

Xcode で **File › Add Package Dependencies…** を選び、リポジトリの URL を入力します。

```text
https://github.com/muhittincamdali/educationai.git
```

または `Package.swift` の `dependencies` に追加します。

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

## 使い方

以下のサンプルは [ReadmeSamples.swift](Examples/StudyDeck/StudyDeck/ReadmeSamples.swift) からコピーしたものです。このファイルはサンプルアプリとテストスイートがコンパイルし、テストが実行します。

### ボタンごとに次の間隔を表示する

プレビューは 4 つの評価それぞれの結果を返します。ボタンのラベルにこれを使い、学習者がタップした評価の結果を保存してください。それは、その評価で復習した場合に得られる結果と同じです。

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

英語の表示では、新しいカードに対して `Again · 1m`、`Hard · 6m`、`Good · 10m` となり、`Easy` は約 1 週間になります（fuzz により正確な日はばらつきます）。

### 設定を選ぶ

保持率を高くすると、間隔は短くなり、復習が増えます。範囲外の設定はエラーを投げます。

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

### 入力された回答を判定する

```swift
func feedback(for answer: String, card: Flashcard) -> String {
    switch AnswerMatcher().evaluate(answer, acceptedAnswers: card.acceptedAnswers) {
    case .correct: "Correct"
    case .almostCorrect(let expected, _): "Almost: it is spelled \(expected)"
    case .incorrect: "The answer is \(card.back)"
    }
}
```

`Nairobi` に対して `"nairobi"` は正解、`"Nairbi"` はほぼ正解（タイプミスが 1 つ）、`"Mombasa"` は不正解です。アクセント、大文字小文字、句読点は無視されるので、`"Sao Paulo"` は `"São Paulo"` に一致します。

### クイズを出して結果から予定を立てる

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

間違った回答は **Again**、タイプミスのある回答は **Hard**、正しい回答は **Good** として予定されます。`QuizBuilder.multipleChoice(from:choiceCount:using:)` は、他のカードの答えを間違いの選択肢にした選択式の問題を作ります。

### SM-2 のデータを FSRS へ移す

```swift
func migrate(easeFactor: Double, intervalDays: Int, due: Date, lastReview: Date) throws -> ReviewState {
    let sm2 = SM2State(easeFactor: easeFactor, repetitions: 4, interval: intervalDays, due: due, lastReview: lastReview)
    return try ReviewState(migrating: sm2, scheduler: .default)
}
```

カードは期日を保ち、次に良好な復習をすると、間隔は以前の難易度係数（easiness factor）とほぼ同じ倍率で伸びます。

### 進捗を表示する

```swift
func progressSummary(deck: [Flashcard], logs: [ReviewLog], now: Date) -> String {
    let streak = StudyStreak(activityDates: logs.map(\.reviewedAt), now: now)
    let forecast = ReviewForecast(dueDates: deck.map(\.review.due), from: now, days: 7)
    let retention = ReviewStatistics(logs: logs).retention ?? 0
    return "\(streak.current)-day streak, \(forecast.days[0].count) due today, "
        + "\(forecast.totalCount) this week, \(Int((retention * 100).rounded())) % retained"
}
```

復習のたびに、新しい状態と一緒に `ReviewLog` が返されます（`outcome.log`）。統計と連続学習日数のために、このログを保管してください。

### デッキを保存する

`Flashcard`、`ReviewState`、`ReviewLog`、`FSRSScheduler`、`QuizSession` は `Codable` なので、デッキは JSON ファイルに収まります。たとえば `URL.documentsDirectory.appending(path: "deck.json")` に保存できます。

```swift
func save(_ deck: [Flashcard], to url: URL) throws {
    try JSONEncoder().encode(deck).write(to: url, options: .atomic)
}

func loadDeck(from url: URL) throws -> [Flashcard] {
    try JSONDecoder().decode([Flashcard].self, from: Data(contentsOf: url))
}
```

どの復習でも生成されえない状態（NaN や負のカウント）がファイルにあると、アプリをクラッシュさせる代わりに、その次の復習が `SchedulingError.invalidState` を投げます。

独自のモデルを使い続けるには、`ReviewState` プロパティを追加し（単一の `Codable` 値なので SwiftData の属性に収まります）、`StudyQueue.items(from:at:newLimit:reviewLimit:state:)` を使います。

## デモ

<table>
<tr>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/progress-dark.png"><img src="docs/images/progress-light.png" width="260" alt="進捗画面：21 日の連続学習、最長連続 21 日、保持率 91%、復習 84 回、今後 14 日間の各日に期日が来るカードを示す棒グラフ"></picture></td>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/deck-dark.png"><img src="docs/images/deck-light.png" width="260" alt="デッキ一覧：各首都とその国、期日、現在どのくらい覚えているか。たとえば Hanoi は今すぐ期日で 90%"></picture></td>
</tr>
</table>

スクリーンショットは、iOS 27 の iPhone 17 Pro シミュレータで[サンプルアプリ](Examples)を動かし、[`scripts/capture-screens.sh`](scripts/capture-screens.sh) で撮影したものです。アプリはデモモードで動作し、固定の seed から 3 週間分の学習をシミュレートするので、撮影のたびに同じカードが表示されます。実行するには `Examples/StudyDeck/StudyDeck.xcodeproj` を開き、iPhone シミュレータか **My Mac** を選んで実行します。

## ドキュメント

API リファレンスと解説記事：

- [API リファレンス](https://muhittincamdali.github.io/educationai/documentation/educationai/)
  — すべての公開型を、パラメータと制限とともに掲載しています。

## ガイド

- [はじめに](https://muhittincamdali.github.io/educationai/documentation/educationai/gettingstarted)
  — パッケージの追加、カードごとの復習状態の保持、キュー、復習、保存。
- [復習のスケジューリング](https://muhittincamdali.github.io/educationai/documentation/educationai/schedulingreviews)
  — FSRS のしくみ、学習フェーズ、設定とそのトレードオフ、SM-2 と移行。
- [クイズの作成](https://muhittincamdali.github.io/educationai/documentation/educationai/buildingquizzes)
  — カードからの問題、クイズセッション、入力式の判定が許容するもの、ヒント。
- [進捗の追跡](https://muhittincamdali.github.io/educationai/documentation/educationai/trackingprogress)
  — 予測、統計、連続学習日数、難易度の自動調整。

## 動作要件

| プラットフォーム | 最小バージョン |
| ------------------- | ------------------ |
| iOS | 17 |
| macOS | 14 |
| tvOS | 17 |
| watchOS | 10 |
| visionOS | 1 |
| ツールチェーン | Swift 6.2 · Xcode 26+ |

パッケージが使うのは Foundation だけです。サンプルアプリは iOS と macOS 向けです。

## アーキテクチャ

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

- `FSRSScheduler` は、設定（`FSRSScheduler.swift`）、`py-fsrs` と演算ごとに対応するように書かれた FSRS-6 の式（`+Formulas`）、保存された値の検証を含む状態遷移（`+Transition`）に分かれています。
- 参照もロックも保持しません。各呼び出しは値を受け取って値を返すので、これらの型はどのスレッドや actor からでも使え、SwiftData、Core Data、ファイル、iCloud に保存できます。
- 上限は明示されています。500 文字を超える回答は比較されず、予測は最大 3,650 日、調整機能のウィンドウは最大 1,000 件の回答を保持し、クイズの作成では間違いの選択肢を決まった回数の抽選で選びます。

## ロードマップ

予定している項目を、順不同で挙げます。学習者の復習ログから FSRS の重みを学習すること（`py-fsrs` や `fsrs-rs` にあるような optimizer）、リファレンス実装がスケジューリングに FSRS-7 を採用した時点での対応、Anki の復習ログの取り込み、期日を日ごとに分散させる負荷の平準化です。ご提案は [issues](https://github.com/muhittincamdali/educationai/issues) でお待ちしています。

## コントリビューション

コントリビューションを歓迎します。pull request を作成する前に[コントリビューションガイド](https://github.com/muhittincamdali/educationai/blob/main/CONTRIBUTING.md)と[行動規範](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)をお読みください。セキュリティ上の問題は[セキュリティポリシー](https://github.com/muhittincamdali/educationai/blob/main/SECURITY.md)に従って非公開で報告してください。

## ライセンス

MIT ライセンスで公開しています。詳細は [LICENSE](LICENSE) を参照してください。

Design notes: https://muhittincamdali.com/en/open-source/educationai/
