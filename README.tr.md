<!-- i18n-source: README.md@f9244ae8b5ee36d676748f903909a5d507c7a923 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/banner-tr-light.svg" alt="EducationAI: Swift uygulamaları için FSRS-6 ve SM-2 ile aralıklı tekrar, sınavlar, uyarlanabilir zorluk ve çalışma serileri."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml/badge.svg" alt="CI durumu"></a>
<a href="https://github.com/muhittincamdali/educationai/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-version-light.svg" alt="Son sürüm: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-platforms-light.svg" alt="Desteklenen platformlar: iOS 17+ · macOS 14+ · tvOS 17+ · watchOS 10+ · visionOS 1+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-language-light.svg" alt="Dil sürümü: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/badge-license-light.svg" alt="Lisans: MIT"></picture></a>
</p>

<p align="center">
<a href="#hızlı-başlangıç"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-start-tr-light.svg" alt="Başlayın"></picture></a>
<a href="https://muhittincamdali.github.io/educationai/documentation/educationai/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-docs-tr-light.svg" alt="Dokümantasyon"></picture></a>
<a href="https://github.com/muhittincamdali/educationai/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/educationai/main/.github/brand/button-examples-tr-light.svg" alt="Örnekler"></picture></a>
</p>

> Bu belge İngilizce README'nin çevirisidir. İkisi arasında fark varsa güncel olan İngilizce sürümdür.

<!-- brand:end -->

Bir flashcard veya çalışma uygulamasının öğrenme mantığını içeren bir Swift paketi. `FSRSScheduler`,
Anki'nin FSRS zamanlayıcısının arkasındaki bellek modeli olan FSRS-6 ile her kartın ne zaman
geri geleceğine karar verir ve referans uygulama `py-fsrs` 6.3.2 ile aynı sonuçları verir.
`SM2Scheduler` SM-2 verilerinin çalışmasını sürdürür ve ilerleme kaybetmeden FSRS'ye dönüştürür.
Zamanlayıcının çevresinde bir çalışma kuyruğu, yazım hatası toleransıyla yazılı cevap
değerlendirme, sınavlar, bir zorluk ayarlayıcı, iş yükü tahmini, tekrar istatistikleri ve
çalışma serileri bulunur. Her şey cihazda çalışır, hiçbir bağımlılığı yoktur ve Swift 6 katı
eşzamanlılığı (strict concurrency) için yazılmıştır.

<p align="center">
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/review-dark.png"><img src="docs/images/review-light.png" width="300" alt="Örnek uygulamanın tekrar ekranı: Capital of Vietnam kartı ve cevabı Hanoi, bellek %90, ve 10m Again, 1mo Hard, 2mo Good ve 3mo Easy etiketli dört puanlama düğmesi"></picture>
<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/quiz-dark.png"><img src="docs/images/quiz-light.png" width="300" alt="Yazılı cevaplı bir sınav sorusu, Capital of Morocco, cevap Raba: geri bildirim &quot;Almost, it is spelled Rabat&quot; diyor (bir yazım hatası var) ve kart Hard olarak zamanlanıyor"></picture>
</p>

## Öne çıkanlar

- **FSRS-6, referansa karşı doğrulandı** — testler, sekiz yapılandırmada `py-fsrs` 6.3.2 ile
  hesaplanmış 2.400 tekrarı yeniden oynatır ve her tekrardan sonra stability, difficulty, vade
  tarihi ve retrievability değerlerini karşılaştırır. Öğrenme ve yeniden öğrenme adımları,
  hedeflenen hatırlama oranı, en uzun aralık, aralık fuzz'ı ve özel ağırlıklar (FSRS-6'dan 21
  ya da FSRS-5'ten 19 ağırlık) desteklenir.
- **Servis değil, değer** — zamanlayıcılar, durumlar, sınavlar ve ayarlayıcılar `Sendable` ve
  `Codable` değer tipleridir. Her fonksiyon üzerinde çalışacağı tarihi parametre olarak alır ve
  rastgelelik, tohumlayabileceğiniz (seed) bir üreteçten gelir; böylece sonuçlar herhangi bir
  gün için test edilebilir.
- **Saklanan verilerde güvenli** — bir dosyadan ya da veritabanından geri okunan durumlar
  kullanılmadan önce denetlenir. NaN, sonsuz ya da negatif değerler çökme yerine hata fırlatır,
  sayaçlar `Int.max` değerinde durur ve kaydedilmiş bir sınav yüklenirken yeniden
  değerlendirilir.
- **Yazılı cevaplarda adil değerlendirme** — `AnswerMatcher` büyük/küçük harfi, aksanları,
  karakter genişliğini ve noktalamayı cihaz diline bağlı olmadan yok sayar, yazım hatalarını
  cevabın uzunluğuna göre hoş görür ve kötü niyetli girdide bile cevabın uzunluğuyla orantılı
  iş yapar.
- **Zamanlayıcının çevresindeki her şey** — günlük sınırları olan bir çalışma kuyruğu, SM-2 ve
  FSRS'ye geçişi, kartlardan üretilen çoktan seçmeli ve yazılı cevaplı sınavlar, cevap
  ipuçları, bir zorluk ayarlayıcı, günlük tahmin, hatırlama istatistikleri ve öğrencinin saat
  dilimine göre seriler.
- **Test edilmiş** — macOS'ta ve bir iOS simülatöründe çalıştırılan, README örneklerini de
  kapsayan 127 test.

## Hızlı başlangıç

**1. Paketi ekleyin**

Xcode'da **File › Add Package Dependencies…** menüsünü seçin ve depo adresini girin:

```text
https://github.com/muhittincamdali/educationai.git
```

Bunu pencerenin sağ üstündeki arama alanına yapıştırın. **Dependency Rule** ayarını `2.0.0`
sürümünden başlayan **Up to Next Major Version** olarak bırakın, ardından **Add Package**
düğmesine tıklayın. Sonraki pencerede **EducationAI** yanından uygulama hedefinizi seçin ve
yeniden **Add Package** düğmesine tıklayın.

**2. Modülü içe aktarın**

```swift
import EducationAI
```

Bu satırı, kartları göstereceğiniz Swift dosyasının en üstüne, `import SwiftUI` satırının
altına koyun.

**3. Kartları gösterin ve puanlayın**

Bu görünümü dosyaya ekleyin ve uygulamanızdan gösterin, örneğin `WindowGroup` içeriği olarak:

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

Uygulamayı çalıştırın. **Capital of Japan** görünür; **Show Answer** düğmesine, ardından
**Good** düğmesine dokunun. Kart 10 dakikalık öğrenme adımına geçer ve **Capital of Kenya**
görünür. Üç kart da puanlandığında görünüm **All done for now** der. Kartlar burada `@State`
içinde durur, bu yüzden bir sonraki açılışta baştan başlar; bunları nasıl saklayacağınızı aşağıdaki
[Desteyi kaydetme](#desteyi-kaydetme) bölümü gösterir.

## Kurulum

### Swift Package Manager

Xcode'da **File › Add Package Dependencies…** menüsünü seçin ve depo adresini girin:

```text
https://github.com/muhittincamdali/educationai.git
```

Ya da `Package.swift` dosyanızdaki `dependencies` listesine ekleyin:

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

## Kullanım

Aşağıdaki örnekler, örnek uygulamanın ve test paketinin derlediği ve testlerin çalıştırdığı
[ReadmeSamples.swift](Examples/StudyDeck/StudyDeck/ReadmeSamples.swift) dosyasından kopyalanmıştır.

### Her düğmede bir sonraki aralığı gösterme

Bir önizleme, dört puanın da sonucunu verir. Düğmeleri bununla etiketleyin ve öğrencinin
dokunduğu puanın sonucunu saklayın: bu, o puanla yapılan bir tekrarın verdiği sonucun aynısıdır.

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

İngilizce arayüzde bu, yeni bir kart için `Again · 1m`, `Hard · 6m` ve `Good · 10m` sonuçlarını,
`Easy` için ise yaklaşık bir haftayı verir (fuzz tam günü dağıtır).

### Ayarları seçme

Daha yüksek hatırlama oranı daha kısa aralıklar ve daha çok tekrar demektir. Aralık dışındaki
ayarlar hata fırlatır:

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

### Yazılı cevabı değerlendirme

```swift
func feedback(for answer: String, card: Flashcard) -> String {
    switch AnswerMatcher().evaluate(answer, acceptedAnswers: card.acceptedAnswers) {
    case .correct: "Correct"
    case .almostCorrect(let expected, _): "Almost: it is spelled \(expected)"
    case .incorrect: "The answer is \(card.back)"
    }
}
```

`Nairobi` için `"nairobi"` doğrudur, `"Nairbi"` neredeyse doğrudur (bir yazım hatası),
`"Mombasa"` ise doğru değildir. Aksanlar, harf büyüklüğü ve noktalama yok sayılır: `"Sao Paulo"`,
`"São Paulo"` ile eşleşir.

### Sınav yapma ve sonuçlardan zamanlama

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

Yanlış cevap **Again**, yazım hatalı cevap **Hard**, doğru cevap **Good** olarak zamanlanır.
`QuizBuilder.multipleChoice(from:choiceCount:using:)`, yanlış seçenekleri diğer kartların
cevaplarından oluşan çoktan seçmeli sorular üretir.

### SM-2 verilerini FSRS'ye taşıma

```swift
func migrate(easeFactor: Double, intervalDays: Int, due: Date, lastReview: Date) throws -> ReviewState {
    let sm2 = SM2State(easeFactor: easeFactor, repetitions: 4, interval: intervalDays, due: due, lastReview: lastReview)
    return try ReviewState(migrating: sm2, scheduler: .default)
}
```

Kart vade tarihini korur ve bir sonraki iyi tekrarında aralık yaklaşık eski kolaylık çarpanı
kadar büyür.

### İlerlemeyi gösterme

```swift
func progressSummary(deck: [Flashcard], logs: [ReviewLog], now: Date) -> String {
    let streak = StudyStreak(activityDates: logs.map(\.reviewedAt), now: now)
    let forecast = ReviewForecast(dueDates: deck.map(\.review.due), from: now, days: 7)
    let retention = ReviewStatistics(logs: logs).retention ?? 0
    return "\(streak.current)-day streak, \(forecast.days[0].count) due today, "
        + "\(forecast.totalCount) this week, \(Int((retention * 100).rounded())) % retained"
}
```

Her tekrar, yeni durumun yanında bir `ReviewLog` döndürür (`outcome.log`); istatistikler ve
seriler için bu kayıtları saklayın.

### Desteyi kaydetme

`Flashcard`, `ReviewState`, `ReviewLog`, `FSRSScheduler` ve `QuizSession` `Codable` olduğundan bir
deste bir JSON dosyasına sığar, örneğin `URL.documentsDirectory.appending(path: "deck.json")`
konumuna:

```swift
func save(_ deck: [Flashcard], to url: URL) throws {
    try JSONEncoder().encode(deck).write(to: url, options: .atomic)
}

func loadDeck(from url: URL) throws -> [Flashcard] {
    try JSONDecoder().decode([Flashcard].self, from: Data(contentsOf: url))
}
```

Dosyadaki, hiçbir tekrarın üretemeyeceği bir durum (NaN, negatif sayaç) uygulamayı çökertmek
yerine bir sonraki tekrarında `SchedulingError.invalidState` hatası fırlattırır.

Kendi modelinizi korumak için ona bir `ReviewState` özelliği ekleyin (tek bir `Codable` değerdir,
bu yüzden bir SwiftData özniteliğine sığar) ve
`StudyQueue.items(from:at:newLimit:reviewLimit:state:)` kullanın.

## Demo

<table>
<tr>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/progress-dark.png"><img src="docs/images/progress-light.png" width="260" alt="İlerleme ekranı: 21 günlük seri, en iyi seri 21, hatırlama %91, 84 tekrar ve önümüzdeki 14 günün her birinde vadesi gelen kartları gösteren bir çubuk grafik"></picture></td>
<td><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/deck-dark.png"><img src="docs/images/deck-light.png" width="260" alt="Deste listesi: her başkent ülkesiyle birlikte, vadesi ne zaman geldiği ve şu an ne kadar iyi hatırlandığı, örneğin Hanoi şimdi vadesi gelmiş ve %90"></picture></td>
</tr>
</table>

Ekran görüntüleri, iOS 27 çalıştıran bir iPhone 17 Pro simülatöründeki [örnek uygulamadan](Examples)
alınmıştır ve [`scripts/capture-screens.sh`](scripts/capture-screens.sh) ile yakalanmıştır.
Uygulama, sabit bir tohumdan (seed) üç haftalık simüle çalışmayla demo modunda çalışır; böylece
her yakalama aynı kartları gösterir. Çalıştırmak için `Examples/StudyDeck/StudyDeck.xcodeproj`
dosyasını açın, bir iPhone simülatörü ya da **My Mac** seçin ve çalıştırın.

## Dokümantasyon

API başvuru belgeleri ve makaleler:

- [API başvurusu](https://muhittincamdali.github.io/educationai/documentation/educationai/)
  — her herkese açık tip, parametreleri ve sınırlarıyla.

## Rehberler

- [Başlarken](https://muhittincamdali.github.io/educationai/documentation/educationai/gettingstarted)
  — paketi ekleyin, kart başına bir tekrar durumu tutun, kuyruğa alın, tekrar edin, kaydedin.
- [Tekrarları zamanlama](https://muhittincamdali.github.io/educationai/documentation/educationai/schedulingreviews)
  — FSRS nasıl çalışır, öğrenme aşamaları, ayarlar ve ödünleşimleri, SM-2 ve geçiş.
- [Sınav oluşturma](https://muhittincamdali.github.io/educationai/documentation/educationai/buildingquizzes)
  — kartlardan sorular, sınav oturumları, yazılı cevap değerlendirmesinin neyi hoş gördüğü,
  ipuçları.
- [İlerlemeyi izleme](https://muhittincamdali.github.io/educationai/documentation/educationai/trackingprogress)
  — tahmin, istatistikler, seriler ve uyarlanabilir zorluk.

## Gereksinimler

| Platform | En düşük sürüm |
| ------------------- | ------------------ |
| iOS | 17 |
| macOS | 14 |
| tvOS | 17 |
| watchOS | 10 |
| visionOS | 1 |
| Araç zinciri | Swift 6.2 · Xcode 26+ |

Paket yalnızca Foundation kullanır. Örnek uygulama iOS ve macOS içindir.

## Mimari

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

- `FSRSScheduler` üç parçaya ayrılmıştır: ayarları (`FSRSScheduler.swift`), `py-fsrs` ile işlem
  işlem aynı olacak biçimde yazılmış FSRS-6 formülleri (`+Formulas`) ve saklanan değerler
  üzerindeki denetimleri içeren durum makinesi (`+Transition`).
- Hiçbir şey referans ya da kilit tutmaz: her çağrı değer alır ve değer döndürür; bu yüzden tipler
  herhangi bir thread ya da actor'dan kullanılabilir ve SwiftData, Core Data, dosyalar ya da
  iCloud içinde saklanabilir.
- Sınırlar açıktır: 500 karakterden uzun cevaplar karşılaştırılmaz, tahminler en fazla 3.650
  günü kapsar, ayarlayıcı pencereleri en fazla 1.000 cevap tutar ve sınav oluşturma yanlış
  seçenekleri sabit sayıda çekilişle seçer.

## Yol haritası

Planlananlar, belirli bir sırayla değil: FSRS ağırlıklarını bir öğrencinin tekrar kayıtlarından
eğitme (`py-fsrs` ve `fsrs-rs`'de olduğu gibi bir optimizer), referans uygulamalar
zamanlama için benimsedikten sonra FSRS-7, Anki tekrar kayıtlarını içe aktarma ve vade
tarihlerinin günlere dengeli dağıtılması. Önerilerinizi
[issues](https://github.com/muhittincamdali/educationai/issues) bölümünde bekleriz.

## Katkıda bulunma

Katkılarınızı bekliyoruz. Pull request açmadan önce [katkı rehberini](https://github.com/muhittincamdali/educationai/blob/main/CONTRIBUTING.md) ve [davranış kurallarını](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) okuyun. Güvenlik açıklarını [güvenlik politikasında](https://github.com/muhittincamdali/educationai/blob/main/SECURITY.md) anlatıldığı gibi gizli olarak bildirin.

## Lisans

MIT lisansıyla yayımlanmıştır. Ayrıntılar için [LICENSE](LICENSE) dosyasına bakın.

Design notes: https://muhittincamdali.com/open-source/educationai/ · English: https://muhittincamdali.com/en/open-source/educationai/
