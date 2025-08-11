import XCTest
@testable import EducationAI

final class UserTests: XCTestCase {
    
    // MARK: - Test Properties
    var sampleUser: User!
    var sampleUser2: User!
    
    // MARK: - Setup and Teardown
    override func setUp() {
        super.setUp()
        
        sampleUser = User(
            email: "test@example.com",
            username: "testuser",
            firstName: "John",
            lastName: "Doe",
            profileImageURL: URL(string: "https://example.com/avatar.jpg"),
            dateOfBirth: Calendar.current.date(from: DateComponents(year: 1990, month: 6, day: 15)),
            learningStyle: .visual,
            preferredSubjects: [.mathematics, .computerScience],
            skillLevel: .intermediate,
            timeZone: TimeZone(identifier: "America/New_York")!,
            notificationPreferences: NotificationPreferences(
                pushEnabled: true,
                emailEnabled: false,
                studyReminders: true,
                achievementNotifications: true,
                socialNotifications: false,
                quietHours: 22...8
            ),
            accessibilitySettings: AccessibilitySettings(
                voiceOverEnabled: false,
                dynamicTypeEnabled: true,
                highContrastEnabled: false,
                reduceMotionEnabled: true,
                audioDescriptionsEnabled: false
            ),
            languagePreference: .english
        )
        
        sampleUser2 = User(
            email: "jane@example.com",
            username: "janedoe",
            firstName: "Jane",
            lastName: "Smith",
            learningStyle: .auditory,
            preferredSubjects: [.language, .literature],
            skillLevel: .beginner
        )
    }
    
    override func tearDown() {
        sampleUser = nil
        sampleUser2 = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testUserInitialization() {
        // Given & When
        let user = sampleUser
        
        // Then
        XCTAssertNotNil(user)
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.username, "testuser")
        XCTAssertEqual(user.firstName, "John")
        XCTAssertEqual(user.lastName, "Doe")
        XCTAssertEqual(user.learningStyle, .visual)
        XCTAssertEqual(user.preferredSubjects, [.mathematics, .computerScience])
        XCTAssertEqual(user.skillLevel, .intermediate)
        XCTAssertEqual(user.languagePreference, .english)
    }
    
    func testUserDefaultValues() {
        // Given & When
        let user = sampleUser2
        
        // Then
        XCTAssertEqual(user.totalStudyTime, 0)
        XCTAssertEqual(user.completedCourses, 0)
        XCTAssertEqual(user.currentStreak, 0)
        XCTAssertEqual(user.longestStreak, 0)
        XCTAssertEqual(user.averageScore, 0.0)
        XCTAssertNotNil(user.createdAt)
        XCTAssertNotNil(user.lastActiveAt)
        XCTAssertEqual(user.notificationPreferences.pushEnabled, true)
        XCTAssertEqual(user.accessibilitySettings.voiceOverEnabled, false)
    }
    
    func testUserWithMinimalData() {
        // Given & When
        let user = User(
            email: "minimal@example.com",
            username: "minimal",
            firstName: "Min",
            lastName: "User"
        )
        
        // Then
        XCTAssertNotNil(user)
        XCTAssertEqual(user.email, "minimal@example.com")
        XCTAssertEqual(user.learningStyle, .visual) // Default value
        XCTAssertEqual(user.skillLevel, .beginner) // Default value
        XCTAssertEqual(user.languagePreference, .english) // Default value
    }
    
    // MARK: - Computed Properties Tests
    
    func testFullName() {
        // Given & When
        let fullName = sampleUser.fullName
        
        // Then
        XCTAssertEqual(fullName, "John Doe")
    }
    
    func testDisplayNameWithUsername() {
        // Given & When
        let displayName = sampleUser.displayName
        
        // Then
        XCTAssertEqual(displayName, "testuser")
    }
    
    func testDisplayNameWithoutUsername() {
        // Given & When
        let userWithoutUsername = User(
            email: "no@username.com",
            username: "",
            firstName: "No",
            lastName: "Username"
        )
        let displayName = userWithoutUsername.displayName
        
        // Then
        XCTAssertEqual(displayName, "No Username")
    }
    
    func testAgeCalculation() {
        // Given & When
        let age = sampleUser.age
        
        // Then
        XCTAssertNotNil(age)
        // Note: Age calculation depends on current date, so we test it's reasonable
        XCTAssertGreaterThan(age!, 20)
        XCTAssertLessThan(age!, 50)
    }
    
    func testAgeWithNoDateOfBirth() {
        // Given & When
        let userWithoutBirthDate = User(
            email: "nobirth@example.com",
            username: "nobirth",
            firstName: "No",
            lastName: "Birth"
        )
        let age = userWithoutBirthDate.age
        
        // Then
        XCTAssertNil(age)
    }
    
    func testIsActive() {
        // Given & When
        let isActive = sampleUser.isActive
        
        // Then
        XCTAssertTrue(isActive) // User was just created
    }
    
    func testProgressPercentage() {
        // Given & When
        let progress = sampleUser.progressPercentage
        
        // Then
        XCTAssertEqual(progress, 0.0) // No completed courses
    }
    
    func testProgressPercentageWithCourses() {
        // Given
        let userWithCourses = User(
            email: "courses@example.com",
            username: "courses",
            firstName: "With",
            lastName: "Courses",
            completedCourses: 25
        )
        
        // When
        let progress = userWithCourses.progressPercentage
        
        // Then
        XCTAssertEqual(progress, 0.25) // 25/100 = 0.25
    }
    
    func testProgressPercentageCap() {
        // Given
        let userWithManyCourses = User(
            email: "many@example.com",
            username: "many",
            firstName: "Many",
            lastName: "Courses",
            completedCourses: 150
        )
        
        // When
        let progress = userWithManyCourses.progressPercentage
        
        // Then
        XCTAssertEqual(progress, 1.0) // Capped at 100%
    }
    
    // MARK: - Learning Style Tests
    
    func testLearningStyleDescriptions() {
        // Given & When & Then
        XCTAssertEqual(LearningStyle.visual.description, "Visual Learner")
        XCTAssertEqual(LearningStyle.auditory.description, "Auditory Learner")
        XCTAssertEqual(LearningStyle.kinesthetic.description, "Hands-on Learner")
        XCTAssertEqual(LearningStyle.reading.description, "Reading/Writing Learner")
        XCTAssertEqual(LearningStyle.mixed.description, "Mixed Learning Style")
    }
    
    func testLearningStyleCases() {
        // Given & When & Then
        XCTAssertEqual(LearningStyle.allCases.count, 5)
        XCTAssertTrue(LearningStyle.allCases.contains(.visual))
        XCTAssertTrue(LearningStyle.allCases.contains(.auditory))
        XCTAssertTrue(LearningStyle.allCases.contains(.kinesthetic))
        XCTAssertTrue(LearningStyle.allCases.contains(.reading))
        XCTAssertTrue(LearningStyle.allCases.contains(.mixed))
    }
    
    // MARK: - Skill Level Tests
    
    func testSkillLevelDescriptions() {
        // Given & When & Then
        XCTAssertEqual(SkillLevel.beginner.description, "Beginner")
        XCTAssertEqual(SkillLevel.intermediate.description, "Intermediate")
        XCTAssertEqual(SkillLevel.advanced.description, "Advanced")
        XCTAssertEqual(SkillLevel.expert.description, "Expert")
    }
    
    func testSkillLevelComparison() {
        // Given & When & Then
        XCTAssertTrue(SkillLevel.beginner < SkillLevel.intermediate)
        XCTAssertTrue(SkillLevel.intermediate < SkillLevel.advanced)
        XCTAssertTrue(SkillLevel.advanced < SkillLevel.expert)
        XCTAssertFalse(SkillLevel.expert < SkillLevel.beginner)
    }
    
    func testSkillLevelCases() {
        // Given & When & Then
        XCTAssertEqual(SkillLevel.allCases.count, 4)
        XCTAssertTrue(SkillLevel.allCases.contains(.beginner))
        XCTAssertTrue(SkillLevel.allCases.contains(.intermediate))
        XCTAssertTrue(SkillLevel.allCases.contains(.advanced))
        XCTAssertTrue(SkillLevel.allCases.contains(.expert))
    }
    
    // MARK: - Subject Tests
    
    func testSubjectDisplayNames() {
        // Given & When & Then
        XCTAssertEqual(Subject.mathematics.displayName, "Mathematics")
        XCTAssertEqual(Subject.computerScience.displayName, "Computer Science")
        XCTAssertEqual(Subject.language.displayName, "Language")
        XCTAssertEqual(Subject.art.displayName, "Art")
        XCTAssertEqual(Subject.music.displayName, "Music")
    }
    
    func testSubjectCases() {
        // Given & When & Then
        XCTAssertEqual(Subject.allCases.count, 12)
        XCTAssertTrue(Subject.allCases.contains(.mathematics))
        XCTAssertTrue(Subject.allCases.contains(.computerScience))
        XCTAssertTrue(Subject.allCases.contains(.language))
        XCTAssertTrue(Subject.allCases.contains(.art))
        XCTAssertTrue(Subject.allCases.contains(.music))
    }
    
    // MARK: - Language Tests
    
    func testLanguageDisplayNames() {
        // Given & When & Then
        XCTAssertEqual(Language.english.displayName, "English")
        XCTAssertEqual(Language.spanish.displayName, "Español")
        XCTAssertEqual(Language.french.displayName, "Français")
        XCTAssertEqual(Language.german.displayName, "Deutsch")
        XCTAssertEqual(Language.chinese.displayName, "中文")
        XCTAssertEqual(Language.japanese.displayName, "日本語")
    }
    
    func testLanguageCases() {
        // Given & When & Then
        XCTAssertEqual(Language.allCases.count, 10)
        XCTAssertTrue(Language.allCases.contains(.english))
        XCTAssertTrue(Language.allCases.contains(.spanish))
        XCTAssertTrue(Language.allCases.contains(.french))
        XCTAssertTrue(Language.allCases.contains(.german))
        XCTAssertTrue(Language.allCases.contains(.chinese))
        XCTAssertTrue(Language.allCases.contains(.japanese))
    }
    
    // MARK: - Notification Preferences Tests
    
    func testNotificationPreferencesDefault() {
        // Given & When
        let defaultPrefs = NotificationPreferences.default
        
        // Then
        XCTAssertTrue(defaultPrefs.pushEnabled)
        XCTAssertTrue(defaultPrefs.emailEnabled)
        XCTAssertTrue(defaultPrefs.studyReminders)
        XCTAssertTrue(defaultPrefs.achievementNotifications)
        XCTAssertTrue(defaultPrefs.socialNotifications)
        XCTAssertEqual(defaultPrefs.quietHours, 22...8)
    }
    
    func testNotificationPreferencesCustom() {
        // Given & When
        let customPrefs = NotificationPreferences(
            pushEnabled: false,
            emailEnabled: true,
            studyReminders: false,
            achievementNotifications: true,
            socialNotifications: false,
            quietHours: 23...7
        )
        
        // Then
        XCTAssertFalse(customPrefs.pushEnabled)
        XCTAssertTrue(customPrefs.emailEnabled)
        XCTAssertFalse(customPrefs.studyReminders)
        XCTAssertTrue(customPrefs.achievementNotifications)
        XCTAssertFalse(customPrefs.socialNotifications)
        XCTAssertEqual(customPrefs.quietHours, 23...7)
    }
    
    // MARK: - Accessibility Settings Tests
    
    func testAccessibilitySettingsDefault() {
        // Given & When
        let defaultSettings = AccessibilitySettings.default
        
        // Then
        XCTAssertFalse(defaultSettings.voiceOverEnabled)
        XCTAssertFalse(defaultSettings.dynamicTypeEnabled)
        XCTAssertFalse(defaultSettings.highContrastEnabled)
        XCTAssertFalse(defaultSettings.reduceMotionEnabled)
        XCTAssertFalse(defaultSettings.audioDescriptionsEnabled)
    }
    
    func testAccessibilitySettingsCustom() {
        // Given & When
        let customSettings = AccessibilitySettings(
            voiceOverEnabled: true,
            dynamicTypeEnabled: true,
            highContrastEnabled: true,
            reduceMotionEnabled: false,
            audioDescriptionsEnabled: true
        )
        
        // Then
        XCTAssertTrue(customSettings.voiceOverEnabled)
        XCTAssertTrue(customSettings.dynamicTypeEnabled)
        XCTAssertTrue(customSettings.highContrastEnabled)
        XCTAssertFalse(customSettings.reduceMotionEnabled)
        XCTAssertTrue(customSettings.audioDescriptionsEnabled)
    }
    
    // MARK: - User Update Tests
    
    func testUpdateLastActive() {
        // Given
        let originalLastActive = sampleUser.lastActiveAt
        
        // When
        let updatedUser = sampleUser.updateLastActive()
        
        // Then
        XCTAssertGreaterThan(updatedUser.lastActiveAt, originalLastActive)
    }
    
    func testUpdateStudyTime() {
        // Given
        let additionalTime: TimeInterval = 3600 // 1 hour
        
        // When
        let updatedUser = sampleUser.updateStudyTime(additionalTime)
        
        // Then
        XCTAssertEqual(updatedUser.totalStudyTime, additionalTime)
    }
    
    func testCompleteCourse() {
        // Given
        let originalCompletedCourses = sampleUser.completedCourses
        
        // When
        let updatedUser = sampleUser.completeCourse()
        
        // Then
        XCTAssertEqual(updatedUser.completedCourses, originalCompletedCourses + 1)
    }
    
    func testUpdateStreak() {
        // Given
        let newStreak = 10
        
        // When
        let updatedUser = sampleUser.updateStreak(newStreak)
        
        // Then
        XCTAssertEqual(updatedUser.currentStreak, newStreak)
        XCTAssertEqual(updatedUser.longestStreak, newStreak)
    }
    
    func testUpdateStreakMaintainsLongest() {
        // Given
        let userWithLongStreak = User(
            email: "longstreak@example.com",
            username: "longstreak",
            firstName: "Long",
            lastName: "Streak",
            longestStreak: 20
        )
        let newStreak = 15
        
        // When
        let updatedUser = userWithLongStreak.updateStreak(newStreak)
        
        // Then
        XCTAssertEqual(updatedUser.currentStreak, newStreak)
        XCTAssertEqual(updatedUser.longestStreak, 20) // Maintains longest
    }
    
    func testUpdateAverageScore() {
        // Given
        let newScore = 0.85
        
        // When
        let updatedUser = sampleUser.updateAverageScore(newScore)
        
        // Then
        XCTAssertEqual(updatedUser.averageScore, newScore)
    }
    
    func testUpdateAverageScoreWithExistingCourses() {
        // Given
        let userWithCourses = User(
            email: "existing@example.com",
            username: "existing",
            firstName: "Existing",
            lastName: "User",
            completedCourses: 3,
            averageScore: 0.75
        )
        let newScore = 0.90
        
        // When
        let updatedUser = userWithCourses.updateAverageScore(newScore)
        
        // Then
        // Expected: (3 * 0.75 + 0.90) / 4 = 0.7875
        XCTAssertEqual(updatedUser.averageScore, 0.7875, accuracy: 0.001)
    }
    
    // MARK: - Codable Tests
    
    func testUserEncoding() throws {
        // Given
        let user = sampleUser
        
        // When
        let data = try JSONEncoder().encode(user)
        let decodedUser = try JSONDecoder().decode(User.self, from: data)
        
        // Then
        XCTAssertEqual(decodedUser.id, user.id)
        XCTAssertEqual(decodedUser.email, user.email)
        XCTAssertEqual(decodedUser.username, user.username)
        XCTAssertEqual(decodedUser.firstName, user.firstName)
        XCTAssertEqual(decodedUser.lastName, user.lastName)
        XCTAssertEqual(decodedUser.learningStyle, user.learningStyle)
        XCTAssertEqual(decodedUser.skillLevel, user.skillLevel)
        XCTAssertEqual(decodedUser.languagePreference, user.languagePreference)
    }
    
    func testUserEquality() {
        // Given
        let user1 = sampleUser
        let user2 = User(
            email: "test@example.com",
            username: "testuser",
            firstName: "John",
            lastName: "Doe",
            learningStyle: .visual,
            preferredSubjects: [.mathematics, .computerScience],
            skillLevel: .intermediate
        )
        
        // When & Then
        XCTAssertEqual(user1, user2)
    }
    
    func testUserInequality() {
        // Given
        let user1 = sampleUser
        let user2 = sampleUser2
        
        // When & Then
        XCTAssertNotEqual(user1, user2)
    }
    
    // MARK: - Performance Tests
    
    func testUserCreationPerformance() {
        // Given & When & Then
        measure {
            for _ in 0..<1000 {
                _ = User(
                    email: "perf@example.com",
                    username: "perf",
                    firstName: "Perf",
                    lastName: "User"
                )
            }
        }
    }
    
    func testUserUpdatePerformance() {
        // Given
        let user = sampleUser
        
        // When & Then
        measure {
            for _ in 0..<1000 {
                _ = user.updateStudyTime(3600)
            }
        }
    }
    
    // MARK: - Edge Cases
    
    func testUserWithVeryLongNames() {
        // Given
        let longFirstName = String(repeating: "A", count: 1000)
        let longLastName = String(repeating: "B", count: 1000)
        
        // When
        let user = User(
            email: "long@example.com",
            username: "longnames",
            firstName: longFirstName,
            lastName: longLastName
        )
        
        // Then
        XCTAssertEqual(user.firstName, longFirstName)
        XCTAssertEqual(user.lastName, longLastName)
        XCTAssertEqual(user.fullName, "\(longFirstName) \(longLastName)")
    }
    
    func testUserWithSpecialCharacters() {
        // Given
        let specialFirstName = "José María"
        let specialLastName = "O'Connor-Smith"
        
        // When
        let user = User(
            email: "special@example.com",
            username: "specialchars",
            firstName: specialFirstName,
            lastName: specialLastName
        )
        
        // Then
        XCTAssertEqual(user.firstName, specialFirstName)
        XCTAssertEqual(user.lastName, specialLastName)
        XCTAssertEqual(user.fullName, "\(specialFirstName) \(specialLastName)")
    }
    
    func testUserWithEmptyStrings() {
        // Given
        let user = User(
            email: "empty@example.com",
            username: "",
            firstName: "",
            lastName: ""
        )
        
        // Then
        XCTAssertEqual(user.fullName, " ")
        XCTAssertEqual(user.displayName, " ")
    }
    
    // MARK: - Validation Tests
    
    func testUserWithValidEmail() {
        // Given & When
        let user = User(
            email: "valid.email+tag@domain.co.uk",
            username: "validemail",
            firstName: "Valid",
            lastName: "Email"
        )
        
        // Then
        XCTAssertEqual(user.email, "valid.email+tag@domain.co.uk")
    }
    
    func testUserWithValidURL() {
        // Given
        let validURL = URL(string: "https://example.com/avatar.jpg")
        
        // When
        let user = User(
            email: "url@example.com",
            username: "urluser",
            firstName: "URL",
            lastName: "User",
            profileImageURL: validURL
        )
        
        // Then
        XCTAssertEqual(user.profileImageURL, validURL)
    }
    
    func testUserWithInvalidURL() {
        // Given
        let invalidURL = URL(string: "not-a-valid-url")
        
        // When
        let user = User(
            email: "invalidurl@example.com",
            username: "invalidurl",
            firstName: "Invalid",
            lastName: "URL",
            profileImageURL: invalidURL
        )
        
        // Then
        XCTAssertEqual(user.profileImageURL, invalidURL)
    }
}
