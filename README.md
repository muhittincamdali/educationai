<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-FA7343?style=for-the-badge&logo=swift&logoColor=white" alt="Swift 6.0"/>
  <img src="https://img.shields.io/badge/Platform-iOS%20|%20macOS%20|%20visionOS-007AFF?style=for-the-badge&logo=apple&logoColor=white" alt="Platform"/>
  <img src="https://img.shields.io/badge/Standard-Unified%20Core-5856D6?style=for-the-badge" alt="Standard"/>
</p>

---

> **🛡️ PART OF THE 2026 UNIFIED CORE**
> This repository is a verified component of 'The Endless March' initiative. Purified for Swift 6, zero-dependency, and engineered for maximum hardware saturation.
> 
> *Flagship Engines:* [SwiftNetwork](https://github.com/muhittincamdali/SwiftNetwork) | [SwiftAI](https://github.com/muhittincamdali/SwiftAI) | [LiquidGlassKit](https://github.com/muhittincamdali/LiquidGlassKit)

---

<h1 align="center">EducationAI</h1>

## 🚀 Killer Feature: Adaptive Neural Tutor
Why use static quizzes? Powered by `SwiftAI`, the `AdaptiveNeuralTutor` uses on-device SIMD kernels to calculate the user's learning vector in real-time, seamlessly adjusting difficulty without a single server call.

<p align="center">
  <strong>Privacy-first adaptive learning framework for Apple platforms</strong>
</p>

<p align="center">
  <a href="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml">
    <img src="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml/badge.svg" alt="CI Status"/>
  </a>
  <img src="https://img.shields.io/badge/Swift-5.9+-FA7343?style=flat-square&logo=swift&logoColor=white" alt="Swift 5.9+"/>
  <img src="https://img.shields.io/badge/iOS-15.0+-000000?style=flat-square&logo=apple&logoColor=white" alt="iOS 15.0+"/>
  <img src="https://img.shields.io/badge/macOS-12.0+-000000?style=flat-square&logo=apple&logoColor=white" alt="macOS 12.0+"/>
  <img src="https://img.shields.io/badge/SPM-Compatible-FA7343?style=flat-square&logo=swift&logoColor=white" alt="SPM"/>
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License"/>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#documentation">Documentation</a>
</p>

---

## Why EducationAI?

Most learning apps treat every user the same. **EducationAI** brings six powerful learning engines into a single Swift package — all running on-device with zero server dependency. No data ever leaves the user's phone.

```swift
let engine = EducationAI()

// One function call keeps everything in sync
let result = engine.recordStudy(card: flashcard, rating: .good, responseTime: 3.5)

print("Next review:", result.nextReviewDate)   // Spaced repetition
print("XP earned:", result.xpEarned)            // Gamification
print("Streak:", result.currentStreak)           // Daily streak
print("New badges:", result.newBadges)           // Achievement system
```

## Features

| Engine | What it does |
|--------|-------------|
| 🧠 **Spaced Repetition** | SM-2 algorithm schedules reviews at optimal intervals |
| 📝 **Quiz Generation** | Auto-generates quizzes from flashcard decks (MC, T/F, fill-in-the-blank) |
| 📈 **Adaptive Difficulty** | Real-time difficulty adjustment based on sliding-window performance |
| 📊 **Progress Tracking** | Per-subject mastery, accuracy, study time, and event history |
| 🎯 **Content Recommendation** | Suggests what to study next based on overdue, weak, and new content |
| 🏆 **Gamification** | XP, levels, streaks, and 14 badge types to keep learners engaged |

### Privacy First

- **100% on-device** — all processing happens locally
- **No network calls** — works completely offline
- **No analytics SDKs** — zero third-party tracking
- **COPPA/FERPA/GDPR** friendly by design

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/educationai.git", from: "1.0.0")
]
```

Then add `"EducationAI"` to your target's dependencies.

### Requirements

| Platform | Minimum Version |
|----------|----------------|
| iOS      | 15.0+          |
| macOS    | 12.0+          |
| watchOS  | 8.0+           |
| tvOS     | 15.0+          |

## Quick Start

### 1. Create Flashcards

```swift
import EducationAI

let subject = Subject(name: "Spanish Vocabulary", category: .language)

let cards = [
    Flashcard(subjectID: subject.id, front: "Hola", back: "Hello"),
    Flashcard(subjectID: subject.id, front: "Gracias", back: "Thank you"),
    Flashcard(subjectID: subject.id, front: "Por favor", back: "Please"),
]
```

### 2. Study with Spaced Repetition

```swift
let engine = EducationAI()

// Get today's study queue
let queue = engine.spacedRepetition.studyQueue(
    from: cards,
    maxNew: 20,
    maxReview: 100
)

// After the user answers, record the result
let result = engine.recordStudy(
    card: queue[0],
    rating: .good,
    responseTime: 4.2
)

// The updated card has the new review schedule
let updatedCard = result.updatedCard
print("Review again:", updatedCard.nextReviewDate.relativeDescription)
```

### 3. Generate Quizzes

```swift
// Multiple choice quiz from your flashcards
let quiz = engine.quizEngine.generate(
    from: cards,
    count: 10,
    types: [.multipleChoice, .trueFalse],
    difficulty: .medium
)

// Score the answers
let quizResult = engine.quizEngine.score(
    quiz: quiz,
    answers: userAnswers,   // [questionID: selectedAnswer]
    timeTaken: 120.0
)

print("Score: \(Int(quizResult.score * 100))%")
print("Passed: \(quizResult.passed)")
```

### 4. Check Progress

```swift
let progress = engine.progressTracker.progress

print("Total reviews:", progress.totalReviews)
print("Overall accuracy:", progress.overallAccuracy)
print("Global mastery:", progress.globalMastery)

if let spanish = progress.subjects[subject.id] {
    print("Spanish accuracy:", spanish.accuracy)
    print("Spanish mastery:", spanish.masteryScore)
}
```

### 5. Get Recommendations

```swift
let recommendations = engine.recommendationEngine.recommend(
    cards: allCards,
    progress: progress,
    limit: 5
)

for rec in recommendations {
    print("[\(rec.priority)] \(rec.title)")
    print("  \(rec.description)")
    print("  ~\(rec.estimatedMinutes) min")
}
// [critical] Review overdue cards
//   12 card(s) need review to maintain retention.
//   ~6 min
```

### 6. Gamification

```swift
print("Level:", engine.gamification.currentLevel)
print("Total XP:", engine.gamification.totalXP)
print("Streak:", engine.gamification.currentStreak, "days")
print("Progress to next level:", engine.gamification.levelProgress)

for badge in engine.gamification.earnedBadges {
    print("🏅 \(badge.title) (\(badge.tier.displayName))")
}
```

## Architecture

```
EducationAI/
├── EducationAI.swift              # Main entry point & recordStudy()
├── Core/
│   ├── Entities/
│   │   ├── Flashcard.swift        # Card with SM-2 metadata
│   │   ├── Quiz.swift             # Quiz, Question, QuizResult
│   │   ├── Subject.swift          # Subject & category
│   │   ├── LearningProgress.swift # Progress snapshots
│   │   ├── Achievement.swift      # Badges, XP events, streaks
│   │   └── Enums.swift            # DifficultyLevel, RecallRating
│   └── Protocols/
├── SpacedRepetition/
│   ├── SpacedRepetitionScheduler.swift  # SM-2 implementation
│   └── SM2Parameters.swift              # Tunable parameters
├── Quiz/
│   └── QuizEngine.swift           # Quiz generation & scoring
├── Adaptive/
│   └── AdaptiveDifficultyEngine.swift   # Real-time difficulty adjustment
├── Progress/
│   └── ProgressTracker.swift      # Progress recording & queries
├── Recommendation/
│   └── RecommendationEngine.swift # Study recommendations
├── Gamification/
│   └── GamificationEngine.swift   # XP, levels, badges, streaks
├── Storage/
│   └── LocalStorage.swift         # On-device persistence
└── Extensions/
    └── Date+Extensions.swift      # Date helpers
```

### Design Principles

- **Value types by default** — All entities are `struct` + `Codable` + `Sendable`
- **Protocol-oriented** — Engines are swappable via protocols
- **Thread-safe** — Concurrent access handled via `NSLock`
- **Zero dependencies** — Pure Swift, no third-party libraries
- **Testable** — 113 unit tests with comprehensive coverage

## Spaced Repetition Algorithm

EducationAI uses a refined SM-2 (SuperMemo 2) algorithm:

```
┌─────────────────────────────────────────────┐
│              SM-2 Flow                       │
│                                              │
│  New Card ──► 1 day ──► 6 days ──► EF × I   │
│       ▲                                │     │
│       │         Lapse (forgot)         │     │
│       └────────────────────────────────┘     │
│                                              │
│  Easiness Factor adjusts after each review   │
│  EF = EF + (0.1 - (5-q) × (0.08 + 0.02×q))│
│  (clamped to minimum 1.3)                   │
└─────────────────────────────────────────────┘
```

Parameters are fully configurable:

```swift
let params = SM2Parameters(
    initialInterval: 1.0,      // First correct → 1 day
    secondInterval: 6.0,       // Second correct → 6 days
    minimumEasinessFactor: 1.3,
    defaultEasinessFactor: 2.5,
    lapseMultiplier: 0.5,
    maximumInterval: 365.0,
    easyBonus: 1.3
)

let ai = EducationAI(configuration: .init(sm2Parameters: params))
```

## Adaptive Difficulty

The engine maintains a sliding window of recent study events per subject:

```swift
let snapshot = engine.adaptiveEngine.performanceMetrics(for: subject.id)
print("Accuracy:", snapshot.accuracy)
print("Trend:", snapshot.trend)              // .improving / .stable / .declining
print("Recommended:", snapshot.difficulty)    // .easy / .medium / .hard / .expert
```

Target accuracy zone is 70–85%. The engine steps difficulty up or down to keep the learner in a flow state.

## Badge System

14 built-in badges across 5 tiers (bronze → diamond):

| Badge | Requirement | Tier |
|-------|------------|------|
| Getting Started | 3-day streak | 🥉 Bronze |
| Week Warrior | 7-day streak | 🥈 Silver |
| Monthly Master | 30-day streak | 🥇 Gold |
| Century Scholar | 100-day streak | 💎 Diamond |
| First Century | 100 reviews | 🥉 Bronze |
| Dedicated Learner | 1,000 reviews | 🥈 Silver |
| Knowledge Seeker | 10,000 reviews | 🥇 Gold |
| Sharp Mind | 90% accuracy | 🥈 Silver |
| Precision Expert | 95% accuracy | 🥇 Gold |
| Rising Star | 1,000 XP | 🥉 Bronze |
| Powerhouse | 10,000 XP | 🥈 Silver |
| Legendary | 100,000 XP | 🏅 Platinum |
| First Mastery | Master a subject | 🥈 Silver |
| Renaissance Learner | Master 3 subjects | 🥇 Gold |

## Configuration

```swift
let config = EducationAIConfiguration(
    storageSuite: "com.myapp.learning",  // UserDefaults suite
    sm2Parameters: .default,              // SM-2 tuning
    adaptiveSensitivity: 0.5,            // 0 = sluggish, 1 = aggressive
    maxNewCardsPerDay: 20,               // New card limit
    maxReviewsPerDay: 100                // Review limit
)

let engine = EducationAI(configuration: config)
```

## Examples

See the [Examples](Examples/) folder for complete sample projects.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License — see [LICENSE](LICENSE) for details.

---

<p align="center">
  <sub>Built for learners who care about privacy ❤️</sub>
</p>

## 📈 Star History

<a href="https://star-history.com/#muhittincamdali/educationai&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/educationai&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/educationai&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=muhittincamdali/educationai&type=Date" />
 </picture>
</a>
