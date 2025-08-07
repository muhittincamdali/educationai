import XCTest
@testable import EducationAI

/// Unit tests for GetPersonalizedRecommendationsUseCase
/// Tests the core business logic for AI-powered recommendation system
final class GetPersonalizedRecommendationsUseCaseTests: XCTestCase {
    
    // MARK: - Properties
    
    var useCase: GetPersonalizedRecommendationsUseCase!
    var mockUserRepository: MockUserRepository!
    var mockCourseRepository: MockCourseRepository!
    var mockAIEngine: MockAIEngine!
    var mockAnalyticsService: MockAnalyticsService!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        mockUserRepository = MockUserRepository()
        mockCourseRepository = MockCourseRepository()
        mockAIEngine = MockAIEngine()
        mockAnalyticsService = MockAnalyticsService()
        
        useCase = GetPersonalizedRecommendationsUseCaseImpl(
            userRepository: mockUserRepository,
            courseRepository: mockCourseRepository,
            aiEngine: mockAIEngine,
            analyticsService: mockAnalyticsService
        )
    }
    
    override func tearDown() {
        useCase = nil
        mockUserRepository = nil
        mockCourseRepository = nil
        mockAIEngine = nil
        mockAnalyticsService = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    
    func testExecute_WithValidUser_ReturnsRecommendations() async throws {
        // Given
        let userId = "user123"
        let user = createMockUser(id: userId)
        let courses = createMockCourses()
        let recommendations = createMockRecommendations()
        
        mockUserRepository.mockGetUser = user
        mockCourseRepository.mockGetCourses = courses
        mockAIEngine.mockGenerateRecommendations = recommendations
        
        // When
        let result = try await useCase.execute(for: userId)
        
        // Then
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result.first?.id, "rec1")
        XCTAssertEqual(result.first?.title, "Swift Basics")
        XCTAssertEqual(result.first?.relevanceScore, 0.85, accuracy: 0.01)
        
        // Verify analytics were tracked
        XCTAssertTrue(mockAnalyticsService.trackRecommendationsGeneratedCalled)
        XCTAssertEqual(mockAnalyticsService.trackRecommendationsGeneratedUserId, userId)
        XCTAssertEqual(mockAnalyticsService.trackRecommendationsGeneratedCount, 3)
    }
    
    func testExecute_WithEmptyUserId_ThrowsInvalidInputError() async {
        // Given
        let userId = ""
        
        // When & Then
        do {
            _ = try await useCase.execute(for: userId)
            XCTFail("Expected error to be thrown")
        } catch EducationAIError.invalidInput(let message) {
            XCTAssertEqual(message, "User ID cannot be empty")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testExecute_WithUserNotFound_ThrowsUserNotFoundError() async {
        // Given
        let userId = "nonexistent"
        mockUserRepository.mockGetUserError = EducationAIError.userNotFound
        
        // When & Then
        do {
            _ = try await useCase.execute(for: userId)
            XCTFail("Expected error to be thrown")
        } catch EducationAIError.userNotFound {
            // Expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testExecute_WithCoursesUnavailable_ThrowsCoursesUnavailableError() async {
        // Given
        let userId = "user123"
        let user = createMockUser(id: userId)
        mockUserRepository.mockGetUser = user
        mockCourseRepository.mockGetCoursesError = EducationAIError.coursesUnavailable
        
        // When & Then
        do {
            _ = try await useCase.execute(for: userId)
            XCTFail("Expected error to be thrown")
        } catch EducationAIError.coursesUnavailable {
            // Expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testExecute_WithAIServiceUnavailable_ThrowsAIServiceUnavailableError() async {
        // Given
        let userId = "user123"
        let user = createMockUser(id: userId)
        let courses = createMockCourses()
        
        mockUserRepository.mockGetUser = user
        mockCourseRepository.mockGetCourses = courses
        mockAIEngine.mockGenerateRecommendationsError = EducationAIError.aiServiceUnavailable
        
        // When & Then
        do {
            _ = try await useCase.execute(for: userId)
            XCTFail("Expected error to be thrown")
        } catch EducationAIError.aiServiceUnavailable {
            // Expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testExecute_WithCompletedCourses_FiltersOutCompletedCourses() async throws {
        // Given
        let userId = "user123"
        let user = createMockUserWithCompletedCourses(id: userId)
        let courses = createMockCourses()
        let recommendations = createMockRecommendations()
        
        mockUserRepository.mockGetUser = user
        mockCourseRepository.mockGetCourses = courses
        mockAIEngine.mockGenerateRecommendations = recommendations
        
        // When
        let result = try await useCase.execute(for: userId)
        
        // Then
        // Should filter out courses that user has already completed
        XCTAssertEqual(result.count, 2) // Only 2 courses should be recommended
        XCTAssertFalse(result.contains { $0.id == "course1" }) // This course is completed
    }
    
    func testExecute_WithHighScoringUser_ReturnsAdvancedRecommendations() async throws {
        // Given
        let userId = "user123"
        let user = createMockUserWithHighScore(id: userId)
        let courses = createMockCourses()
        let recommendations = createMockRecommendations()
        
        mockUserRepository.mockGetUser = user
        mockCourseRepository.mockGetCourses = courses
        mockAIEngine.mockGenerateRecommendations = recommendations
        
        // When
        let result = try await useCase.execute(for: userId)
        
        // Then
        // High-scoring users should get more advanced recommendations
        XCTAssertTrue(result.allSatisfy { $0.relevanceScore > 0.7 })
    }
    
    func testExecute_WithLowScoringUser_ReturnsBeginnerRecommendations() async throws {
        // Given
        let userId = "user123"
        let user = createMockUserWithLowScore(id: userId)
        let courses = createMockCourses()
        let recommendations = createMockRecommendations()
        
        mockUserRepository.mockGetUser = user
        mockCourseRepository.mockGetCourses = courses
        mockAIEngine.mockGenerateRecommendations = recommendations
        
        // When
        let result = try await useCase.execute(for: userId)
        
        // Then
        // Low-scoring users should get more beginner-friendly recommendations
        XCTAssertTrue(result.allSatisfy { $0.difficulty == .beginner || $0.relevanceScore > 0.5 })
    }
    
    func testExecute_WithLimitedTimeUser_ReturnsShorterCourses() async throws {
        // Given
        let userId = "user123"
        let user = createMockUserWithLimitedTime(id: userId)
        let courses = createMockCourses()
        let recommendations = createMockRecommendations()
        
        mockUserRepository.mockGetUser = user
        mockCourseRepository.mockGetCourses = courses
        mockAIEngine.mockGenerateRecommendations = recommendations
        
        // When
        let result = try await useCase.execute(for: userId)
        
        // Then
        // Users with limited time should get shorter courses
        XCTAssertTrue(result.allSatisfy { $0.duration <= 1800 }) // 30 minutes max
    }
    
    func testExecute_WithPreferredSubjects_FiltersBySubject() async throws {
        // Given
        let userId = "user123"
        let user = createMockUserWithPreferredSubjects(id: userId)
        let courses = createMockCourses()
        let recommendations = createMockRecommendations()
        
        mockUserRepository.mockGetUser = user
        mockCourseRepository.mockGetCourses = courses
        mockAIEngine.mockGenerateRecommendations = recommendations
        
        // When
        let result = try await useCase.execute(for: userId)
        
        // Then
        // Should only return recommendations for preferred subjects
        XCTAssertTrue(result.allSatisfy { $0.subject == .programming })
    }
    
    func testExecute_WithPrerequisitesNotMet_FiltersOutAdvancedCourses() async throws {
        // Given
        let userId = "user123"
        let user = createMockUserWithoutPrerequisites(id: userId)
        let courses = createMockCourses()
        let recommendations = createMockRecommendations()
        
        mockUserRepository.mockGetUser = user
        mockCourseRepository.mockGetCourses = courses
        mockAIEngine.mockGenerateRecommendations = recommendations
        
        // When
        let result = try await useCase.execute(for: userId)
        
        // Then
        // Should only return courses where prerequisites are met
        XCTAssertTrue(result.allSatisfy { $0.prerequisites.isEmpty })
    }
    
    func testExecute_WithError_TracksErrorAnalytics() async {
        // Given
        let userId = "user123"
        mockUserRepository.mockGetUserError = EducationAIError.userNotFound
        
        // When
        do {
            _ = try await useCase.execute(for: userId)
        } catch {
            // Expected error
        }
        
        // Then
        XCTAssertTrue(mockAnalyticsService.trackErrorCalled)
        XCTAssertEqual(mockAnalyticsService.trackErrorContext, "GetPersonalizedRecommendationsUseCase")
        XCTAssertEqual(mockAnalyticsService.trackErrorUserId, userId)
    }
    
    // MARK: - Helper Methods
    
    private func createMockUser(id: String) -> User {
        return User(
            id: id,
            email: "test@example.com",
            name: "Test User",
            learningPreferences: LearningPreferences(
                preferredSubjects: [.programming, .mathematics],
                difficultyLevel: .intermediate,
                learningStyle: .visual,
                timeAvailability: TimeAvailability(
                    preferredSlots: [],
                    maxSessionDuration: 3600
                )
            ),
            progress: LearningProgress(
                completedLessons: [],
                currentCourse: nil,
                totalStudyTime: 7200,
                averageScore: 75.0,
                totalLessons: 10,
                averageSessionDuration: 1800
            )
        )
    }
    
    private func createMockUserWithCompletedCourses(id: String) -> User {
        return User(
            id: id,
            email: "test@example.com",
            name: "Test User",
            learningPreferences: LearningPreferences(
                preferredSubjects: [.programming],
                difficultyLevel: .intermediate,
                learningStyle: .visual,
                timeAvailability: TimeAvailability(
                    preferredSlots: [],
                    maxSessionDuration: 3600
                )
            ),
            progress: LearningProgress(
                completedLessons: ["course1"],
                currentCourse: nil,
                totalStudyTime: 7200,
                averageScore: 75.0,
                totalLessons: 10,
                averageSessionDuration: 1800
            )
        )
    }
    
    private func createMockUserWithHighScore(id: String) -> User {
        return User(
            id: id,
            email: "test@example.com",
            name: "Test User",
            learningPreferences: LearningPreferences(
                preferredSubjects: [.programming],
                difficultyLevel: .advanced,
                learningStyle: .visual,
                timeAvailability: TimeAvailability(
                    preferredSlots: [],
                    maxSessionDuration: 3600
                )
            ),
            progress: LearningProgress(
                completedLessons: [],
                currentCourse: nil,
                totalStudyTime: 14400,
                averageScore: 95.0,
                totalLessons: 20,
                averageSessionDuration: 2400
            )
        )
    }
    
    private func createMockUserWithLowScore(id: String) -> User {
        return User(
            id: id,
            email: "test@example.com",
            name: "Test User",
            learningPreferences: LearningPreferences(
                preferredSubjects: [.programming],
                difficultyLevel: .beginner,
                learningStyle: .visual,
                timeAvailability: TimeAvailability(
                    preferredSlots: [],
                    maxSessionDuration: 3600
                )
            ),
            progress: LearningProgress(
                completedLessons: [],
                currentCourse: nil,
                totalStudyTime: 1800,
                averageScore: 45.0,
                totalLessons: 5,
                averageSessionDuration: 900
            )
        )
    }
    
    private func createMockUserWithLimitedTime(id: String) -> User {
        return User(
            id: id,
            email: "test@example.com",
            name: "Test User",
            learningPreferences: LearningPreferences(
                preferredSubjects: [.programming],
                difficultyLevel: .intermediate,
                learningStyle: .visual,
                timeAvailability: TimeAvailability(
                    preferredSlots: [],
                    maxSessionDuration: 1800 // 30 minutes
                )
            ),
            progress: LearningProgress(
                completedLessons: [],
                currentCourse: nil,
                totalStudyTime: 3600,
                averageScore: 70.0,
                totalLessons: 8,
                averageSessionDuration: 1200
            )
        )
    }
    
    private func createMockUserWithPreferredSubjects(id: String) -> User {
        return User(
            id: id,
            email: "test@example.com",
            name: "Test User",
            learningPreferences: LearningPreferences(
                preferredSubjects: [.programming], // Only programming
                difficultyLevel: .intermediate,
                learningStyle: .visual,
                timeAvailability: TimeAvailability(
                    preferredSlots: [],
                    maxSessionDuration: 3600
                )
            ),
            progress: LearningProgress(
                completedLessons: [],
                currentCourse: nil,
                totalStudyTime: 7200,
                averageScore: 75.0,
                totalLessons: 10,
                averageSessionDuration: 1800
            )
        )
    }
    
    private func createMockUserWithoutPrerequisites(id: String) -> User {
        return User(
            id: id,
            email: "test@example.com",
            name: "Test User",
            learningPreferences: LearningPreferences(
                preferredSubjects: [.programming],
                difficultyLevel: .intermediate,
                learningStyle: .visual,
                timeAvailability: TimeAvailability(
                    preferredSlots: [],
                    maxSessionDuration: 3600
                )
            ),
            progress: LearningProgress(
                completedLessons: [], // No completed lessons
                currentCourse: nil,
                totalStudyTime: 7200,
                averageScore: 75.0,
                totalLessons: 10,
                averageSessionDuration: 1800
            )
        )
    }
    
    private func createMockCourses() -> [Course] {
        return [
            Course(
                id: "course1",
                title: "Swift Basics",
                description: "Learn Swift programming fundamentals",
                difficulty: .beginner,
                lessons: [],
                estimatedDuration: 3600
            ),
            Course(
                id: "course2",
                title: "iOS Development",
                description: "Build iOS apps with SwiftUI",
                difficulty: .intermediate,
                lessons: [],
                estimatedDuration: 7200
            ),
            Course(
                id: "course3",
                title: "Advanced Swift",
                description: "Master advanced Swift concepts",
                difficulty: .advanced,
                lessons: [],
                estimatedDuration: 10800
            )
        ]
    }
    
    private func createMockRecommendations() -> [Recommendation] {
        return [
            Recommendation(
                id: "rec1",
                title: "Swift Basics",
                description: "Learn Swift programming fundamentals",
                subject: .programming,
                difficulty: .beginner,
                duration: 3600,
                prerequisites: [],
                relevanceScore: 0.85
            ),
            Recommendation(
                id: "rec2",
                title: "iOS Development",
                description: "Build iOS apps with SwiftUI",
                subject: .programming,
                difficulty: .intermediate,
                duration: 7200,
                prerequisites: ["course1"],
                relevanceScore: 0.75
            ),
            Recommendation(
                id: "rec3",
                title: "Advanced Swift",
                description: "Master advanced Swift concepts",
                subject: .programming,
                difficulty: .advanced,
                duration: 10800,
                prerequisites: ["course1", "course2"],
                relevanceScore: 0.65
            )
        ]
    }
}

// MARK: - Mock Classes

/// Mock implementation of UserRepository for testing
final class MockUserRepository: UserRepository {
    var mockGetUser: User?
    var mockGetUserError: Error?
    
    func getUser(id: String) async throws -> User {
        if let error = mockGetUserError {
            throw error
        }
        return mockGetUser ?? User(
            id: id,
            email: "test@example.com",
            name: "Test User",
            learningPreferences: LearningPreferences(
                preferredSubjects: [.programming],
                difficultyLevel: .intermediate,
                learningStyle: .visual,
                timeAvailability: TimeAvailability(
                    preferredSlots: [],
                    maxSessionDuration: 3600
                )
            ),
            progress: LearningProgress(
                completedLessons: [],
                currentCourse: nil,
                totalStudyTime: 7200,
                averageScore: 75.0,
                totalLessons: 10,
                averageSessionDuration: 1800
            )
        )
    }
    
    func saveUser(_ user: User) async throws {
        // Mock implementation
    }
}

/// Mock implementation of CourseRepository for testing
final class MockCourseRepository: CourseRepository {
    var mockGetCourses: [Course]?
    var mockGetCoursesError: Error?
    
    func getCourses() async throws -> [Course] {
        if let error = mockGetCoursesError {
            throw error
        }
        return mockGetCourses ?? []
    }
    
    func getCourse(id: String) async throws -> Course {
        // Mock implementation
        return Course(
            id: id,
            title: "Mock Course",
            description: "Mock course description",
            difficulty: .beginner,
            lessons: [],
            estimatedDuration: 3600
        )
    }
    
    func enrollUser(_ userId: String, in courseId: String) async throws {
        // Mock implementation
    }
    
    func getCourseProgress(courseId: String, userId: String) async throws -> CourseProgress {
        // Mock implementation
        return CourseProgress(
            courseId: courseId,
            userId: userId,
            completedLessons: [],
            totalLessons: 10,
            progressPercentage: 0.0
        )
    }
}

/// Mock implementation of AIEngine for testing
final class MockAIEngine: AIEngine {
    var mockGenerateRecommendations: [Recommendation]?
    var mockGenerateRecommendationsError: Error?
    
    func generateRecommendations(
        for user: User,
        from courses: [Course],
        patterns: LearningPatterns
    ) async throws -> [Recommendation] {
        if let error = mockGenerateRecommendationsError {
            throw error
        }
        return mockGenerateRecommendations ?? []
    }
}

/// Mock implementation of AnalyticsService for testing
final class MockAnalyticsService: AnalyticsService {
    var trackRecommendationsGeneratedCalled = false
    var trackRecommendationsGeneratedUserId: String?
    var trackRecommendationsGeneratedCount: Int?
    
    var trackErrorCalled = false
    var trackErrorContext: String?
    var trackErrorUserId: String?
    
    func trackRecommendationsGenerated(userId: String, count: Int) async {
        trackRecommendationsGeneratedCalled = true
        trackRecommendationsGeneratedUserId = userId
        trackRecommendationsGeneratedCount = count
    }
    
    func trackError(error: Error, context: String, userId: String) async {
        trackErrorCalled = true
        trackErrorContext = context
        trackErrorUserId = userId
    }
}

// MARK: - Supporting Types

/// Course progress model
public struct CourseProgress {
    let courseId: String
    let userId: String
    let completedLessons: [String]
    let totalLessons: Int
    let progressPercentage: Double
}

/// Time availability model
public struct TimeAvailability {
    let preferredSlots: [TimeSlot]
    let maxSessionDuration: TimeInterval
}

/// Learning preferences model
public struct LearningPreferences {
    let preferredSubjects: [Subject]
    let difficultyLevel: DifficultyLevel
    let learningStyle: LearningStyle
    let timeAvailability: TimeAvailability
}

/// Learning progress model
public struct LearningProgress {
    let completedLessons: [String]
    let currentCourse: String?
    let totalStudyTime: TimeInterval
    let averageScore: Double
    let totalLessons: Int
    let averageSessionDuration: TimeInterval
}

/// User model
public struct User {
    let id: String
    let email: String
    let name: String
    let learningPreferences: LearningPreferences
    let progress: LearningProgress
}

/// Course model
public struct Course {
    let id: String
    let title: String
    let description: String
    let difficulty: DifficultyLevel
    let lessons: [Lesson]
    let estimatedDuration: TimeInterval
}

/// Lesson model
public struct Lesson {
    let id: String
    let title: String
    let content: String
    let duration: TimeInterval
}

/// Repository protocols
public protocol UserRepository {
    func getUser(id: String) async throws -> User
    func saveUser(_ user: User) async throws
}

public protocol CourseRepository {
    func getCourses() async throws -> [Course]
    func getCourse(id: String) async throws -> Course
    func enrollUser(_ userId: String, in courseId: String) async throws
    func getCourseProgress(courseId: String, userId: String) async throws -> CourseProgress
}

/// AI Engine protocol
public protocol AIEngine {
    func generateRecommendations(
        for user: User,
        from courses: [Course],
        patterns: LearningPatterns
    ) async throws -> [Recommendation]
}

/// Analytics Service protocol
public protocol AnalyticsService {
    func trackRecommendationsGenerated(userId: String, count: Int) async
    func trackError(error: Error, context: String, userId: String) async
}
