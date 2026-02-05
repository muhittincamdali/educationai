# Changelog

All notable changes to EducationAI will be documented in this file.

## [1.0.0] - 2025-02-05

### Added
- **Spaced Repetition** — SM-2 algorithm with configurable parameters
  - Automatic interval scheduling based on recall quality
  - Study queue builder combining due reviews and new cards
  - Preview intervals for each rating option
- **Quiz Generation** — Auto-generate quizzes from flashcard decks
  - Multiple choice, true/false, short answer, fill-in-the-blank
  - Difficulty filtering and shuffling
  - Built-in scoring engine with per-question results
- **Adaptive Difficulty** — Real-time difficulty adjustment
  - Sliding window performance analysis
  - Configurable target accuracy zone (70-85%)
  - Per-subject trend detection (improving/stable/declining)
- **Progress Tracking** — Comprehensive learning analytics
  - Per-subject mastery, accuracy, study time tracking
  - Event history with date range queries
  - Global mastery score across all subjects
- **Content Recommendation** — Smart study suggestions
  - Overdue review detection (critical priority)
  - Weak area identification and targeted practice
  - New content and lapsed card recommendations
  - Priority-sorted with time estimates
- **Gamification** — XP, levels, streaks, and badges
  - XP system with speed bonuses and streak multipliers
  - Progressive leveling system
  - 14 built-in badge definitions across 5 tiers
  - Daily streak tracking with longest streak record
- **On-Device Storage** — Privacy-first persistence
  - UserDefaults-backed JSON storage
  - Thread-safe read/write operations
  - No network calls, no analytics SDKs
- **113 unit tests** with comprehensive coverage
- Multi-platform support: iOS 15+, macOS 12+, watchOS 8+, tvOS 15+
- Zero third-party dependencies

### Architecture
- Clean modular architecture with separate engines
- All entities are `Codable`, `Sendable`, and value types
- Thread-safe engine implementations using `NSLock`
- Protocol-oriented design for testability
