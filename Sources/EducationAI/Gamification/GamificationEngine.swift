import Foundation

/// Gamification engine providing XP, badges, streaks and levels.
///
/// All state is persisted via ``LocalStorage`` and processed on-device.
///
/// ```swift
/// let engine = GamificationEngine(storage: storage)
/// let xp = engine.awardXP(for: studyEvent)
/// let badges = engine.checkBadges(for: progressTracker)
/// print("Level:", engine.currentLevel)
/// print("Streak:", engine.currentStreak)
/// ```
public final class GamificationEngine: @unchecked Sendable {

    // MARK: - State

    private let storage: LocalStorage
    private let lock = NSLock()

    /// Total XP earned.
    public private(set) var totalXP: Int {
        didSet { persist() }
    }

    /// XP event history.
    public private(set) var xpHistory: [XPEvent]

    /// Earned badges.
    public private(set) var earnedBadges: [Badge]

    /// Streak information.
    public private(set) var streak: StreakInfo

    // MARK: - Keys

    private enum Keys {
        static let totalXP = "educationai.gamification.totalXP"
        static let xpHistory = "educationai.gamification.xpHistory"
        static let badges = "educationai.gamification.badges"
        static let streak = "educationai.gamification.streak"
    }

    // MARK: - Initialization

    public init(storage: LocalStorage) {
        self.storage = storage
        self.totalXP = storage.load(forKey: Keys.totalXP) ?? 0
        self.xpHistory = storage.load(forKey: Keys.xpHistory) ?? []
        self.earnedBadges = storage.load(forKey: Keys.badges) ?? []
        self.streak = storage.load(forKey: Keys.streak) ?? StreakInfo()
    }

    // MARK: - XP System

    /// Award XP based on a study event and return the amount earned.
    @discardableResult
    public func awardXP(for event: StudyEvent) -> Int {
        lock.lock()
        defer { lock.unlock() }

        var xp = baseXP(for: event.rating)

        // Speed bonus: under 5 seconds and correct
        if event.rating.isCorrect && event.responseTime < 5.0 {
            xp += 2
        }

        // Streak bonus: +1 XP per streak day (capped at 10)
        xp += min(streak.current, 10)

        let xpEvent = XPEvent(amount: xp, reason: event.rating.displayName)
        xpHistory.append(xpEvent)
        if xpHistory.count > 1000 {
            xpHistory = Array(xpHistory.suffix(1000))
        }
        totalXP += xp

        // Update streak
        updateStreak(for: event.timestamp)

        persist()
        return xp
    }

    /// XP needed to reach the next level.
    public var xpToNextLevel: Int {
        let nextLevel = currentLevel + 1
        return xpRequired(for: nextLevel) - totalXP
    }

    /// Current level based on total XP.
    public var currentLevel: Int {
        level(for: totalXP)
    }

    /// Current daily streak.
    public var currentStreak: Int {
        lock.lock()
        defer { lock.unlock() }
        return streak.current
    }

    /// Progress toward next level as a value between 0 and 1.
    public var levelProgress: Double {
        let currentLevelXP = xpRequired(for: currentLevel)
        let nextLevelXP = xpRequired(for: currentLevel + 1)
        let range = nextLevelXP - currentLevelXP
        guard range > 0 else { return 1.0 }
        return Double(totalXP - currentLevelXP) / Double(range)
    }

    // MARK: - Badge System

    /// Check and award any newly earned badges based on current progress.
    ///
    /// Returns only the *newly* earned badges (not previously awarded).
    @discardableResult
    public func checkBadges(for tracker: ProgressTracker) -> [Badge] {
        lock.lock()
        defer { lock.unlock() }

        let progress = tracker.progress
        var newBadges: [Badge] = []

        for definition in BadgeDefinitions.all {
            // Skip already earned
            if earnedBadges.contains(where: { $0.key == definition.key }) { continue }

            if definition.condition(progress, streak, totalXP) {
                var badge = definition.badge
                badge.earnedAt = Date()
                earnedBadges.append(badge)
                newBadges.append(badge)
            }
        }

        if !newBadges.isEmpty { persist() }
        return newBadges
    }

    /// Reset all gamification state.
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        totalXP = 0
        xpHistory = []
        earnedBadges = []
        streak = StreakInfo()
        persist()
    }

    // MARK: - Private

    private func baseXP(for rating: RecallRating) -> Int {
        switch rating {
        case .again: return 1
        case .hard:  return 3
        case .good:  return 5
        case .easy:  return 8
        }
    }

    private func updateStreak(for date: Date) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: date)

        if let lastDate = streak.lastStudyDate {
            let lastDay = calendar.startOfDay(for: lastDate)
            let daysDiff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0

            if daysDiff == 0 {
                // Same day, streak unchanged
            } else if daysDiff == 1 {
                // Consecutive day
                streak.current += 1
                streak.longest = max(streak.longest, streak.current)
            } else {
                // Streak broken
                streak.current = 1
            }
        } else {
            // First ever study day
            streak.current = 1
            streak.longest = 1
        }

        streak.lastStudyDate = today
    }

    private func level(for xp: Int) -> Int {
        // Each level requires progressively more XP
        // Level N requires N * 100 XP total
        // Level 1: 0, Level 2: 100, Level 3: 300, Level 4: 600...
        var total = 0
        var lvl = 1
        while total + lvl * 100 <= xp {
            total += lvl * 100
            lvl += 1
        }
        return lvl
    }

    private func xpRequired(for level: Int) -> Int {
        var total = 0
        for lvl in 1..<level {
            total += lvl * 100
        }
        return total
    }

    private func persist() {
        storage.save(totalXP, forKey: Keys.totalXP)
        storage.save(xpHistory, forKey: Keys.xpHistory)
        storage.save(earnedBadges, forKey: Keys.badges)
        storage.save(streak, forKey: Keys.streak)
    }
}

// MARK: - Badge Definitions

/// Defines all available badges and their unlock conditions.
public enum BadgeDefinitions {

    /// A badge definition with its unlock condition.
    public struct Definition {
        public let badge: Badge
        public let condition: (LearningProgress, StreakInfo, Int) -> Bool

        public var key: String { badge.key }
    }

    /// All available badge definitions.
    public static let all: [Definition] = [
        // Streak badges
        Definition(
            badge: Badge(key: "streak_3", title: "Getting Started", description: "Study 3 days in a row", iconName: "flame", tier: .bronze),
            condition: { _, streak, _ in streak.current >= 3 }
        ),
        Definition(
            badge: Badge(key: "streak_7", title: "Week Warrior", description: "Study 7 days in a row", iconName: "flame.fill", tier: .silver),
            condition: { _, streak, _ in streak.current >= 7 }
        ),
        Definition(
            badge: Badge(key: "streak_30", title: "Monthly Master", description: "Study 30 days in a row", iconName: "flame.circle.fill", tier: .gold),
            condition: { _, streak, _ in streak.current >= 30 }
        ),
        Definition(
            badge: Badge(key: "streak_100", title: "Century Scholar", description: "Study 100 days in a row", iconName: "flame.circle", tier: .diamond),
            condition: { _, streak, _ in streak.current >= 100 }
        ),

        // Review count badges
        Definition(
            badge: Badge(key: "reviews_100", title: "First Century", description: "Complete 100 reviews", iconName: "checkmark.circle", tier: .bronze),
            condition: { progress, _, _ in progress.totalReviews >= 100 }
        ),
        Definition(
            badge: Badge(key: "reviews_1000", title: "Dedicated Learner", description: "Complete 1,000 reviews", iconName: "checkmark.circle.fill", tier: .silver),
            condition: { progress, _, _ in progress.totalReviews >= 1000 }
        ),
        Definition(
            badge: Badge(key: "reviews_10000", title: "Knowledge Seeker", description: "Complete 10,000 reviews", iconName: "brain", tier: .gold),
            condition: { progress, _, _ in progress.totalReviews >= 10_000 }
        ),

        // Accuracy badges
        Definition(
            badge: Badge(key: "accuracy_90", title: "Sharp Mind", description: "Achieve 90% overall accuracy", iconName: "target", tier: .silver),
            condition: { progress, _, _ in progress.overallAccuracy >= 0.9 && progress.totalReviews >= 50 }
        ),
        Definition(
            badge: Badge(key: "accuracy_95", title: "Precision Expert", description: "Achieve 95% overall accuracy", iconName: "scope", tier: .gold),
            condition: { progress, _, _ in progress.overallAccuracy >= 0.95 && progress.totalReviews >= 100 }
        ),

        // XP badges
        Definition(
            badge: Badge(key: "xp_1000", title: "Rising Star", description: "Earn 1,000 XP", iconName: "star", tier: .bronze),
            condition: { _, _, xp in xp >= 1000 }
        ),
        Definition(
            badge: Badge(key: "xp_10000", title: "Powerhouse", description: "Earn 10,000 XP", iconName: "star.fill", tier: .silver),
            condition: { _, _, xp in xp >= 10_000 }
        ),
        Definition(
            badge: Badge(key: "xp_100000", title: "Legendary", description: "Earn 100,000 XP", iconName: "star.circle.fill", tier: .platinum),
            condition: { _, _, xp in xp >= 100_000 }
        ),

        // Mastery badges
        Definition(
            badge: Badge(key: "mastery_first", title: "First Mastery", description: "Master your first subject", iconName: "graduationcap", tier: .silver),
            condition: { progress, _, _ in progress.subjects.values.contains { $0.masteryScore >= 0.8 } }
        ),
        Definition(
            badge: Badge(key: "mastery_multi", title: "Renaissance Learner", description: "Master 3 subjects", iconName: "graduationcap.fill", tier: .gold),
            condition: { progress, _, _ in progress.subjects.values.filter { $0.masteryScore >= 0.8 }.count >= 3 }
        ),
    ]
}
