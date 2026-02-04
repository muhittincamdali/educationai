<p align="center">
  <img src="Assets/logo.png" alt="EducationAI" width="200"/>
</p>

<h1 align="center">EducationAI</h1>

<p align="center">
  <strong>📚 AI-powered education platform for personalized learning experiences</strong>
</p>

<p align="center">
  <a href="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml">
    <img src="https://github.com/muhittincamdali/educationai/actions/workflows/ci.yml/badge.svg" alt="CI Status"/>
  </a>
  <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift 6.0"/>
  <img src="https://img.shields.io/badge/iOS-17.0+-blue.svg" alt="iOS 17.0+"/>
  <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License"/>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#ai-features">AI Features</a> •
  <a href="#documentation">Documentation</a>
</p>

---

## Why EducationAI?

Traditional learning apps treat every student the same. **EducationAI** uses on-device machine learning to understand each learner's strengths, weaknesses, and learning style—then adapts content in real-time.

```swift
// Create personalized learning experience
let learner = Learner(profile: userProfile)
let course = Course.mathematics

let personalizedPath = await EducationAI.generatePath(
    for: learner,
    course: course,
    goal: .masterAlgebra
)
// AI creates optimal sequence based on learner's style
```

## Features

| Feature | Description |
|---------|-------------|
| 🧠 **Adaptive Learning** | AI adjusts difficulty in real-time |
| 📊 **Learning Analytics** | Track progress and identify gaps |
| 🎯 **Personalized Paths** | Custom curriculum for each student |
| 💬 **AI Tutor** | Natural language Q&A assistance |
| 📝 **Smart Quizzes** | Auto-generated assessments |
| 🔊 **Text-to-Speech** | Accessible audio content |
| 🌐 **Multi-Language** | Content in 20+ languages |
| 📱 **Offline Mode** | Learn without internet |

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/educationai.git", from: "1.0.0")
]
```

## Quick Start

### 1. Initialize the SDK

```swift
import EducationAI

@main
struct MyApp: App {
    init() {
        EducationAI.configure(apiKey: "your-api-key")
    }
}
```

### 2. Create a Learner Profile

```swift
let profile = LearnerProfile(
    age: 14,
    gradeLevel: .grade8,
    learningStyle: .visual,
    preferredPace: .moderate
)

let learner = try await Learner.create(profile: profile)
```

### 3. Start a Learning Session

```swift
struct LearningView: View {
    @StateObject var session = LearningSession()
    
    var body: some View {
        AdaptiveLessonView(session: session)
            .onAppear {
                session.start(course: .algebra)
            }
    }
}
```

## AI Features

### Adaptive Difficulty

The AI continuously adjusts content difficulty based on performance:

```swift
// AI monitors these signals
session.onPerformanceUpdate { metrics in
    // Response time
    // Accuracy rate
    // Frustration indicators
    // Engagement level
}

// And automatically adjusts
// - Question difficulty
// - Hint frequency
// - Content complexity
// - Pacing
```

### AI Tutor

Natural language tutoring powered by on-device LLM:

```swift
let tutor = AITutor(subject: .mathematics)

// Student asks question
let response = await tutor.ask("How do I solve quadratic equations?")

// Tutor provides personalized explanation
// with examples at the student's level
```

### Smart Content Generation

```swift
// Generate practice problems
let problems = await ContentGenerator.generate(
    topic: .fractions,
    difficulty: .intermediate,
    count: 10,
    style: .wordProblems
)

// Generate quizzes
let quiz = await QuizGenerator.generate(
    covering: lesson.topics,
    duration: .minutes(15)
)
```

### Learning Gap Detection

```swift
let analysis = await LearningAnalyzer.analyze(learner: learner)

for gap in analysis.knowledgeGaps {
    print("Gap in: \(gap.topic)")
    print("Recommended: \(gap.remediation)")
}
```

## Components

### AdaptiveLessonView

```swift
AdaptiveLessonView(
    lesson: algebraLesson,
    learner: currentLearner
)
.adaptationSpeed(.gradual)
.hintsEnabled(true)
.celebrateProgress(true)
```

### InteractiveQuiz

```swift
InteractiveQuiz(quiz: generatedQuiz)
    .shuffleQuestions(true)
    .showExplanations(true)
    .onComplete { results in
        // Handle quiz results
    }
```

### ProgressDashboard

```swift
ProgressDashboard(learner: learner)
    .timeRange(.lastMonth)
    .showMilestones(true)
    .compareWithPeers(false) // Privacy-first
```

### FlashcardDeck

```swift
FlashcardDeck(cards: vocabularyCards)
    .algorithm(.spacedRepetition)
    .audioEnabled(true)
```

## Analytics

### Learning Metrics

```swift
let metrics = await Analytics.getMetrics(for: learner)

print("Time spent: \(metrics.totalTime)")
print("Lessons completed: \(metrics.lessonsCompleted)")
print("Mastery level: \(metrics.masteryPercentage)%")
print("Streak: \(metrics.currentStreak) days")
```

### Progress Reports

```swift
let report = await ReportGenerator.generate(
    learner: learner,
    period: .lastMonth,
    format: .pdf
)
// Share with parents/teachers
```

## Content Management

### Course Structure

```swift
let course = Course(
    title: "Algebra Fundamentals",
    modules: [
        Module(title: "Variables") {
            Lesson("What is a Variable?")
            Lesson("Using Variables")
            Practice(problems: 10)
            Quiz()
        },
        Module(title: "Equations") {
            // ...
        }
    ]
)
```

### Import Content

```swift
// From various formats
let content = try await ContentImporter.import(
    from: scormPackage,
    format: .scorm
)

// Supported: SCORM, xAPI, QTI, custom JSON
```

## Accessibility

```swift
EducationAI.accessibility {
    $0.voiceOver = true
    $0.dynamicType = true
    $0.reduceMotion = true
    $0.colorBlindMode = .deuteranopia
    $0.readingSpeed = .slow
}
```

## Privacy & Security

- All ML processing on-device
- No student data shared
- COPPA & FERPA compliant
- GDPR compliant
- Data encryption at rest

## Best Practices

### Lesson Design

```swift
// ✅ Good: Chunked content
Lesson {
    Concept("Introduction", duration: .minutes(3))
    Practice(questions: 3)
    Concept("Deep Dive", duration: .minutes(5))
    Practice(questions: 5)
    Summary()
}

// ❌ Avoid: Long uninterrupted content
```

### Engagement

```swift
// Enable gamification
session.enableGamification {
    $0.points = true
    $0.badges = true
    $0.leaderboards = false // Privacy
    $0.celebrations = true
}
```

## Examples

See the [Examples](Examples/) folder:

- **BasicApp** - Simple learning app
- **MathTutor** - Mathematics tutoring
- **LanguageLearning** - Vocabulary & grammar
- **ScienceLab** - Interactive experiments

## Requirements

| Platform | Version |
|----------|---------|
| iOS | 17.0+ |
| iPadOS | 17.0+ |
| macOS | 14.0+ |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT License - see [LICENSE](LICENSE).

---

<p align="center">
  <sub>Empowering learners through AI ❤️</sub>
</p>

---

## 📈 Star History

<a href="https://star-history.com/#muhittincamdali/educationai&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/educationai&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/educationai&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=muhittincamdali/educationai&type=Date" />
 </picture>
</a>
