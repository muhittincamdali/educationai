<!-- i18n-source: README.md@7e5d2498de0a83ef497d3257da5bd07dce0afcac status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-de-light.svg" alt="EducationAI: Verteilte Wiederholung mit FSRS-6 und SM-2, Quizze, adaptive Schwierigkeit und Lernserien für Swift-Apps."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml/badge.svg" alt="CI-Status"></a>
<a href="https://github.com/muhittincamdali/educationai/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg" alt="Aktuelle Version: v2.1.0"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg" alt="Unterstützte Plattformen: iOS 17+ · macOS 14+ · tvOS 17+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg" alt="Sprachversion: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg" alt="Lizenz: MIT"></picture></a>
</p>

<p align="center">
<a href="#schnellstart"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-de-light.svg" alt="Loslegen"></picture></a>
<a href="https://muhittincamdali.github.io/educationai/documentation/educationai/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-de-light.svg" alt="Dokumentation"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-de-light.svg" alt="Beispiele"></picture></a>
</p>

> Dies ist eine Übersetzung der englischen README. Bei Abweichungen gilt die englische Fassung.

<!-- brand:end -->

Ein Swift-Paket mit der Lernlogik einer Karteikarten- oder Lern-App. `FSRSScheduler` bestimmt mit FSRS-6, dem Gedächtnismodell hinter dem FSRS-Scheduler von Anki, wann jede Karte wiederkommt, und liefert dieselben Ergebnisse wie die Referenzimplementierung `py-fsrs` 6.3.2. `SM2Scheduler` hält SM-2-Daten nutzbar und wandelt sie ohne Fortschrittsverlust in FSRS um. Rund um den Scheduler gibt es eine Lernwarteschlange, die Bewertung getippter Antworten mit Tippfehlertoleranz, Quizze, einen Schwierigkeitsanpasser, eine Arbeitsaufwandsprognose, Wiederholungsstatistiken und Lernserien. Alles läuft auf dem Gerät, hat keine Abhängigkeiten und ist für Swift 6 Strict Concurrency geschrieben.

<p align="center">
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/review-dark.png"><img src="docs/images/review-light.png" width="300" alt="Der Wiederholungsbildschirm der Beispiel-App: die Karte Capital of Vietnam mit der Antwort Hanoi, Gedächtnis bei 90 % und vier Bewertungsschaltflächen mit den Beschriftungen 10m Again, 1mo Hard, 2mo Good und 3mo Easy"></picture>
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/quiz-dark.png"><img src="docs/images/quiz-light.png" width="300" alt="Eine Quizfrage mit getippter Antwort, Capital of Morocco, beantwortet mit Raba: Die Rückmeldung lautet &quot;Almost, it is spelled Rabat&quot; (ein Tippfehler), und die Karte wird als Hard eingeplant"></picture>
</p>

## Highlights

- **FSRS-6, gegen die Referenz geprüft** — Die Tests spielen 2.400 mit `py-fsrs` 6.3.2 berechnete Wiederholungen in acht Konfigurationen nach und vergleichen nach jeder Wiederholung stability, difficulty, Fälligkeitsdatum und retrievability. Lern- und Wiederlernschritte, gewünschte Behaltensrate, maximales Intervall, Intervall-fuzz und eigene Gewichte (21 aus FSRS-6 oder 19 aus FSRS-5) werden unterstützt.
- **Werte statt Services** — Scheduler, Zustände, Quizze und Anpasser sind `Sendable`- und `Codable`-Werttypen. Jede Funktion bekommt das Datum, mit dem sie arbeitet, und der Zufall stammt aus einem Generator, dem du einen Seed geben kannst, sodass sich Ergebnisse für jeden beliebigen Tag testen lassen.
- **Sicher bei gespeicherten Daten** — Zustände, die aus einer Datei oder einer Datenbank zurückgelesen werden, werden vor der Verwendung geprüft. NaN, unendliche oder negative Werte lösen einen Fehler aus, statt abzustürzen, Zähler bleiben bei `Int.max` stehen, und ein gespeichertes Quiz wird beim Laden erneut bewertet.
- **Faire getippte Antworten** — `AnswerMatcher` ignoriert Groß- und Kleinschreibung, Akzente, Zeichenbreite und Satzzeichen, ohne von der Gerätesprache abzuhängen, verzeiht Tippfehler abhängig von der Antwortlänge und arbeitet proportional zur Länge der Antwort, selbst bei böswilliger Eingabe.
- **Alles rund um den Scheduler** — eine Lernwarteschlange mit Tageslimits, SM-2 und seine Migration zu FSRS, aus Karten erzeugte Multiple-Choice- und Tippquizze, Antworthinweise, ein Schwierigkeitsanpasser, eine Prognose pro Tag, Behaltensstatistiken und Serien in der Zeitzone der lernenden Person.
- **Getestet** — 127 Tests, die auf macOS und in einem iOS-Simulator laufen, einschließlich der README-Beispiele.

## Schnellstart

**1. Paket hinzufügen**

Wähle in Xcode **File › Add Package Dependencies…** und gib die Repository-URL ein:

```text
https://github.com/muhittincamdali/educationai.git
```

Füge sie oben rechts im Fenster in das Suchfeld ein. Lass **Dependency Rule** auf **Up to Next Major Version** ab `2.0.0` stehen und klicke dann auf **Add Package**. Wähle im nächsten Fenster neben **EducationAI** dein App-Target aus und klicke erneut auf **Add Package**.

**2. Modul importieren**

```swift
import EducationAI
```

Setze diese Zeile oben in die Swift-Datei, in der du die Karten anzeigen wirst, unter `import SwiftUI`.

**3. Karten anzeigen und bewerten**

Füge diese View der Datei hinzu und zeige sie in deiner App an, zum Beispiel als Inhalt deiner `WindowGroup`:

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

Starte die App. Sie zeigt **Capital of Japan**; tippe auf **Show Answer** und dann auf **Good**. Die Karte wechselt in ihren 10-Minuten-Lernschritt, und **Capital of Kenya** erscheint. Sind alle drei bewertet, steht in der View **All done for now**. Die Karten liegen hier in `@State`, beginnen also beim nächsten Start von vorn; [Das Deck speichern](#das-deck-speichern) weiter unten zeigt, wie du sie behältst.

## Installation

### Swift Package Manager

Wähle in Xcode **File › Add Package Dependencies…** und gib die Repository-URL ein:

```text
https://github.com/muhittincamdali/educationai.git
```

Oder füge es zu den `dependencies` in deiner `Package.swift` hinzu:

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

## Verwendung

Die folgenden Beispiele sind aus [ReadmeSamples.swift](Examples/StudyDeck/StudyDeck/ReadmeSamples.swift) kopiert, das die Beispiel-App und die Testsuite kompilieren und das die Tests ausführen.

### Das nächste Intervall auf jeder Schaltfläche anzeigen

Eine Vorschau liefert das Ergebnis aller vier Bewertungen. Beschrifte die Schaltflächen damit und speichere das Ergebnis der Bewertung, auf die die lernende Person tippt: Es ist dasselbe Ergebnis, das eine Wiederholung mit dieser Bewertung liefert.

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

Auf Englisch ergibt das für eine neue Karte `Again · 1m`, `Hard · 6m` und `Good · 10m`, für `Easy` etwa eine Woche (fuzz verteilt den genauen Tag).

### Die Einstellungen wählen

Eine höhere Behaltensrate bedeutet kürzere Intervalle und mehr Wiederholungen. Einstellungen außerhalb des gültigen Bereichs lösen einen Fehler aus:

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

### Eine getippte Antwort bewerten

```swift
func feedback(for answer: String, card: Flashcard) -> String {
    switch AnswerMatcher().evaluate(answer, acceptedAnswers: card.acceptedAnswers) {
    case .correct: "Correct"
    case .almostCorrect(let expected, _): "Almost: it is spelled \(expected)"
    case .incorrect: "The answer is \(card.back)"
    }
}
```

`"nairobi"` ist für `Nairobi` richtig, `"Nairbi"` ist fast richtig (ein Tippfehler), `"Mombasa"` nicht. Akzente, Groß- und Kleinschreibung und Satzzeichen werden ignoriert: `"Sao Paulo"` entspricht `"São Paulo"`.

### Ein Quiz durchführen und anhand der Ergebnisse einplanen

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

Eine falsche Antwort wird als **Again** eingeplant, eine Antwort mit Tippfehlern als **Hard**, eine richtige als **Good**. `QuizBuilder.multipleChoice(from:choiceCount:using:)` erzeugt Multiple-Choice-Fragen, deren falsche Auswahlmöglichkeiten die Antworten anderer Karten sind.

### SM-2-Daten zu FSRS übernehmen

```swift
func migrate(easeFactor: Double, intervalDays: Int, due: Date, lastReview: Date) throws -> ReviewState {
    let sm2 = SM2State(easeFactor: easeFactor, repetitions: 4, interval: intervalDays, due: due, lastReview: lastReview)
    return try ReviewState(migrating: sm2, scheduler: .default)
}
```

Die Karte behält ihr Fälligkeitsdatum, und bei ihrer nächsten guten Wiederholung wächst das Intervall ungefähr um ihren alten Leichtigkeitsfaktor (easiness factor).

### Den Fortschritt anzeigen

```swift
func progressSummary(deck: [Flashcard], logs: [ReviewLog], now: Date) -> String {
    let streak = StudyStreak(activityDates: logs.map(\.reviewedAt), now: now)
    let forecast = ReviewForecast(dueDates: deck.map(\.review.due), from: now, days: 7)
    let retention = ReviewStatistics(logs: logs).retention ?? 0
    return "\(streak.current)-day streak, \(forecast.days[0].count) due today, "
        + "\(forecast.totalCount) this week, \(Int((retention * 100).rounded())) % retained"
}
```

Jede Wiederholung gibt neben dem neuen Zustand ein `ReviewLog` zurück (`outcome.log`); bewahre die Logs für Statistiken und Serien auf.

### Das Deck speichern

`Flashcard`, `ReviewState`, `ReviewLog`, `FSRSScheduler` und `QuizSession` sind `Codable`, daher passt ein Deck in eine JSON-Datei, zum Beispiel unter `URL.documentsDirectory.appending(path: "deck.json")`:

```swift
func save(_ deck: [Flashcard], to url: URL) throws {
    try JSONEncoder().encode(deck).write(to: url, options: .atomic)
}

func loadDeck(from url: URL) throws -> [Flashcard] {
    try JSONDecoder().decode([Flashcard].self, from: Data(contentsOf: url))
}
```

Ein Zustand in der Datei, den keine Wiederholung hätte erzeugen können (NaN, ein negativer Zähler), lässt die nächste Wiederholung `SchedulingError.invalidState` auslösen, statt die App abstürzen zu lassen.

Um dein eigenes Modell zu behalten, füge ihm eine `ReviewState`-Eigenschaft hinzu (sie ist ein einzelner `Codable`-Wert und passt daher in ein SwiftData-Attribut) und verwende `StudyQueue.items(from:at:newLimit:reviewLimit:state:)`.

## Demo

<table>
<tr>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/progress-dark.png"><img src="docs/images/progress-light.png" width="260" alt="Der Fortschrittsbildschirm: eine Serie von 21 Tagen, beste Serie 21, Behaltensrate 91 %, 84 Wiederholungen und ein Balkendiagramm der Karten, die an jedem der nächsten 14 Tage fällig sind"></picture></td>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/deck-dark.png"><img src="docs/images/deck-light.png" width="260" alt="Die Deckliste: jede Hauptstadt mit ihrem Land, wann sie fällig ist und wie gut sie gerade behalten wird, zum Beispiel Hanoi jetzt fällig bei 90 %"></picture></td>
</tr>
</table>

Die Screenshots stammen aus der [Beispiel-App](Examples) auf einem iPhone-17-Pro-Simulator mit iOS 27 und wurden mit [`scripts/capture-screens.sh`](scripts/capture-screens.sh) aufgenommen. Die App läuft im Demomodus mit drei Wochen simuliertem Lernen aus einem festen Seed, sodass jede Aufnahme dieselben Karten zeigt. Zum Ausführen öffnest du `Examples/StudyDeck/StudyDeck.xcodeproj`, wählst einen iPhone-Simulator oder **My Mac** und startest die App.

## Dokumentation

API-Referenz und Artikel:

- [API-Referenz](https://muhittincamdali.github.io/educationai/documentation/educationai/)
  — jeder öffentliche Typ mit seinen Parametern und Grenzen.

## Anleitungen

- [Erste Schritte](https://muhittincamdali.github.io/educationai/documentation/educationai/gettingstarted)
  — das Paket hinzufügen, pro Karte einen Wiederholungszustand führen, einreihen, wiederholen, speichern.
- [Wiederholungen planen](https://muhittincamdali.github.io/educationai/documentation/educationai/schedulingreviews)
  — wie FSRS funktioniert, die Lernphasen, Einstellungen und ihre Abwägungen, SM-2 und Migration.
- [Quizze erstellen](https://muhittincamdali.github.io/educationai/documentation/educationai/buildingquizzes)
  — Fragen aus Karten, Quizsitzungen, was die Bewertung getippter Antworten verzeiht, Hinweise.
- [Fortschritt verfolgen](https://muhittincamdali.github.io/educationai/documentation/educationai/trackingprogress)
  — Prognose, Statistiken, Serien und adaptive Schwierigkeit.

## Voraussetzungen

| Plattform | Mindestversion |
| ------------------- | ------------------ |
| iOS | 17 |
| macOS | 14 |
| tvOS | 17 |
| watchOS | 10 |
| visionOS | 1 |
| Toolchain | Swift 6.2 · Xcode 26+ |

Das Paket verwendet nur Foundation. Die Beispiel-App ist für iOS und macOS.

## Architektur

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

- `FSRSScheduler` ist in seine Einstellungen (`FSRSScheduler.swift`), die FSRS-6-Formeln, die `py-fsrs` Operation für Operation folgen (`+Formulas`), und die Zustandsmaschine mit den Prüfungen der gespeicherten Werte (`+Transition`) aufgeteilt.
- Nichts hält eine Referenz oder eine Sperre: Jeder Aufruf nimmt Werte und gibt Werte zurück, sodass die Typen von jedem Thread oder Actor aus verwendet und in SwiftData, Core Data, Dateien oder iCloud gespeichert werden können.
- Die Grenzen sind ausdrücklich festgelegt: Antworten mit mehr als 500 Zeichen werden nicht verglichen, Prognosen decken höchstens 3.650 Tage ab, die Fenster des Anpassers fassen höchstens 1.000 Antworten, und das Erstellen von Quizzen wählt falsche Auswahlmöglichkeiten mit einer festen Anzahl von Ziehungen.

## Roadmap

Geplant, in keiner festen Reihenfolge: FSRS-Gewichte aus den Wiederholungslogs einer lernenden Person trainieren (ein optimizer, wie ihn `py-fsrs` und `fsrs-rs` haben), FSRS-7, sobald die Referenzimplementierungen es für die Planung übernehmen, der Import von Anki-Wiederholungslogs und der Lastausgleich der Fälligkeitsdaten über die Tage. Vorschläge sind in den [issues](https://github.com/muhittincamdali/educationai/issues) willkommen.

## Mitwirken

Beiträge sind willkommen. Lies vor einem Pull Request den [Leitfaden für Beiträge](https://github.com/muhittincamdali/educationai/blob/main/CONTRIBUTING.md) und den [Verhaltenskodex](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md). Sicherheitsprobleme meldest du vertraulich, wie in der [Sicherheitsrichtlinie](https://github.com/muhittincamdali/educationai/blob/main/SECURITY.md) beschrieben.

## Lizenz

Veröffentlicht unter der MIT-Lizenz. Siehe [LICENSE](LICENSE).

Design notes: https://muhittincamdali.com/en/open-source/educationai/
