<!-- i18n-source: README.md@2f8cac2867c7ebd91d28e6f7b3782064f0af9658 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-es-light.svg" alt="EducationAI: Repetición espaciada con FSRS-6 y SM-2, cuestionarios, dificultad adaptativa y rachas para apps en Swift."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml/badge.svg" alt="Estado de CI"></a>
<a href="https://github.com/muhittincamdali/educationai/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg" alt="Última versión: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg" alt="Plataformas compatibles: iOS 17+ · macOS 14+ · tvOS 17+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg" alt="Versión del lenguaje: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg" alt="Licencia: MIT"></picture></a>
</p>

<p align="center">
<a href="#inicio-rápido"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-es-light.svg" alt="Empezar"></picture></a>
<a href="https://muhittincamdali.github.io/educationai/documentation/educationai/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-es-light.svg" alt="Documentación"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-es-light.svg" alt="Ejemplos"></picture></a>
</p>

> Esta es una traducción del README en inglés. Si hay diferencias, la versión en inglés es la vigente.

<!-- brand:end -->

Un paquete de Swift con la lógica de aprendizaje de una app de tarjetas o de estudio. `FSRSScheduler` decide cuándo vuelve cada tarjeta con FSRS-6, el modelo de memoria en el que se basa el programador FSRS de Anki, y da los mismos resultados que la implementación de referencia, `py-fsrs` 6.3.2. `SM2Scheduler` mantiene en uso los datos de SM-2 y los convierte a FSRS sin perder el progreso. Alrededor del programador hay una cola de estudio, la evaluación de respuestas escritas con tolerancia a erratas, cuestionarios, un ajustador de dificultad, una previsión de carga de trabajo, estadísticas de repaso y rachas de estudio. Todo se ejecuta en el dispositivo, no tiene dependencias y está escrito para la concurrencia estricta (strict concurrency) de Swift 6.

<p align="center">
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/review-dark.png"><img src="docs/images/review-light.png" width="300" alt="La pantalla de repaso de la app de ejemplo: la tarjeta Capital of Vietnam con su respuesta Hanoi, memoria al 90 % y cuatro botones de valoración con las etiquetas 10m Again, 1mo Hard, 2mo Good y 3mo Easy"></picture>
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/quiz-dark.png"><img src="docs/images/quiz-light.png" width="300" alt="Una pregunta de cuestionario con respuesta escrita, Capital of Morocco, respondida con Raba: el mensaje dice &quot;Almost, it is spelled Rabat&quot; (una errata) y la tarjeta se programa como Hard"></picture>
</p>

## Lo más destacado

- **FSRS-6, comprobado contra la referencia** — las pruebas reproducen 2400 repasos calculados por `py-fsrs` 6.3.2 con ocho configuraciones y comparan stability, difficulty, fecha de vencimiento y retrievability después de cada repaso. Se admiten pasos de aprendizaje y de reaprendizaje, retención deseada, intervalo máximo, fuzz de intervalos y pesos personalizados (21 de FSRS-6 o 19 de FSRS-5).
- **Valores, no servicios** — los programadores, los estados, los cuestionarios y los ajustadores son tipos de valor `Sendable` y `Codable`. Cada función recibe la fecha con la que trabaja, y la aleatoriedad procede de un generador al que puedes darle una semilla (seed), de modo que los resultados se pueden probar para cualquier día.
- **Seguro con los datos guardados** — los estados que se leen de un archivo o de una base de datos se comprueban antes de usarlos. Los valores NaN, infinitos o negativos lanzan un error en lugar de bloquear la app, los contadores se detienen en `Int.max` y un cuestionario guardado se vuelve a calificar al cargarlo.
- **Respuestas escritas justas** — `AnswerMatcher` ignora mayúsculas, acentos, anchura de caracteres y puntuación sin depender del idioma del dispositivo, perdona las erratas según la longitud de la respuesta y hace un trabajo proporcional a esa longitud, incluso con entradas hostiles.
- **Todo lo que rodea al programador** — una cola de estudio con límites diarios, SM-2 y su migración a FSRS, cuestionarios de opción múltiple y de respuesta escrita creados a partir de las tarjetas, pistas para las respuestas, un ajustador de dificultad, una previsión por día, estadísticas de retención y rachas en la zona horaria del estudiante.
- **Probado** — 124 pruebas, ejecutadas en macOS y en un simulador de iOS, incluidos los ejemplos del README.

## Inicio rápido

**1. Añade el paquete**

En Xcode, elige **File › Add Package Dependencies…** e introduce la URL del repositorio:

```text
https://github.com/muhittincamdali/educationai.git
```

Pégala en el campo de búsqueda de la parte superior derecha de la ventana. Deja **Dependency Rule** en **Up to Next Major Version** a partir de `2.0.0` y haz clic en **Add Package**. En la ventana siguiente, elige el target de tu app junto a **EducationAI** y haz clic de nuevo en **Add Package**.

**2. Importa el módulo**

```swift
import EducationAI
```

Pon esta línea al principio del archivo de Swift donde vayas a mostrar las tarjetas, debajo de `import SwiftUI`.

**3. Muestra las tarjetas y valóralas**

Añade esta vista al archivo y muéstrala desde tu app, por ejemplo como contenido de tu `WindowGroup`:

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

Ejecuta la app. Muestra **Capital of Japan**; toca **Show Answer** y luego **Good**. La tarjeta pasa a su paso de aprendizaje de 10 minutos y aparece **Capital of Kenya**. Cuando se han valorado las tres, la vista dice **All done for now**. Aquí las tarjetas viven en `@State`, así que empiezan de nuevo en el siguiente inicio; en [Guardar el mazo](#guardar-el-mazo), más abajo, verás cómo conservarlas.

## Instalación

### Swift Package Manager

En Xcode, elige **File › Add Package Dependencies…** e introduce la URL del repositorio:

```text
https://github.com/muhittincamdali/educationai.git
```

O añádelo a las `dependencies` de tu `Package.swift`:

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

## Uso

Los ejemplos siguientes están copiados de [ReadmeSamples.swift](Examples/StudyDeck/StudyDeck/ReadmeSamples.swift), que compilan la app de ejemplo y el conjunto de pruebas, y que las pruebas ejecutan.

### Mostrar el siguiente intervalo en cada botón

Una vista previa da el resultado de las cuatro valoraciones. Rotula los botones con ella y guarda el resultado de la que toque el estudiante: es el mismo resultado que da un repaso con esa valoración.

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

En inglés esto da `Again · 1m`, `Hard · 6m` y `Good · 10m` para una tarjeta nueva, y cerca de una semana para `Easy` (el fuzz reparte el día exacto).

### Elegir los ajustes

Una retención más alta significa intervalos más cortos y más repasos. Los ajustes fuera de rango lanzan un error:

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

### Calificar una respuesta escrita

```swift
func feedback(for answer: String, card: Flashcard) -> String {
    switch AnswerMatcher().evaluate(answer, acceptedAnswers: card.acceptedAnswers) {
    case .correct: "Correct"
    case .almostCorrect(let expected, _): "Almost: it is spelled \(expected)"
    case .incorrect: "The answer is \(card.back)"
    }
}
```

`"nairobi"` es correcto para `Nairobi`, `"Nairbi"` es casi correcto (una errata) y `"Mombasa"` no lo es. Los acentos, las mayúsculas y la puntuación se ignoran: `"Sao Paulo"` coincide con `"São Paulo"`.

### Hacer un cuestionario y programar según los resultados

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

Una respuesta incorrecta se programa como **Again**, una con erratas como **Hard** y una correcta como **Good**. `QuizBuilder.multipleChoice(from:choiceCount:using:)` crea preguntas de opción múltiple cuyas opciones incorrectas son respuestas de otras tarjetas.

### Pasar los datos de SM-2 a FSRS

```swift
func migrate(easeFactor: Double, intervalDays: Int, due: Date, lastReview: Date) throws -> ReviewState {
    let sm2 = SM2State(easeFactor: easeFactor, repetitions: 4, interval: intervalDays, due: due, lastReview: lastReview)
    return try ReviewState(migrating: sm2, scheduler: .default)
}
```

La tarjeta conserva su fecha de vencimiento, y su próximo repaso correcto hace crecer el intervalo aproximadamente según su antiguo factor de facilidad.

### Mostrar el progreso

```swift
func progressSummary(deck: [Flashcard], logs: [ReviewLog], now: Date) -> String {
    let streak = StudyStreak(activityDates: logs.map(\.reviewedAt), now: now)
    let forecast = ReviewForecast(dueDates: deck.map(\.review.due), from: now, days: 7)
    let retention = ReviewStatistics(logs: logs).retention ?? 0
    return "\(streak.current)-day streak, \(forecast.days[0].count) due today, "
        + "\(forecast.totalCount) this week, \(Int((retention * 100).rounded())) % retained"
}
```

Cada repaso devuelve un `ReviewLog` junto al nuevo estado (`outcome.log`); conserva los registros para las estadísticas y las rachas.

### Guardar el mazo

`Flashcard`, `ReviewState`, `ReviewLog`, `FSRSScheduler` y `QuizSession` son `Codable`, así que un mazo cabe en un archivo JSON, por ejemplo en `URL.documentsDirectory.appending(path: "deck.json")`:

```swift
func save(_ deck: [Flashcard], to url: URL) throws {
    try JSONEncoder().encode(deck).write(to: url, options: .atomic)
}

func loadDeck(from url: URL) throws -> [Flashcard] {
    try JSONDecoder().decode([Flashcard].self, from: Data(contentsOf: url))
}
```

Un estado del archivo que ningún repaso podría haber producido (NaN, un contador negativo) hace que su siguiente repaso lance `SchedulingError.invalidState` en lugar de bloquear la app.

Para conservar tu propio modelo, añádele una propiedad `ReviewState` (es un único valor `Codable`, así que cabe en un atributo de SwiftData) y usa `StudyQueue.items(from:at:newLimit:reviewLimit:state:)`.

## Demo

<table>
<tr>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/progress-dark.png"><img src="docs/images/progress-light.png" width="260" alt="La pantalla de progreso: una racha de 21 días, mejor racha de 21, retención del 91 %, 84 repasos y un gráfico de barras con las tarjetas que vencen cada uno de los próximos 14 días"></picture></td>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/deck-dark.png"><img src="docs/images/deck-light.png" width="260" alt="La lista del mazo: cada capital con su país, cuándo vence y cuánto se recuerda ahora, por ejemplo Hanoi vence ahora, con un 90 %"></picture></td>
</tr>
</table>

Las capturas proceden de la [app de ejemplo](Examples) en un simulador de iPhone 17 Pro con iOS 27 y las hace [`scripts/capture-screens.sh`](scripts/capture-screens.sh). La app se ejecuta en modo demostración con tres semanas de estudio simulado a partir de una semilla (seed) fija, de modo que cada captura muestra las mismas tarjetas. Para ejecutarla, abre `Examples/StudyDeck/StudyDeck.xcodeproj`, elige un simulador de iPhone o **My Mac** y ejecútala.

## Documentación

Referencia de la API y artículos:

- [Referencia de la API](https://muhittincamdali.github.io/educationai/documentation/educationai/)
  — cada tipo público con sus parámetros y límites.

## Guías

- [Primeros pasos](https://muhittincamdali.github.io/educationai/documentation/educationai/gettingstarted)
  — añadir el paquete, guardar un estado de repaso por tarjeta, poner en cola, repasar, guardar.
- [Programar repasos](https://muhittincamdali.github.io/educationai/documentation/educationai/schedulingreviews)
  — cómo funciona FSRS, las fases de aprendizaje, los ajustes y sus compromisos, SM-2 y la migración.
- [Crear cuestionarios](https://muhittincamdali.github.io/educationai/documentation/educationai/buildingquizzes)
  — preguntas a partir de tarjetas, sesiones de cuestionario, lo que perdona la calificación de respuestas escritas, pistas.
- [Seguir el progreso](https://muhittincamdali.github.io/educationai/documentation/educationai/trackingprogress)
  — previsión, estadísticas, rachas y dificultad adaptativa.

## Requisitos

| Plataforma | Versión mínima |
| ------------------- | ------------------ |
| iOS | 17 |
| macOS | 14 |
| tvOS | 17 |
| watchOS | 10 |
| visionOS | 1 |
| Herramientas | Swift 6.2 · Xcode 26+ |

El paquete usa solo Foundation. La app de ejemplo es para iOS y macOS.

## Arquitectura

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

- `FSRSScheduler` se divide en sus ajustes (`FSRSScheduler.swift`), las fórmulas de FSRS-6 escritas para seguir a `py-fsrs` operación por operación (`+Formulas`) y la máquina de estados con las comprobaciones de los valores guardados (`+Transition`).
- Nada mantiene una referencia ni un bloqueo: cada llamada recibe valores y devuelve valores, así que los tipos se pueden usar desde cualquier hilo o actor, y guardar en SwiftData, Core Data, archivos o iCloud.
- Los límites son explícitos: las respuestas de más de 500 caracteres no se comparan, las previsiones cubren como máximo 3650 días, las ventanas del ajustador guardan como máximo 1000 respuestas y la creación de cuestionarios elige las opciones incorrectas con un número fijo de sorteos.

## Hoja de ruta

Previsto, sin un orden fijo: entrenar los pesos de FSRS a partir de los registros de repaso de un estudiante (un optimizer, como tienen `py-fsrs` y `fsrs-rs`), FSRS-7 cuando las implementaciones de referencia lo adopten para programar, importar registros de repaso de Anki y repartir el vencimiento de las tarjetas entre los días para equilibrar la carga. Las sugerencias son bienvenidas en [issues](https://github.com/muhittincamdali/educationai/issues).

## Contribuir

Las contribuciones son bienvenidas. Lee la [guía de contribución](https://github.com/muhittincamdali/educationai/blob/main/CONTRIBUTING.md) y el [código de conducta](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) antes de abrir una pull request. Informa de los problemas de seguridad de forma privada, como se describe en la [política de seguridad](https://github.com/muhittincamdali/educationai/blob/main/SECURITY.md).

## Licencia

Publicado bajo la licencia MIT. Consulta [LICENSE](LICENSE).

Design notes: https://muhittincamdali.com/en/open-source/educationai/
