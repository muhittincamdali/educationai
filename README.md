# 🎓 EducationAI

<div align="center">

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-FA7343?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org)
[![iOS 15.0+](https://img.shields.io/badge/iOS-15.0+-000000?style=for-the-badge&logo=ios&logoColor=white)](https://developer.apple.com/ios/)
[![macOS 10.15+](https://img.shields.io/badge/macOS-10.15+-007AFF?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/macos/)
[![SPM Compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org/package-manager/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](LICENSE)

**AI-Powered Personalized Learning Platform for iOS**

Adaptive learning paths, intelligent recommendations, skill assessments, and optimized study schedules powered by machine learning.

[Features](#-features) • [Installation](#-installation) • [Quick Start](#-quick-start) • [AI Services](#-ai-services) • [Examples](#-examples)

</div>

---

## ✨ Features

- **🧠 Personalized Recommendations** — AI-driven course suggestions based on learning history
- **📊 Adaptive Learning Paths** — Dynamic paths that adjust to user progress
- **🎯 Skill Assessment** — Intelligent evaluation of current knowledge levels
- **📅 Study Schedule Optimization** — Optimal learning schedules based on patterns
- **📝 Content Generation** — AI-generated lessons, quizzes, and exercises
- **📈 Learning Analytics** — Deep insights into learning progress and patterns
- **🏆 Achievement System** — Gamification with milestones and rewards
- **⚡ Async/Await** — Modern Swift concurrency throughout

---

## 📦 Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/educationai.git", from: "1.0.0")
]
```

Add to your target:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "EducationAI", package: "educationai")
    ]
)
```

### Xcode

1. Go to **File → Add Package Dependencies**
2. Enter: `https://github.com/muhittincamdali/educationai.git`
3. Select version and add to your project

---

## 🚀 Quick Start

### Initialize the AI Service

```swift
import EducationAI

// Create the AI service
let aiService = AIService()

// Or with custom components
let aiService = AIService(
    modelManager: CustomModelManager(),
    learningAnalyzer: CustomAnalyzer(),
    recommendationEngine: CustomEngine(),
    contentGenerator: CustomGenerator()
)
```

### Get Personalized Recommendations

```swift
// Fetch AI-powered course recommendations
let recommendations = try await aiService.getPersonalizedRecommendations(
    for: userId,
    limit: 10
)

for recommendation in recommendations {
    print("📚 Course: \(recommendation.courseId)")
    print("   Confidence: \(recommendation.confidence * 100)%")
    print("   Reason: \(recommendation.reason)")
    print("   Est. Time: \(recommendation.estimatedCompletionTime / 3600)h")
}
```

### Generate Adaptive Learning Path

```swift
// Create personalized learning path
let learningPath = try await aiService.generateAdaptiveLearningPath(
    for: userId,
    subject: .programming,
    targetSkillLevel: .advanced
)

print("🛤️ Learning Path: \(learningPath.id)")
print("📦 Modules: \(learningPath.modules.count)")
print("⏱️ Duration: \(learningPath.estimatedDuration / 3600) hours")

for milestone in learningPath.milestones {
    print("🎯 \(milestone.title): \(milestone.description)")
}
```

### Analyze Learning Progress

```swift
// Get detailed progress analysis
let analysis = try await aiService.analyzeLearningProgress(
    for: userId,
    timeRange: .lastMonth
)

print("📈 Overall Progress: \(analysis.overallProgress * 100)%")
print("⚡ Learning Velocity: \(analysis.learningVelocity)")
print("🎯 Consistency Score: \(analysis.consistencyScore * 100)%")
print("💪 Strengths: \(analysis.strengths)")
print("📚 Areas to Improve: \(analysis.areasForImprovement)")
```

---

## 🤖 AI Services

### AIService

The main entry point for all AI-powered educational features.

```swift
public class AIService: ObservableObject {
    // Get personalized course recommendations
    func getPersonalizedRecommendations(for userId: UUID, limit: Int) async throws -> [CourseRecommendation]
    
    // Generate adaptive learning path
    func generateAdaptiveLearningPath(for userId: UUID, subject: Subject, targetSkillLevel: SkillLevel) async throws -> AdaptiveLearningPath
    
    // Analyze learning progress
    func analyzeLearningProgress(for userId: UUID, timeRange: TimeRange) async throws -> LearningProgressAnalysis
    
    // Generate personalized content
    func generatePersonalizedContent(for userId: UUID, contentType: ContentType, subject: Subject) async throws -> GeneratedContent
    
    // Assess current skills
    func assessCurrentSkills(_ userId: UUID, in subject: Subject) async throws -> SkillAssessment
    
    // Optimize study schedule
    func optimizeStudySchedule(for userId: UUID, availableTime: TimeInterval, goals: [LearningGoal]) async throws -> OptimizedStudySchedule
}
```

### Subjects

```swift
public enum Subject: String, Codable, CaseIterable {
    case mathematics
    case programming
    case science
    case language
    case history
    case arts
    case business
    case engineering
}
```

### Skill Levels

```swift
public enum SkillLevel: String, Codable, CaseIterable {
    case beginner
    case intermediate
    case advanced
    case expert
}
```

### Content Types

```swift
public enum ContentType: String, Codable {
    case lesson     // Educational lesson content
    case quiz       // Assessment quiz
    case exercise   // Practice exercise
    case summary    // Topic summary
    case practice   // Hands-on practice
}
```

---

## 💡 Examples

### Building a Learning App

```swift
import SwiftUI
import EducationAI

struct LearningDashboardView: View {
    @StateObject private var aiService = AIService()
    @State private var recommendations: [CourseRecommendation] = []
    @State private var learningPath: AdaptiveLearningPath?
    @State private var isLoading = false
    
    let userId: UUID
    
    var body: some View {
        NavigationStack {
            List {
                // Recommendations Section
                Section("Recommended for You") {
                    ForEach(recommendations) { rec in
                        RecommendationCard(recommendation: rec)
                    }
                }
                
                // Learning Path Section
                if let path = learningPath {
                    Section("Your Learning Path") {
                        ForEach(path.modules) { module in
                            ModuleCard(module: module)
                        }
                    }
                }
            }
            .navigationTitle("Learn")
            .task {
                await loadData()
            }
            .refreshable {
                await loadData()
            }
        }
    }
    
    private func loadData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            recommendations = try await aiService.getPersonalizedRecommendations(
                for: userId,
                limit: 5
            )
            
            learningPath = try await aiService.generateAdaptiveLearningPath(
                for: userId,
                subject: .programming,
                targetSkillLevel: .advanced
            )
        } catch {
            print("Error loading data: \(error)")
        }
    }
}
```

### Progress Tracking

```swift
import EducationAI

class ProgressTracker: ObservableObject {
    private let aiService = AIService()
    
    @Published var progress: LearningProgressAnalysis?
    @Published var skillAssessment: SkillAssessment?
    
    func trackProgress(userId: UUID) async {
        do {
            progress = try await aiService.analyzeLearningProgress(
                for: userId,
                timeRange: .lastMonth
            )
            
            skillAssessment = try await aiService.assessCurrentSkills(
                userId,
                in: .programming
            )
            
            logInsights()
        } catch {
            print("Tracking error: \(error)")
        }
    }
    
    private func logInsights() {
        guard let progress = progress else { return }
        
        print("📊 Learning Insights:")
        print("   Time Spent: \(Int(progress.timeSpent / 3600)) hours")
        print("   Completed: \(progress.completedItems) items")
        print("   Average Score: \(Int(progress.averageScore * 100))%")
        
        for recommendation in progress.recommendations {
            print("   💡 \(recommendation)")
        }
    }
}
```

### Study Schedule Optimization

```swift
import EducationAI

func optimizeMySchedule() async {
    let aiService = AIService()
    
    let goals: [LearningGoal] = [
        LearningGoal(
            title: "Master Swift",
            description: "Complete Swift programming course",
            targetDate: Date().addingTimeInterval(30 * 24 * 3600), // 30 days
            priority: .high
        ),
        LearningGoal(
            title: "Learn SwiftUI",
            description: "Build first SwiftUI app",
            targetDate: Date().addingTimeInterval(60 * 24 * 3600), // 60 days
            priority: .medium
        )
    ]
    
    do {
        let schedule = try await aiService.optimizeStudySchedule(
            for: userId,
            availableTime: 2 * 3600, // 2 hours per day
            goals: goals
        )
        
        print("📅 Optimized Schedule:")
        for block in schedule.dailySchedule {
            print("   \(block.timeSlot.startTime): \(block.subject) - \(Int(block.duration / 60)) min")
        }
        
        print("🎯 Weekly Goals:")
        for goal in schedule.weeklyGoals {
            print("   Week \(goal.week): \(goal.target)")
        }
        
        print("⏰ Optimal Study Times:")
        for time in schedule.optimalStudyTimes {
            print("   Day \(time.dayOfWeek): \(time.timeRange) (Productivity: \(Int(time.productivityScore * 100))%)")
        }
        
    } catch {
        print("Failed to optimize: \(error)")
    }
}
```

---

## 🏗️ Architecture

```
educationai/
├── Sources/
│   └── Core/
│       ├── Domain/
│       │   └── Protocols/           # Core protocols
│       │       ├── AIEngine.swift
│       │       ├── ContentManager.swift
│       │       ├── LearningEngine.swift
│       │       ├── ProgressTracker.swift
│       │       └── AnalyticsEngine.swift
│       └── Infrastructure/
│           └── AI/
│               └── AIService.swift  # Main AI service
├── Tests/
│   ├── EducationAITests/
│   ├── UnitTests.swift
│   ├── IntegrationTests.swift
│   └── PerformanceTests.swift
└── Examples/
    ├── BasicExample.swift
    └── AdvancedExample.swift
```

---

## 📋 Requirements

| Platform | Minimum Version |
|----------|-----------------|
| iOS      | 15.0+           |
| macOS    | 10.15+          |
| Swift    | 5.9+            |
| Xcode    | 15.0+           |

### Dependencies

- [Alamofire](https://github.com/Alamofire/Alamofire) — Networking
- [RxSwift](https://github.com/ReactiveX/RxSwift) — Reactive programming
- [SnapKit](https://github.com/SnapKit/SnapKit) — Auto Layout DSL
- [SDWebImage](https://github.com/SDWebImage/SDWebImage) — Image loading

---

## 🎯 Use Cases

- **E-Learning Platforms** — Personalized learning experiences
- **Corporate Training** — Adaptive employee development
- **Language Learning Apps** — AI-driven language education
- **Skill Development** — Professional skill building
- **Academic Apps** — Student learning optimization
- **MOOC Platforms** — Massive open online courses

---

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Transforming education with artificial intelligence**

⭐ Star this repository if you find it helpful!

</div>
