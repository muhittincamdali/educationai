<!-- i18n-source: README.md@db55f3d75ea7a74435145e329f03e181aefdd94d status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-ru-light.svg" alt="EducationAI: Интервальное повторение FSRS-6 и SM-2, тесты, адаптивная сложность и серии занятий для Swift-приложений."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml/badge.svg" alt="Статус CI"></a>
<a href="https://github.com/muhittincamdali/educationai/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg" alt="Последняя версия: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg" alt="Поддерживаемые платформы: iOS 17+ · macOS 14+ · tvOS 17+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg" alt="Версия языка: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg" alt="Лицензия: MIT"></picture></a>
</p>

<p align="center">
<a href="#быстрый-старт"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-ru-light.svg" alt="Начать"></picture></a>
<a href="https://muhittincamdali.github.io/educationai/documentation/educationai/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-ru-light.svg" alt="Документация"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-ru-light.svg" alt="Примеры"></picture></a>
</p>

> Это перевод README на английском языке. Если они расходятся, актуальна английская версия.

<!-- brand:end -->

Swift-пакет с логикой обучения для приложения с карточками или для учёбы. `FSRSScheduler` решает, когда каждая карточка вернётся, по модели памяти FSRS-6, на которой основан планировщик FSRS в Anki, и даёт те же результаты, что и эталонная реализация `py-fsrs` 6.3.2. `SM2Scheduler` сохраняет работоспособность данных SM-2 и переводит их в FSRS без потери прогресса. Вокруг планировщика есть очередь занятий, проверка введённых ответов с допуском на опечатки, тесты, регулятор сложности, прогноз нагрузки, статистика повторений и серии занятий. Всё работает на устройстве, без зависимостей, и написано для строгой конкурентности (strict concurrency) Swift 6.

<p align="center">
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/review-dark.png"><img src="docs/images/review-light.png" width="300" alt="Экран повторения в примере приложения: карточка Capital of Vietnam с ответом Hanoi, память 90 % и четыре кнопки оценки с подписями 10m Again, 1mo Hard, 2mo Good и 3mo Easy"></picture>
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/quiz-dark.png"><img src="docs/images/quiz-light.png" width="300" alt="Вопрос теста с вводом ответа, Capital of Morocco, ответ Raba: в отзыве сказано «Almost, it is spelled Rabat» (одна опечатка), и карточка планируется как Hard"></picture>
</p>

## Основные возможности

- **FSRS-6, сверенный с эталоном** — тесты воспроизводят 2 400 повторений, рассчитанных `py-fsrs` 6.3.2, в восьми конфигурациях и после каждого повторения сравнивают stability, difficulty, дату срока и retrievability. Поддерживаются шаги обучения и переобучения, желаемая запоминаемость, максимальный интервал, fuzz интервалов и собственные веса (21 из FSRS-6 или 19 из FSRS-5).
- **Значения, а не сервисы** — планировщики, состояния, тесты и регуляторы — это типы-значения `Sendable` и `Codable`. Каждая функция принимает дату, с которой работает, а случайность берётся из генератора, которому можно задать seed, поэтому результаты можно проверить для любого дня.
- **Безопасно с сохранёнными данными** — состояния, прочитанные из файла или базы данных, проверяются перед использованием. NaN, бесконечные и отрицательные значения вызывают ошибку вместо падения, счётчики останавливаются на `Int.max`, а сохранённый тест при загрузке оценивается заново.
- **Справедливая проверка введённых ответов** — `AnswerMatcher` не учитывает регистр, диакритические знаки, ширину символов и пунктуацию, не завися от языка устройства, прощает опечатки в зависимости от длины ответа и выполняет работу, пропорциональную длине ответа, даже при вредоносном вводе.
- **Всё, что нужно вокруг планировщика** — очередь занятий с дневными лимитами, SM-2 и его перенос в FSRS, тесты с выбором ответа и с вводом ответа, составляемые из карточек, подсказки к ответам, регулятор сложности, прогноз по дням, статистика запоминаемости и серии занятий в часовом поясе ученика.
- **Протестировано** — 124 теста, выполняемые на macOS и в симуляторе iOS, включая примеры из README.

## Быстрый старт

**1. Добавьте пакет**

В Xcode выберите **File › Add Package Dependencies…** и введите адрес репозитория:

```text
https://github.com/muhittincamdali/educationai.git
```

Вставьте его в поле поиска в правом верхнем углу окна. Оставьте **Dependency Rule** равным **Up to Next Major Version** начиная с `2.0.0` и нажмите **Add Package**. В следующем окне выберите таргет вашего приложения рядом с **EducationAI** и снова нажмите **Add Package**.

**2. Импортируйте модуль**

```swift
import EducationAI
```

Поставьте эту строку в начало Swift-файла, где вы будете показывать карточки, под `import SwiftUI`.

**3. Показать карточки и оценить их**

Добавьте это представление в файл и покажите его из приложения, например как содержимое `WindowGroup`:

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

Запустите приложение. Оно покажет **Capital of Japan**; нажмите **Show Answer**, затем **Good**. Карточка перейдёт на 10-минутный шаг обучения, и появится **Capital of Kenya**. Когда все три карточки оценены, представление покажет **All done for now**. Здесь карточки хранятся в `@State`, поэтому при следующем запуске всё начнётся заново; как их сохранить, показано ниже в разделе [Сохранение колоды](#сохранение-колоды).

## Установка

### Swift Package Manager

В Xcode выберите **File › Add Package Dependencies…** и введите адрес репозитория:

```text
https://github.com/muhittincamdali/educationai.git
```

Или добавьте его в `dependencies` вашего `Package.swift`:

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

## Использование

Примеры ниже скопированы из [ReadmeSamples.swift](Examples/StudyDeck/StudyDeck/ReadmeSamples.swift): этот файл компилируют пример приложения и набор тестов, а тесты его выполняют.

### Показать следующий интервал на каждой кнопке

Предпросмотр даёт результат всех четырёх оценок. Подпишите им кнопки и сохраните результат той оценки, которую выберет ученик: это тот же результат, который даёт повторение с этой оценкой.

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

В английской локали для новой карточки получается `Again · 1m`, `Hard · 6m` и `Good · 10m`, а для `Easy` — около недели (fuzz распределяет точный день).

### Выбрать настройки

Более высокая запоминаемость означает более короткие интервалы и больше повторений. Настройки вне допустимого диапазона вызывают ошибку:

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

### Проверить введённый ответ

```swift
func feedback(for answer: String, card: Flashcard) -> String {
    switch AnswerMatcher().evaluate(answer, acceptedAnswers: card.acceptedAnswers) {
    case .correct: "Correct"
    case .almostCorrect(let expected, _): "Almost: it is spelled \(expected)"
    case .incorrect: "The answer is \(card.back)"
    }
}
```

`"nairobi"` — верный ответ для `Nairobi`, `"Nairbi"` почти верен (одна опечатка), `"Mombasa"` — нет. Диакритические знаки, регистр и пунктуация игнорируются: `"Sao Paulo"` совпадает с `"São Paulo"`.

### Провести тест и запланировать повторения по его результатам

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

Неверный ответ планируется как **Again**, ответ с опечатками — как **Hard**, верный — как **Good**. `QuizBuilder.multipleChoice(from:choiceCount:using:)` создаёт вопросы с выбором ответа, где неверные варианты — это ответы других карточек.

### Перенести данные SM-2 в FSRS

```swift
func migrate(easeFactor: Double, intervalDays: Int, due: Date, lastReview: Date) throws -> ReviewState {
    let sm2 = SM2State(easeFactor: easeFactor, repetitions: 4, interval: intervalDays, due: due, lastReview: lastReview)
    return try ReviewState(migrating: sm2, scheduler: .default)
}
```

Карточка сохраняет срок, а при следующем хорошем повторении интервал вырастет примерно в её прежний коэффициент лёгкости (easiness factor).

### Показать прогресс

```swift
func progressSummary(deck: [Flashcard], logs: [ReviewLog], now: Date) -> String {
    let streak = StudyStreak(activityDates: logs.map(\.reviewedAt), now: now)
    let forecast = ReviewForecast(dueDates: deck.map(\.review.due), from: now, days: 7)
    let retention = ReviewStatistics(logs: logs).retention ?? 0
    return "\(streak.current)-day streak, \(forecast.days[0].count) due today, "
        + "\(forecast.totalCount) this week, \(Int((retention * 100).rounded())) % retained"
}
```

Каждое повторение возвращает `ReviewLog` вместе с новым состоянием (`outcome.log`); сохраняйте журналы для статистики и серий.

### Сохранение колоды

`Flashcard`, `ReviewState`, `ReviewLog`, `FSRSScheduler` и `QuizSession` — это `Codable`, поэтому колода умещается в JSON-файл, например по адресу `URL.documentsDirectory.appending(path: "deck.json")`:

```swift
func save(_ deck: [Flashcard], to url: URL) throws {
    try JSONEncoder().encode(deck).write(to: url, options: .atomic)
}

func loadDeck(from url: URL) throws -> [Flashcard] {
    try JSONDecoder().decode([Flashcard].self, from: Data(contentsOf: url))
}
```

Состояние в файле, которое не могло получиться ни при каком повторении (NaN, отрицательный счётчик), заставляет следующее повторение вызвать `SchedulingError.invalidState`, а не уронить приложение.

Чтобы сохранить собственную модель, добавьте к ней свойство `ReviewState` (это одно значение `Codable`, поэтому оно подходит для атрибута SwiftData) и используйте `StudyQueue.items(from:at:newLimit:reviewLimit:state:)`.

## Демо

<table>
<tr>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/progress-dark.png"><img src="docs/images/progress-light.png" width="260" alt="Экран прогресса: серия 21 день, лучшая серия 21, запоминаемость 91 %, 84 повторения и столбчатая диаграмма карточек, срок которых наступает в каждый из ближайших 14 дней"></picture></td>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/deck-dark.png"><img src="docs/images/deck-light.png" width="260" alt="Список колоды: каждая столица со своей страной, когда наступает срок и насколько хорошо она запомнена сейчас, например Hanoi: срок наступил, 90 %"></picture></td>
</tr>
</table>

Скриншоты сделаны в [примере приложения](Examples) на симуляторе iPhone 17 Pro с iOS 27 с помощью [`scripts/capture-screens.sh`](scripts/capture-screens.sh). Приложение работает в демонстрационном режиме с тремя неделями смоделированных занятий из фиксированного seed, поэтому на каждом снимке одни и те же карточки. Чтобы запустить его, откройте `Examples/StudyDeck/StudyDeck.xcodeproj`, выберите симулятор iPhone или **My Mac** и запустите.

## Документация

Справочник API и статьи:

- [Справочник API](https://muhittincamdali.github.io/educationai/documentation/educationai/)
  — каждый открытый тип с его параметрами и ограничениями.

## Руководства

- [Начало работы](https://muhittincamdali.github.io/educationai/documentation/educationai/gettingstarted)
  — добавить пакет, хранить состояние повторения для каждой карточки, поставить в очередь, повторить, сохранить.
- [Планирование повторений](https://muhittincamdali.github.io/educationai/documentation/educationai/schedulingreviews)
  — как работает FSRS, фазы обучения, настройки и компромиссы, SM-2 и перенос данных.
- [Создание тестов](https://muhittincamdali.github.io/educationai/documentation/educationai/buildingquizzes)
  — вопросы из карточек, сессии тестов, что прощает проверка введённых ответов, подсказки.
- [Отслеживание прогресса](https://muhittincamdali.github.io/educationai/documentation/educationai/trackingprogress)
  — прогноз, статистика, серии и адаптивная сложность.

## Требования

| Платформа | Минимальная версия |
| ------------------- | ------------------ |
| iOS | 17 |
| macOS | 14 |
| tvOS | 17 |
| watchOS | 10 |
| visionOS | 1 |
| Инструменты | Swift 6.2 · Xcode 26+ |

Пакет использует только Foundation. Пример приложения предназначен для iOS и macOS.

## Архитектура

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

- `FSRSScheduler` разделён на настройки (`FSRSScheduler.swift`), формулы FSRS-6, написанные так, чтобы повторять `py-fsrs` операция за операцией (`+Formulas`), и конечный автомат с проверками сохранённых значений (`+Transition`).
- Ничто не удерживает ссылку или блокировку: каждый вызов принимает значения и возвращает значения, поэтому типы можно использовать из любого потока или actor и хранить в SwiftData, Core Data, файлах или iCloud.
- Ограничения заданы явно: ответы длиннее 500 символов не сравниваются, прогнозы охватывают не более 3 650 дней, окна регулятора хранят не более 1 000 ответов, а при создании тестов неверные варианты выбираются за фиксированное число попыток.

## План развития

В планах, без определённого порядка: обучение весов FSRS по журналам повторений ученика (optimizer, как у `py-fsrs` и `fsrs-rs`), FSRS-7 после того, как эталонные реализации примут его для планирования, импорт журналов повторений Anki и распределение нагрузки по срокам между днями. Предложения приветствуются в [issues](https://github.com/muhittincamdali/educationai/issues).

## Участие в разработке

Мы рады вашему участию. Перед открытием pull request прочитайте [руководство для участников](https://github.com/muhittincamdali/educationai/blob/main/CONTRIBUTING.md) и [кодекс поведения](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md). О проблемах безопасности сообщайте конфиденциально, как описано в [политике безопасности](https://github.com/muhittincamdali/educationai/blob/main/SECURITY.md).

## Лицензия

Распространяется по лицензии MIT. Подробнее — в файле [LICENSE](LICENSE).
