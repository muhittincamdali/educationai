<!-- i18n-source: README.md@206b5843162b9156a1841bf924fe7ad48029f18a status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-pt-BR-light.svg" alt="EducationAI: Repetição espaçada com FSRS-6 e SM-2, quizzes, dificuldade adaptativa e sequências para apps em Swift."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml/badge.svg" alt="Status da CI"></a>
<a href="https://github.com/muhittincamdali/educationai/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg" alt="Versão mais recente: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg" alt="Plataformas compatíveis: iOS 17+ · macOS 14+ · tvOS 17+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg" alt="Versão da linguagem: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg" alt="Licença: MIT"></picture></a>
</p>

<p align="center">
<a href="#início-rápido"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-pt-BR-light.svg" alt="Começar"></picture></a>
<a href="https://muhittincamdali.github.io/educationai/documentation/educationai/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-pt-BR-light.svg" alt="Documentação"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-pt-BR-light.svg" alt="Exemplos"></picture></a>
</p>

> Esta é uma tradução do README em inglês. Se houver diferença, vale a versão em inglês.

<!-- brand:end -->

Um pacote Swift com a lógica de aprendizado de um app de flashcards ou de estudo. O `FSRSScheduler` decide quando cada cartão volta com o FSRS-6, o modelo de memória por trás do agendador FSRS do Anki, e dá os mesmos resultados que a implementação de referência, o `py-fsrs` 6.3.2. O `SM2Scheduler` mantém os dados do SM-2 funcionando e os converte para FSRS sem perder o progresso. Em volta do agendador há uma fila de estudo, a correção de respostas digitadas com tolerância a erros de digitação, quizzes, um ajustador de dificuldade, uma previsão de carga de trabalho, estatísticas de revisão e sequências de estudo. Tudo roda no dispositivo, não tem dependências e foi escrito para a concorrência estrita (strict concurrency) do Swift 6.

<p align="center">
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/review-dark.png"><img src="docs/images/review-light.png" width="300" alt="A tela de revisão do app de exemplo: o cartão Capital of Vietnam com a resposta Hanoi, memória em 90 % e quatro botões de avaliação com os rótulos 10m Again, 1mo Hard, 2mo Good e 3mo Easy"></picture>
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/quiz-dark.png"><img src="docs/images/quiz-light.png" width="300" alt="Uma pergunta de quiz com resposta digitada, Capital of Morocco, respondida com Raba: o feedback diz &quot;Almost, it is spelled Rabat&quot; (um erro de digitação) e o cartão é agendado como Hard"></picture>
</p>

## Destaques

- **FSRS-6, conferido com a referência** — os testes reproduzem 2.400 revisões calculadas pelo `py-fsrs` 6.3.2 em oito configurações e comparam stability, difficulty, data de vencimento e retrievability após cada revisão. Há suporte a etapas de aprendizado e de reaprendizado, retenção desejada, intervalo máximo, fuzz de intervalo e pesos personalizados (21 do FSRS-6 ou 19 do FSRS-5).
- **Valores, não serviços** — agendadores, estados, quizzes e ajustadores são tipos de valor `Sendable` e `Codable`. Toda função recebe a data com que trabalha, e a aleatoriedade vem de um gerador ao qual você pode dar um seed, de modo que os resultados podem ser testados para qualquer dia.
- **Seguro com dados salvos** — os estados lidos de um arquivo ou de um banco de dados são verificados antes do uso. Valores NaN, infinitos ou negativos lançam um erro em vez de travar o app, os contadores param em `Int.max` e um quiz salvo é corrigido de novo quando é carregado.
- **Respostas digitadas tratadas com justiça** — o `AnswerMatcher` ignora maiúsculas e minúsculas, acentos, largura dos caracteres e pontuação sem depender do idioma do dispositivo, perdoa erros de digitação conforme o tamanho da resposta e faz um trabalho proporcional a esse tamanho, mesmo com entradas hostis.
- **Tudo em volta do agendador** — uma fila de estudo com limites diários, o SM-2 e sua migração para o FSRS, quizzes de múltipla escolha e de resposta digitada criados a partir dos cartões, dicas de resposta, um ajustador de dificuldade, uma previsão por dia, estatísticas de retenção e sequências no fuso horário do aluno.
- **Testado** — 124 testes, executados no macOS e em um simulador de iOS, incluindo os exemplos do README.

## Início rápido

**1. Adicione o pacote**

No Xcode, escolha **File › Add Package Dependencies…** e informe a URL do repositório:

```text
https://github.com/muhittincamdali/educationai.git
```

Cole-o no campo de busca, no canto superior direito da janela. Deixe **Dependency Rule** em **Up to Next Major Version** a partir de `2.0.0` e clique em **Add Package**. Na janela seguinte, escolha o target do seu app ao lado de **EducationAI** e clique em **Add Package** de novo.

**2. Importe o módulo**

```swift
import EducationAI
```

Coloque esta linha no início do arquivo Swift em que você vai mostrar os cartões, abaixo de `import SwiftUI`.

**3. Mostrar os cartões e avaliá-los**

Adicione esta view ao arquivo e exiba-a no seu app, por exemplo como o conteúdo do seu `WindowGroup`:

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

Execute o app. Ele mostra **Capital of Japan**; toque em **Show Answer** e depois em **Good**. O cartão passa para a etapa de aprendizado de 10 minutos e **Capital of Kenya** aparece. Quando os três são avaliados, a view diz **All done for now**. Aqui os cartões ficam em `@State`, então recomeçam na próxima abertura; [Salvar o baralho](#salvar-o-baralho), mais abaixo, mostra como guardá-los.

## Instalação

### Swift Package Manager

No Xcode, escolha **File › Add Package Dependencies…** e informe a URL do repositório:

```text
https://github.com/muhittincamdali/educationai.git
```

Ou adicione-o às `dependencies` do seu `Package.swift`:

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

Os exemplos abaixo foram copiados de [ReadmeSamples.swift](Examples/StudyDeck/StudyDeck/ReadmeSamples.swift), que o app de exemplo e a suíte de testes compilam e que os testes executam.

### Mostrar o próximo intervalo em cada botão

Uma prévia dá o resultado das quatro avaliações. Use-a para rotular os botões e salve o resultado daquela em que o aluno tocar: é o mesmo resultado que uma revisão com essa avaliação dá.

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

Em inglês, isso dá `Again · 1m`, `Hard · 6m` e `Good · 10m` para um cartão novo, e cerca de uma semana para `Easy` (o fuzz espalha o dia exato).

### Escolher as configurações

Uma retenção mais alta significa intervalos mais curtos e mais revisões. Configurações fora do intervalo lançam um erro:

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

### Corrigir uma resposta digitada

```swift
func feedback(for answer: String, card: Flashcard) -> String {
    switch AnswerMatcher().evaluate(answer, acceptedAnswers: card.acceptedAnswers) {
    case .correct: "Correct"
    case .almostCorrect(let expected, _): "Almost: it is spelled \(expected)"
    case .incorrect: "The answer is \(card.back)"
    }
}
```

`"nairobi"` está correto para `Nairobi`, `"Nairbi"` está quase correto (um erro de digitação) e `"Mombasa"` não está. Acentos, maiúsculas e minúsculas e pontuação são ignorados: `"Sao Paulo"` corresponde a `"São Paulo"`.

### Aplicar um quiz e agendar a partir dos resultados

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

Uma resposta errada é agendada como **Again**, uma com erros de digitação como **Hard** e uma certa como **Good**. O `QuizBuilder.multipleChoice(from:choiceCount:using:)` cria perguntas de múltipla escolha cujas alternativas erradas são respostas de outros cartões.

### Migrar dados do SM-2 para o FSRS

```swift
func migrate(easeFactor: Double, intervalDays: Int, due: Date, lastReview: Date) throws -> ReviewState {
    let sm2 = SM2State(easeFactor: easeFactor, repetitions: 4, interval: intervalDays, due: due, lastReview: lastReview)
    return try ReviewState(migrating: sm2, scheduler: .default)
}
```

O cartão mantém a data de vencimento, e a próxima boa revisão faz o intervalo crescer aproximadamente pelo seu antigo fator de facilidade (easiness factor).

### Mostrar o progresso

```swift
func progressSummary(deck: [Flashcard], logs: [ReviewLog], now: Date) -> String {
    let streak = StudyStreak(activityDates: logs.map(\.reviewedAt), now: now)
    let forecast = ReviewForecast(dueDates: deck.map(\.review.due), from: now, days: 7)
    let retention = ReviewStatistics(logs: logs).retention ?? 0
    return "\(streak.current)-day streak, \(forecast.days[0].count) due today, "
        + "\(forecast.totalCount) this week, \(Int((retention * 100).rounded())) % retained"
}
```

Cada revisão devolve um `ReviewLog` junto com o novo estado (`outcome.log`); guarde os logs para as estatísticas e as sequências.

### Salvar o baralho

`Flashcard`, `ReviewState`, `ReviewLog`, `FSRSScheduler` e `QuizSession` são `Codable`, então um baralho cabe em um arquivo JSON, por exemplo em `URL.documentsDirectory.appending(path: "deck.json")`:

```swift
func save(_ deck: [Flashcard], to url: URL) throws {
    try JSONEncoder().encode(deck).write(to: url, options: .atomic)
}

func loadDeck(from url: URL) throws -> [Flashcard] {
    try JSONDecoder().decode([Flashcard].self, from: Data(contentsOf: url))
}
```

Um estado no arquivo que nenhuma revisão poderia ter produzido (NaN, um contador negativo) faz a próxima revisão dele lançar `SchedulingError.invalidState` em vez de travar o app.

Para manter o seu próprio modelo, adicione a ele uma propriedade `ReviewState` (é um único valor `Codable`, então cabe em um atributo do SwiftData) e use `StudyQueue.items(from:at:newLimit:reviewLimit:state:)`.

## Demonstração

<table>
<tr>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/progress-dark.png"><img src="docs/images/progress-light.png" width="260" alt="A tela de progresso: uma sequência de 21 dias, melhor sequência de 21, retenção de 91 %, 84 revisões e um gráfico de barras com os cartões que vencem em cada um dos próximos 14 dias"></picture></td>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/deck-dark.png"><img src="docs/images/deck-light.png" width="260" alt="A lista do baralho: cada capital com o seu país, quando vence e o quanto está lembrada agora, por exemplo Hanoi vence agora, com 90 %"></picture></td>
</tr>
</table>

As capturas de tela vêm do [app de exemplo](Examples) em um simulador de iPhone 17 Pro com iOS 27 e foram feitas por [`scripts/capture-screens.sh`](scripts/capture-screens.sh). O app roda em modo de demonstração, com três semanas de estudo simulado a partir de um seed fixo, de modo que cada captura mostra os mesmos cartões. Para executá-lo, abra `Examples/StudyDeck/StudyDeck.xcodeproj`, escolha um simulador de iPhone ou **My Mac** e execute.

## Documentação

Referência da API e artigos:

- [Referência da API](https://muhittincamdali.github.io/educationai/documentation/educationai/)
  — cada tipo público com seus parâmetros e limites.

## Guias

- [Primeiros passos](https://muhittincamdali.github.io/educationai/documentation/educationai/gettingstarted)
  — adicionar o pacote, manter um estado de revisão por cartão, enfileirar, revisar, salvar.
- [Agendar revisões](https://muhittincamdali.github.io/educationai/documentation/educationai/schedulingreviews)
  — como o FSRS funciona, as fases de aprendizado, as configurações e seus compromissos, o SM-2 e a migração.
- [Criar quizzes](https://muhittincamdali.github.io/educationai/documentation/educationai/buildingquizzes)
  — perguntas a partir de cartões, sessões de quiz, o que a correção de respostas digitadas perdoa, dicas.
- [Acompanhar o progresso](https://muhittincamdali.github.io/educationai/documentation/educationai/trackingprogress)
  — previsão, estatísticas, sequências e dificuldade adaptativa.

## Requisitos

| Plataforma | Versão mínima |
| ------------------- | ------------------ |
| iOS | 17 |
| macOS | 14 |
| tvOS | 17 |
| watchOS | 10 |
| visionOS | 1 |
| Ferramentas | Swift 6.2 · Xcode 26+ |

O pacote usa apenas o Foundation. O app de exemplo é para iOS e macOS.

## Arquitetura

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

- O `FSRSScheduler` se divide em suas configurações (`FSRSScheduler.swift`), as fórmulas do FSRS-6 escritas para seguir o `py-fsrs` operação por operação (`+Formulas`) e a máquina de estados com as verificações dos valores salvos (`+Transition`).
- Nada guarda uma referência ou um lock: cada chamada recebe valores e devolve valores, então os tipos podem ser usados em qualquer thread ou actor e armazenados no SwiftData, no Core Data, em arquivos ou no iCloud.
- Os limites são explícitos: respostas com mais de 500 caracteres não são comparadas, as previsões cobrem no máximo 3.650 dias, as janelas do ajustador guardam no máximo 1.000 respostas, e a criação de quizzes sorteia as alternativas erradas com um número fixo de sorteios.

## Roteiro

Planejado, sem ordem fixa: treinar os pesos do FSRS a partir dos logs de revisão de um aluno (um optimizer, como o `py-fsrs` e o `fsrs-rs` têm), o FSRS-7 quando as implementações de referência o adotarem para o agendamento, a importação de logs de revisão do Anki e o balanceamento de carga dos vencimentos entre os dias. Sugestões são bem-vindas nas [issues](https://github.com/muhittincamdali/educationai/issues).

## Como contribuir

Contribuições são bem-vindas. Leia o [guia de contribuição](https://github.com/muhittincamdali/educationai/blob/main/CONTRIBUTING.md) e o [código de conduta](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) antes de abrir um pull request. Relate problemas de segurança de forma privada, como descrito na [política de segurança](https://github.com/muhittincamdali/educationai/blob/main/SECURITY.md).

## Licença

Publicado sob a licença MIT. Veja [LICENSE](LICENSE).
