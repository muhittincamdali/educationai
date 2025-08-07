import Foundation

/// Use case for getting personalized learning recommendations
/// This is the core business logic for AI-powered recommendation system
public protocol GetPersonalizedRecommendationsUseCase {
    /// Execute the use case to get personalized recommendations for a user
    /// - Parameter userId: The unique identifier of the user
    /// - Returns: Array of personalized recommendations
    /// - Throws: EducationAIError if the operation fails
    func execute(for userId: String) async throws -> [Recommendation]
}

/// Implementation of the GetPersonalizedRecommendationsUseCase
public final class GetPersonalizedRecommendationsUseCaseImpl: GetPersonalizedRecommendationsUseCase {
    
    private let userRepository: UserRepository
    private let courseRepository: CourseRepository
    private let aiEngine: AIEngine
    private let analyticsService: AnalyticsService
    
    /// Initialize the use case with required dependencies
    /// - Parameters:
    ///   - userRepository: Repository for user data access
    ///   - courseRepository: Repository for course data access
    ///   - aiEngine: AI engine for generating recommendations
    ///   - analyticsService: Service for tracking analytics
    public init(
        userRepository: UserRepository,
        courseRepository: CourseRepository,
        aiEngine: AIEngine,
        analyticsService: AnalyticsService
    ) {
        self.userRepository = userRepository
        self.courseRepository = courseRepository
        self.aiEngine = aiEngine
        self.analyticsService = analyticsService
    }
    
    public func execute(for userId: String) async throws -> [Recommendation] {
        // Validate input
        guard !userId.isEmpty else {
            throw EducationAIError.invalidInput("User ID cannot be empty")
        }
        
        do {
            // Step 1: Get user data
            let user = try await userRepository.getUser(id: userId)
            
            // Step 2: Get available courses
            let courses = try await courseRepository.getCourses()
            
            // Step 3: Filter out completed courses
            let availableCourses = courses.filter { course in
                !user.progress.completedLessons.contains(course.id)
            }
            
            // Step 4: Analyze user learning patterns
            let learningPatterns = try await analyzeLearningPatterns(for: user)
            
            // Step 5: Generate AI recommendations
            let recommendations = try await aiEngine.generateRecommendations(
                for: user,
                from: availableCourses,
                patterns: learningPatterns
            )
            
            // Step 6: Apply business rules and filters
            let filteredRecommendations = applyBusinessRules(
                recommendations: recommendations,
                userPreferences: user.learningPreferences,
                userProgress: user.progress
            )
            
            // Step 7: Calculate relevance scores
            let scoredRecommendations = calculateRelevanceScores(
                recommendations: filteredRecommendations,
                userProgress: user.progress,
                learningPatterns: learningPatterns
            )
            
            // Step 8: Sort by relevance score
            let sortedRecommendations = scoredRecommendations.sorted { 
                $0.relevanceScore > $1.relevanceScore 
            }
            
            // Step 9: Limit to top recommendations
            let topRecommendations = Array(sortedRecommendations.prefix(10))
            
            // Step 10: Track analytics
            await analyticsService.trackRecommendationsGenerated(
                userId: userId,
                count: topRecommendations.count
            )
            
            return topRecommendations
            
        } catch {
            // Log error for debugging
            print("Error generating recommendations for user \(userId): \(error)")
            
            // Track error analytics
            await analyticsService.trackError(
                error: error,
                context: "GetPersonalizedRecommendationsUseCase",
                userId: userId
            )
            
            // Re-throw the error
            throw error
        }
    }
    
    // MARK: - Private Methods
    
    /// Analyze learning patterns for the given user
    /// - Parameter user: The user to analyze
    /// - Returns: Learning patterns analysis
    private func analyzeLearningPatterns(for user: User) async throws -> LearningPatterns {
        let patterns = LearningPatterns(
            preferredTimeSlots: user.learningPreferences.timeAvailability.preferredSlots,
            averageSessionDuration: user.progress.averageSessionDuration,
            preferredSubjects: user.learningPreferences.preferredSubjects,
            learningStyle: user.learningPreferences.learningStyle,
            completionRate: calculateCompletionRate(user.progress),
            engagementScore: calculateEngagementScore(user.progress),
            difficultyPreference: analyzeDifficultyPreference(user.progress)
        )
        
        return patterns
    }
    
    /// Apply business rules to filter recommendations
    /// - Parameters:
    ///   - recommendations: Raw recommendations from AI
    ///   - userPreferences: User's learning preferences
    ///   - userProgress: User's current progress
    /// - Returns: Filtered recommendations
    private func applyBusinessRules(
        recommendations: [Recommendation],
        userPreferences: LearningPreferences,
        userProgress: LearningProgress
    ) -> [Recommendation] {
        return recommendations.filter { recommendation in
            // Rule 1: Match user's preferred subjects
            let subjectMatch = userPreferences.preferredSubjects.contains(recommendation.subject)
            
            // Rule 2: Match user's difficulty level preference
            let difficultyMatch = recommendation.difficulty == userPreferences.difficultyLevel ||
                                 recommendation.difficulty == .beginner // Always include beginner courses
            
            // Rule 3: Check if user has prerequisites
            let prerequisitesMet = recommendation.prerequisites.allSatisfy { prerequisite in
                userProgress.completedLessons.contains(prerequisite)
            }
            
            // Rule 4: Check time availability
            let timeAvailable = recommendation.duration <= userPreferences.timeAvailability.maxSessionDuration
            
            return subjectMatch && difficultyMatch && prerequisitesMet && timeAvailable
        }
    }
    
    /// Calculate relevance scores for recommendations
    /// - Parameters:
    ///   - recommendations: Recommendations to score
    ///   - userProgress: User's current progress
    ///   - learningPatterns: Analyzed learning patterns
    /// - Returns: Recommendations with calculated scores
    private func calculateRelevanceScores(
        recommendations: [Recommendation],
        userProgress: LearningProgress,
        learningPatterns: LearningPatterns
    ) -> [Recommendation] {
        return recommendations.map { recommendation in
            var score: Double = 0.0
            
            // Factor 1: Subject preference (30% weight)
            let subjectScore = learningPatterns.preferredSubjects.contains(recommendation.subject) ? 1.0 : 0.0
            score += subjectScore * 0.3
            
            // Factor 2: Difficulty match (25% weight)
            let difficultyScore = calculateDifficultyScore(recommendation.difficulty, userProgress)
            score += difficultyScore * 0.25
            
            // Factor 3: Time availability (20% weight)
            let timeScore = calculateTimeScore(recommendation.duration, learningPatterns)
            score += timeScore * 0.2
            
            // Factor 4: Engagement potential (15% weight)
            let engagementScore = calculateEngagementScore(recommendation, userProgress)
            score += engagementScore * 0.15
            
            // Factor 5: Progress alignment (10% weight)
            let progressScore = calculateProgressScore(recommendation, userProgress)
            score += progressScore * 0.1
            
            return Recommendation(
                id: recommendation.id,
                title: recommendation.title,
                description: recommendation.description,
                subject: recommendation.subject,
                difficulty: recommendation.difficulty,
                duration: recommendation.duration,
                prerequisites: recommendation.prerequisites,
                relevanceScore: score
            )
        }
    }
    
    /// Calculate difficulty score based on user progress
    /// - Parameters:
    ///   - difficulty: Course difficulty
    ///   - userProgress: User's current progress
    /// - Returns: Difficulty score (0.0 to 1.0)
    private func calculateDifficultyScore(_ difficulty: DifficultyLevel, _ userProgress: LearningProgress) -> Double {
        let averageScore = userProgress.averageScore
        
        switch difficulty {
        case .beginner:
            return 1.0 // Always relevant for beginners
        case .intermediate:
            return averageScore >= 70 ? 1.0 : 0.5
        case .advanced:
            return averageScore >= 85 ? 1.0 : 0.3
        case .expert:
            return averageScore >= 95 ? 1.0 : 0.1
        }
    }
    
    /// Calculate time score based on user's time availability
    /// - Parameters:
    ///   - duration: Course duration
    ///   - patterns: User's learning patterns
    /// - Returns: Time score (0.0 to 1.0)
    private func calculateTimeScore(_ duration: TimeInterval, _ patterns: LearningPatterns) -> Double {
        let averageSessionDuration = patterns.averageSessionDuration
        
        if duration <= averageSessionDuration {
            return 1.0
        } else if duration <= averageSessionDuration * 1.5 {
            return 0.8
        } else if duration <= averageSessionDuration * 2.0 {
            return 0.6
        } else {
            return 0.3
        }
    }
    
    /// Calculate engagement score based on user's engagement history
    /// - Parameters:
    ///   - recommendation: The recommendation to score
    ///   - userProgress: User's current progress
    /// - Returns: Engagement score (0.0 to 1.0)
    private func calculateEngagementScore(_ recommendation: Recommendation, _ userProgress: LearningProgress) -> Double {
        // Simple engagement calculation based on completion rate
        let completionRate = Double(userProgress.completedLessons.count) / Double(userProgress.totalLessons)
        
        // Higher completion rate means higher engagement potential
        return min(completionRate * 1.2, 1.0)
    }
    
    /// Calculate progress alignment score
    /// - Parameters:
    ///   - recommendation: The recommendation to score
    ///   - userProgress: User's current progress
    /// - Returns: Progress alignment score (0.0 to 1.0)
    private func calculateProgressScore(_ recommendation: Recommendation, _ userProgress: LearningProgress) -> Double {
        // Check if this recommendation aligns with user's current learning path
        if let currentCourse = userProgress.currentCourse {
            // If user is in a course, prioritize related content
            return recommendation.subject == userProgress.currentSubject ? 1.0 : 0.5
        } else {
            // If no current course, prioritize based on overall progress
            return userProgress.averageScore > 80 ? 1.0 : 0.7
        }
    }
    
    /// Calculate completion rate from user progress
    /// - Parameter progress: User's learning progress
    /// - Returns: Completion rate (0.0 to 1.0)
    private func calculateCompletionRate(_ progress: LearningProgress) -> Double {
        guard progress.totalLessons > 0 else { return 0.0 }
        return Double(progress.completedLessons.count) / Double(progress.totalLessons)
    }
    
    /// Calculate engagement score from user progress
    /// - Parameter progress: User's learning progress
    /// - Returns: Engagement score (0.0 to 1.0)
    private func calculateEngagementScore(_ progress: LearningProgress) -> Double {
        // Calculate engagement based on study time and completion rate
        let completionRate = calculateCompletionRate(progress)
        let studyTimeScore = min(progress.totalStudyTime / (3600 * 10), 1.0) // Normalize to 10 hours
        
        return (completionRate + studyTimeScore) / 2.0
    }
    
    /// Analyze user's difficulty preference based on progress
    /// - Parameter progress: User's learning progress
    /// - Returns: Preferred difficulty level
    private func analyzeDifficultyPreference(_ progress: LearningProgress) -> DifficultyLevel {
        let averageScore = progress.averageScore
        
        switch averageScore {
        case 0..<60:
            return .beginner
        case 60..<75:
            return .intermediate
        case 75..<90:
            return .advanced
        default:
            return .expert
        }
    }
}

// MARK: - Supporting Types

/// Learning patterns analysis result
public struct LearningPatterns {
    let preferredTimeSlots: [TimeSlot]
    let averageSessionDuration: TimeInterval
    let preferredSubjects: [Subject]
    let learningStyle: LearningStyle
    let completionRate: Double
    let engagementScore: Double
    let difficultyPreference: DifficultyLevel
}

/// Time slot for learning sessions
public struct TimeSlot {
    let startTime: Date
    let endTime: Date
    let dayOfWeek: Int
}

/// Subject categories
public enum Subject: String, CaseIterable {
    case programming = "programming"
    case mathematics = "mathematics"
    case science = "science"
    case language = "language"
    case arts = "arts"
    case business = "business"
    case technology = "technology"
}

/// Learning style preferences
public enum LearningStyle: String, CaseIterable {
    case visual = "visual"
    case auditory = "auditory"
    case kinesthetic = "kinesthetic"
    case reading = "reading"
}

/// Difficulty levels for courses
public enum DifficultyLevel: String, CaseIterable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
    case expert = "expert"
}

/// Recommendation model
public struct Recommendation: Identifiable {
    public let id: String
    public let title: String
    public let description: String
    public let subject: Subject
    public let difficulty: DifficultyLevel
    public let duration: TimeInterval
    public let prerequisites: [String]
    public let relevanceScore: Double
    
    public init(
        id: String,
        title: String,
        description: String,
        subject: Subject,
        difficulty: DifficultyLevel,
        duration: TimeInterval,
        prerequisites: [String],
        relevanceScore: Double = 0.0
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.subject = subject
        self.difficulty = difficulty
        self.duration = duration
        self.prerequisites = prerequisites
        self.relevanceScore = relevanceScore
    }
}

/// EducationAI specific errors
public enum EducationAIError: Error, LocalizedError {
    case invalidInput(String)
    case userNotFound
    case coursesUnavailable
    case aiServiceUnavailable
    case analyticsServiceUnavailable
    
    public var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        case .userNotFound:
            return "User not found"
        case .coursesUnavailable:
            return "Courses are currently unavailable"
        case .aiServiceUnavailable:
            return "AI service is currently unavailable"
        case .analyticsServiceUnavailable:
            return "Analytics service is currently unavailable"
        }
    }
}
