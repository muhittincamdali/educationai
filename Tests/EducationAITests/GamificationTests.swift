import XCTest
@testable import EducationAI

final class GamificationTests: XCTestCase {

    var gamification: GamificationEngine!
    var storage: LocalStorage!
    var progressTracker: ProgressTracker!
    let subjectID = UUID()
    let cardID = UUID()

    override func setUp() {
        super.setUp()
        storage = LocalStorage(suiteName: "com.educationai.test.gamification")
        storage.removeAll()
        gamification = GamificationEngine(storage: storage)
        progressTracker = ProgressTracker(storage: storage)
    }

    override func tearDown() {
        storage.removeAll()
        super.tearDown()
    }

    // MARK: - XP System

    func testXPAwardedForCorrectAnswer() {
        let event = StudyEvent(cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 5.0)
        let xp = gamification.awardXP(for: event)
        XCTAssertGreaterThan(xp, 0)
        XCTAssertEqual(gamification.totalXP, xp)
    }

    func testXPVariesByRating() {
        let againXP = gamification.awardXP(for: makeEvent(.again))
        gamification.reset()
        let hardXP = gamification.awardXP(for: makeEvent(.hard))
        gamification.reset()
        let goodXP = gamification.awardXP(for: makeEvent(.good))
        gamification.reset()
        let easyXP = gamification.awardXP(for: makeEvent(.easy))

        XCTAssertLessThan(againXP, hardXP)
        XCTAssertLessThan(hardXP, goodXP)
        XCTAssertLessThan(goodXP, easyXP)
    }

    func testXPAccumulatesAcrossEvents() {
        let xp1 = gamification.awardXP(for: makeEvent(.good))
        let xp2 = gamification.awardXP(for: makeEvent(.easy))
        XCTAssertEqual(gamification.totalXP, xp1 + xp2)
    }

    func testSpeedBonus() {
        let fastEvent = StudyEvent(cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 2.0)
        let slowEvent = StudyEvent(cardID: cardID, subjectID: subjectID, rating: .good, responseTime: 10.0)

        let fastXP = gamification.awardXP(for: fastEvent)
        gamification.reset()
        let slowXP = gamification.awardXP(for: slowEvent)

        XCTAssertGreaterThan(fastXP, slowXP)
    }

    // MARK: - Level System

    func testInitialLevelIsOne() {
        XCTAssertEqual(gamification.currentLevel, 1)
    }

    func testLevelIncreasesWithXP() {
        // Award enough XP to level up
        for _ in 0..<50 {
            gamification.awardXP(for: makeEvent(.easy))
        }
        XCTAssertGreaterThan(gamification.currentLevel, 1)
    }

    func testLevelProgressBetweenZeroAndOne() {
        gamification.awardXP(for: makeEvent(.good))
        XCTAssertGreaterThanOrEqual(gamification.levelProgress, 0)
        XCTAssertLessThanOrEqual(gamification.levelProgress, 1.0)
    }

    func testXPToNextLevel() {
        let toNext = gamification.xpToNextLevel
        XCTAssertGreaterThan(toNext, 0)
    }

    // MARK: - Streak System

    func testInitialStreakIsZero() {
        XCTAssertEqual(gamification.currentStreak, 0)
    }

    func testFirstStudyDaySetsStreak() {
        gamification.awardXP(for: makeEvent(.good))
        XCTAssertEqual(gamification.currentStreak, 1)
    }

    func testStreakInfo() {
        gamification.awardXP(for: makeEvent(.good))
        XCTAssertEqual(gamification.streak.current, 1)
        XCTAssertEqual(gamification.streak.longest, 1)
        XCTAssertNotNil(gamification.streak.lastStudyDate)
    }

    // MARK: - Badge System

    func testNoBadgesInitially() {
        XCTAssertTrue(gamification.earnedBadges.isEmpty)
    }

    func testBadgeDefinitionsExist() {
        XCTAssertGreaterThan(BadgeDefinitions.all.count, 0)
    }

    func testReviewCountBadge() {
        // Simulate 100+ reviews to earn "First Century" badge
        for _ in 0..<110 {
            let event = makeEvent(.good)
            progressTracker.record(event: event)
            gamification.awardXP(for: event)
        }
        let newBadges = gamification.checkBadges(for: progressTracker)
        let hasCentury = newBadges.contains { $0.key == "reviews_100" }
            || gamification.earnedBadges.contains { $0.key == "reviews_100" }
        XCTAssertTrue(hasCentury)
    }

    func testBadgeNotAwardedTwice() {
        // Earn a badge
        for _ in 0..<110 {
            progressTracker.record(event: makeEvent(.good))
            gamification.awardXP(for: makeEvent(.good))
        }
        let first = gamification.checkBadges(for: progressTracker)
        let second = gamification.checkBadges(for: progressTracker)

        // Second call should return no new badges
        let firstKeys = Set(first.map(\.key))
        let secondKeys = Set(second.map(\.key))
        XCTAssertTrue(secondKeys.isDisjoint(with: firstKeys))
    }

    func testBadgeHasEarnedDate() {
        for _ in 0..<110 {
            progressTracker.record(event: makeEvent(.good))
            gamification.awardXP(for: makeEvent(.good))
        }
        _ = gamification.checkBadges(for: progressTracker)
        for badge in gamification.earnedBadges {
            XCTAssertTrue(badge.isEarned)
            XCTAssertNotNil(badge.earnedAt)
        }
    }

    // MARK: - Reset

    func testResetClearsAllState() {
        gamification.awardXP(for: makeEvent(.good))
        gamification.reset()
        XCTAssertEqual(gamification.totalXP, 0)
        XCTAssertEqual(gamification.currentLevel, 1)
        XCTAssertEqual(gamification.currentStreak, 0)
        XCTAssertTrue(gamification.earnedBadges.isEmpty)
        XCTAssertTrue(gamification.xpHistory.isEmpty)
    }

    // MARK: - Persistence

    func testXPPersistsAcrossInstances() {
        gamification.awardXP(for: makeEvent(.easy))
        let savedXP = gamification.totalXP

        let newEngine = GamificationEngine(storage: storage)
        XCTAssertEqual(newEngine.totalXP, savedXP)
    }

    // MARK: - Helpers

    private func makeEvent(_ rating: RecallRating) -> StudyEvent {
        StudyEvent(cardID: cardID, subjectID: subjectID, rating: rating, responseTime: 5.0)
    }
}
