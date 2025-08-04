import XCTest
@testable import EducationAI

final class UserTests: XCTestCase {
    
    // MARK: - User Creation Tests
    func testUserCreation() {
        // Given
        let email = "test@example.com"
        let username = "testuser"
        let firstName = "Test"
        let lastName = "User"
        
        // When
        let user = User(
            email: email,
            username: username,
            firstName: firstName,
            lastName: lastName
        )
        
        // Then
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.username, username)
        XCTAssertEqual(user.firstName, firstName)
        XCTAssertEqual(user.lastName, lastName)
        XCTAssertEqual(user.learningLevel, .beginner)
        XCTAssertTrue(user.isActive)
        XCTAssertEqual(user.preferredSubjects.count, 0)
        XCTAssertEqual(user.learningGoals.count, 0)
        XCTAssertEqual(user.achievements.count, 0)
    }
    
    func testUserWithAllProperties() {
        // Given
        let email = "complete@example.com"
        let username = "completeuser"
        let firstName = "Complete"
        let lastName = "User"
        let learningLevel = LearningLevel.advanced
        let preferredSubjects: [Subject] = [.mathematics, .science]
        let learningGoals = [
            LearningGoal(title: "Learn Calculus", description: "Master calculus concepts")
        ]
        let achievements = [
            Achievement(title: "First Lesson", description: "Completed first lesson", icon: "star", points: 10)
        ]
        
        // When
        let user = User(
            email: email,
            username: username,
            firstName: firstName,
            lastName: lastName,
            learningLevel: learningLevel,
            preferredSubjects: preferredSubjects,
            learningGoals: learningGoals,
            achievements: achievements
        )
        
        // Then
        XCTAssertEqual(user.learningLevel, learningLevel)
        XCTAssertEqual(user.preferredSubjects.count, 2)
        XCTAssertEqual(user.learningGoals.count, 1)
        XCTAssertEqual(user.achievements.count, 1)
        XCTAssertEqual(user.achievements.first?.title, "First Lesson")
    }
    
    // MARK: - Learning Level Tests
    func testLearningLevelDisplayNames() {
        XCTAssertEqual(LearningLevel.beginner.displayName, "Başlangıç")
        XCTAssertEqual(LearningLevel.intermediate.displayName, "Orta Seviye")
        XCTAssertEqual(LearningLevel.advanced.displayName, "İleri Seviye")
        XCTAssertEqual(LearningLevel.expert.displayName, "Uzman")
    }
    
    func testLearningLevelDescriptions() {
        XCTAssertEqual(LearningLevel.beginner.description, "Yeni başlayanlar için temel kavramlar")
        XCTAssertEqual(LearningLevel.intermediate.description, "Temel bilgileri pekiştirme")
        XCTAssertEqual(LearningLevel.advanced.description, "Derinlemesine öğrenme")
        XCTAssertEqual(LearningLevel.expert.description, "Uzman seviye bilgi ve beceriler")
    }
    
    // MARK: - Subject Tests
    func testSubjectDisplayNames() {
        XCTAssertEqual(Subject.mathematics.displayName, "Matematik")
        XCTAssertEqual(Subject.science.displayName, "Bilim")
        XCTAssertEqual(Subject.language.displayName, "Dil")
        XCTAssertEqual(Subject.history.displayName, "Tarih")
        XCTAssertEqual(Subject.geography.displayName, "Coğrafya")
        XCTAssertEqual(Subject.literature.displayName, "Edebiyat")
        XCTAssertEqual(Subject.art.displayName, "Sanat")
        XCTAssertEqual(Subject.music.displayName, "Müzik")
        XCTAssertEqual(Subject.technology.displayName, "Teknoloji")
        XCTAssertEqual(Subject.business.displayName, "İş Dünyası")
        XCTAssertEqual(Subject.health.displayName, "Sağlık")
        XCTAssertEqual(Subject.philosophy.displayName, "Felsefe")
    }
    
    func testSubjectIcons() {
        XCTAssertEqual(Subject.mathematics.icon, "function")
        XCTAssertEqual(Subject.science.icon, "atom")
        XCTAssertEqual(Subject.language.icon, "textformat")
        XCTAssertEqual(Subject.history.icon, "clock")
        XCTAssertEqual(Subject.geography.icon, "globe")
        XCTAssertEqual(Subject.literature.icon, "book")
        XCTAssertEqual(Subject.art.icon, "paintbrush")
        XCTAssertEqual(Subject.music.icon, "music.note")
        XCTAssertEqual(Subject.technology.icon, "laptopcomputer")
        XCTAssertEqual(Subject.business.icon, "briefcase")
        XCTAssertEqual(Subject.health.icon, "heart")
        XCTAssertEqual(Subject.philosophy.icon, "brain")
    }
    
    // MARK: - Learning Goal Tests
    func testLearningGoalCreation() {
        // Given
        let title = "Learn Swift"
        let description = "Master Swift programming language"
        let targetDate = Date().addingTimeInterval(86400 * 30) // 30 days from now
        
        // When
        let goal = LearningGoal(
            title: title,
            description: description,
            targetDate: targetDate
        )
        
        // Then
        XCTAssertEqual(goal.title, title)
        XCTAssertEqual(goal.description, description)
        XCTAssertEqual(goal.targetDate, targetDate)
        XCTAssertFalse(goal.isCompleted)
        XCTAssertEqual(goal.progress, 0.0)
    }
    
    func testLearningGoalCompletion() {
        // Given
        var goal = LearningGoal(
            title: "Test Goal",
            description: "Test Description"
        )
        
        // When
        goal.isCompleted = true
        goal.progress = 1.0
        
        // Then
        XCTAssertTrue(goal.isCompleted)
        XCTAssertEqual(goal.progress, 1.0)
    }
    
    // MARK: - Achievement Tests
    func testAchievementCreation() {
        // Given
        let title = "First Achievement"
        let description = "Completed first milestone"
        let icon = "star.fill"
        let points = 50
        
        // When
        let achievement = Achievement(
            title: title,
            description: description,
            icon: icon,
            points: points
        )
        
        // Then
        XCTAssertEqual(achievement.title, title)
        XCTAssertEqual(achievement.description, description)
        XCTAssertEqual(achievement.icon, icon)
        XCTAssertEqual(achievement.points, points)
        XCTAssertFalse(achievement.isUnlocked)
        XCTAssertNil(achievement.unlockedAt)
    }
    
    func testAchievementUnlock() {
        // Given
        var achievement = Achievement(
            title: "Test Achievement",
            description: "Test Description",
            icon: "star",
            points: 25
        )
        
        // When
        achievement.isUnlocked = true
        achievement.unlockedAt = Date()
        
        // Then
        XCTAssertTrue(achievement.isUnlocked)
        XCTAssertNotNil(achievement.unlockedAt)
    }
    
    // MARK: - User Progress Tests
    func testUserProgressCreation() {
        // Given
        let totalPoints = 150
        let totalLessonsCompleted = 5
        let totalQuizzesPassed = 3
        let currentStreak = 7
        let longestStreak = 15
        let averageScore = 85.5
        
        // When
        let progress = UserProgress(
            totalPoints: totalPoints,
            totalLessonsCompleted: totalLessonsCompleted,
            totalQuizzesPassed: totalQuizzesPassed,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            averageScore: averageScore
        )
        
        // Then
        XCTAssertEqual(progress.totalPoints, totalPoints)
        XCTAssertEqual(progress.totalLessonsCompleted, totalLessonsCompleted)
        XCTAssertEqual(progress.totalQuizzesPassed, totalQuizzesPassed)
        XCTAssertEqual(progress.currentStreak, currentStreak)
        XCTAssertEqual(progress.longestStreak, longestStreak)
        XCTAssertEqual(progress.averageScore, averageScore)
    }
    
    func testSubjectProgress() {
        // Given
        let subject = Subject.mathematics
        let lessonsCompleted = 10
        let quizzesPassed = 5
        let averageScore = 92.0
        let timeSpent: TimeInterval = 3600 // 1 hour
        let level = LearningLevel.intermediate
        
        // When
        let subjectProgress = SubjectProgress(
            lessonsCompleted: lessonsCompleted,
            quizzesPassed: quizzesPassed,
            averageScore: averageScore,
            timeSpent: timeSpent,
            currentLevel: level
        )
        
        // Then
        XCTAssertEqual(subjectProgress.lessonsCompleted, lessonsCompleted)
        XCTAssertEqual(subjectProgress.quizzesPassed, quizzesPassed)
        XCTAssertEqual(subjectProgress.averageScore, averageScore)
        XCTAssertEqual(subjectProgress.timeSpent, timeSpent)
        XCTAssertEqual(subjectProgress.currentLevel, level)
    }
    
    // MARK: - User Settings Tests
    func testUserSettingsCreation() {
        // Given
        let notificationsEnabled = true
        let dailyReminderEnabled = true
        let soundEnabled = false
        let hapticFeedbackEnabled = true
        let autoPlayEnabled = false
        let offlineModeEnabled = true
        let dataUsageLimit = DataUsageLimit.medium
        let language = Language.english
        let theme = AppTheme.dark
        
        // When
        let settings = UserSettings(
            notificationsEnabled: notificationsEnabled,
            dailyReminderEnabled: dailyReminderEnabled,
            soundEnabled: soundEnabled,
            hapticFeedbackEnabled: hapticFeedbackEnabled,
            autoPlayEnabled: autoPlayEnabled,
            offlineModeEnabled: offlineModeEnabled,
            dataUsageLimit: dataUsageLimit,
            language: language,
            theme: theme
        )
        
        // Then
        XCTAssertEqual(settings.notificationsEnabled, notificationsEnabled)
        XCTAssertEqual(settings.dailyReminderEnabled, dailyReminderEnabled)
        XCTAssertEqual(settings.soundEnabled, soundEnabled)
        XCTAssertEqual(settings.hapticFeedbackEnabled, hapticFeedbackEnabled)
        XCTAssertEqual(settings.autoPlayEnabled, autoPlayEnabled)
        XCTAssertEqual(settings.offlineModeEnabled, offlineModeEnabled)
        XCTAssertEqual(settings.dataUsageLimit, dataUsageLimit)
        XCTAssertEqual(settings.language, language)
        XCTAssertEqual(settings.theme, theme)
    }
    
    // MARK: - Data Usage Limit Tests
    func testDataUsageLimitDisplayNames() {
        XCTAssertEqual(DataUsageLimit.unlimited.displayName, "Sınırsız")
        XCTAssertEqual(DataUsageLimit.low.displayName, "Düşük")
        XCTAssertEqual(DataUsageLimit.medium.displayName, "Orta")
        XCTAssertEqual(DataUsageLimit.high.displayName, "Yüksek")
    }
    
    // MARK: - Language Tests
    func testLanguageDisplayNames() {
        XCTAssertEqual(Language.turkish.displayName, "Türkçe")
        XCTAssertEqual(Language.english.displayName, "English")
        XCTAssertEqual(Language.spanish.displayName, "Español")
        XCTAssertEqual(Language.french.displayName, "Français")
        XCTAssertEqual(Language.german.displayName, "Deutsch")
        XCTAssertEqual(Language.italian.displayName, "Italiano")
        XCTAssertEqual(Language.portuguese.displayName, "Português")
        XCTAssertEqual(Language.russian.displayName, "Русский")
        XCTAssertEqual(Language.chinese.displayName, "中文")
        XCTAssertEqual(Language.japanese.displayName, "日本語")
        XCTAssertEqual(Language.korean.displayName, "한국어")
        XCTAssertEqual(Language.arabic.displayName, "العربية")
    }
    
    // MARK: - App Theme Tests
    func testAppThemeDisplayNames() {
        XCTAssertEqual(AppTheme.system.displayName, "Sistem")
        XCTAssertEqual(AppTheme.light.displayName, "Açık")
        XCTAssertEqual(AppTheme.dark.displayName, "Koyu")
    }
    
    // MARK: - Subscription Tests
    func testSubscriptionCreation() {
        // Given
        let type = SubscriptionType.pro
        let startDate = Date()
        let price = Decimal(19.99)
        let currency = "USD"
        
        // When
        let subscription = Subscription(
            type: type,
            startDate: startDate,
            price: price,
            currency: currency
        )
        
        // Then
        XCTAssertEqual(subscription.type, type)
        XCTAssertEqual(subscription.startDate, startDate)
        XCTAssertEqual(subscription.price, price)
        XCTAssertEqual(subscription.currency, currency)
        XCTAssertTrue(subscription.isActive)
        XCTAssertTrue(subscription.autoRenew)
    }
    
    func testSubscriptionTypeFeatures() {
        XCTAssertEqual(SubscriptionType.basic.features.count, 3)
        XCTAssertEqual(SubscriptionType.pro.features.count, 5)
        XCTAssertEqual(SubscriptionType.elite.features.count, 6)
        
        XCTAssertTrue(SubscriptionType.basic.features.contains("Temel AI özellikleri"))
        XCTAssertTrue(SubscriptionType.pro.features.contains("Gelişmiş AI özellikleri"))
        XCTAssertTrue(SubscriptionType.elite.features.contains("Kişisel AI öğretmen"))
    }
    
    // MARK: - Codable Tests
    func testUserCodable() throws {
        // Given
        let user = User(
            email: "test@example.com",
            username: "testuser",
            firstName: "Test",
            lastName: "User",
            learningLevel: .intermediate,
            preferredSubjects: [.mathematics, .science]
        )
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(user)
        let decoder = JSONDecoder()
        let decodedUser = try decoder.decode(User.self, from: data)
        
        // Then
        XCTAssertEqual(user.id, decodedUser.id)
        XCTAssertEqual(user.email, decodedUser.email)
        XCTAssertEqual(user.username, decodedUser.username)
        XCTAssertEqual(user.firstName, decodedUser.firstName)
        XCTAssertEqual(user.lastName, decodedUser.lastName)
        XCTAssertEqual(user.learningLevel, decodedUser.learningLevel)
        XCTAssertEqual(user.preferredSubjects, decodedUser.preferredSubjects)
    }
    
    // MARK: - Equatable Tests
    func testUserEquatable() {
        // Given
        let userId = UUID()
        let now = Date()
        let user1 = User(
            id: userId,
            email: "test@example.com",
            username: "testuser",
            firstName: "Test",
            lastName: "User",
            createdAt: now,
            updatedAt: now
        )
        
        let user2 = User(
            id: userId,
            email: "test@example.com",
            username: "testuser",
            firstName: "Test",
            lastName: "User",
            createdAt: now,
            updatedAt: now
        )
        
        let user3 = User(
            email: "different@example.com",
            username: "differentuser",
            firstName: "Different",
            lastName: "User"
        )
        
        // Then
        XCTAssertEqual(user1, user2)
        XCTAssertNotEqual(user1, user3)
    }
    
    // MARK: - Performance Tests
    func testUserCreationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = User(
                    email: "test@example.com",
                    username: "testuser",
                    firstName: "Test",
                    lastName: "User"
                )
            }
        }
    }
    
    func testUserCodablePerformance() throws {
        let user = User(
            email: "test@example.com",
            username: "testuser",
            firstName: "Test",
            lastName: "User",
            learningLevel: .intermediate,
            preferredSubjects: [.mathematics, .science, .technology],
            learningGoals: [
                LearningGoal(title: "Goal 1", description: "Description 1"),
                LearningGoal(title: "Goal 2", description: "Description 2")
            ],
            achievements: [
                Achievement(title: "Achievement 1", description: "Desc 1", icon: "star", points: 10),
                Achievement(title: "Achievement 2", description: "Desc 2", icon: "star.fill", points: 20)
            ]
        )
        
        measure {
            for _ in 0..<100 {
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(user)
                    let decoder = JSONDecoder()
                    _ = try decoder.decode(User.self, from: data)
                } catch {
                    XCTFail("Encoding/Decoding failed: \(error)")
                }
            }
        }
    }
} 