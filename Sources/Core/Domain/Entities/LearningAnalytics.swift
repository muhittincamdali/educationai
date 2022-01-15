import Foundation

/// Comprehensive learning analytics for a user
public struct LearningAnalytics: Codable, Identifiable {
    
    // MARK: - Properties
    public let id: UUID
    public let userId: UUID
    public let period: AnalyticsPeriod
    public let overview: LearningOverview
    public let subjectAnalytics: [SubjectAnalytics]
    public let timeAnalytics: TimeAnalytics
    public let performanceAnalytics: PerformanceAnalytics
    public let engagementAnalytics: EngagementAnalytics
    public let skillAnalytics: SkillAnalytics
    public let recommendations: [AnalyticsRecommendation]
    public let insights: [LearningInsight]
    public let generatedAt: Date
    
    // MARK: - Initialization
    public init(
        id: UUID = UUID(),
        userId: UUID,
        period: AnalyticsPeriod,
        overview: LearningOverview,
        subjectAnalytics: [SubjectAnalytics],
        timeAnalytics: TimeAnalytics,
        performanceAnalytics: PerformanceAnalytics,
        engagementAnalytics: EngagementAnalytics,
        skillAnalytics: SkillAnalytics,
        recommendations: [AnalyticsRecommendation],
        insights: [LearningInsight],
        generatedAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.period = period
        self.overview = overview
        self.subjectAnalytics = subjectAnalytics
        self.timeAnalytics = timeAnalytics
        self.performanceAnalytics = performanceAnalytics
        self.engagementAnalytics = engagementAnalytics
        self.skillAnalytics = skillAnalytics
        self.recommendations = recommendations
        self.insights = insights
        self.generatedAt = generatedAt
    }
    
    // MARK: - Public Methods
    /// Get overall learning score
    public var overallScore: Double {
        let scores = subjectAnalytics.map { $0.averageScore }
        return scores.isEmpty ? 0.0 : scores.reduce(0, +) / Double(scores.count)
    }
    
    /// Get total learning time in hours
    public var totalLearningTime: Double {
        return timeAnalytics.totalTime / 3600.0
    }
    
    /// Get most studied subject
    public var mostStudiedSubject: SubjectAnalytics? {
        return subjectAnalytics.max { $0.totalTime < $1.totalTime }
    }
    
    /// Get best performing subject
    public var bestPerformingSubject: SubjectAnalytics? {
        return subjectAnalytics.max { $0.averageScore < $1.averageScore }
    }
    
    /// Get subjects that need attention
    public var subjectsNeedingAttention: [SubjectAnalytics] {
        return subjectAnalytics.filter { $0.averageScore < 0.7 }
    }
    
    /// Get learning streak
    public var learningStreak: Int {
        return engagementAnalytics.currentStreak
    }
    
    /// Check if user is improving
    public var isImproving: Bool {
        return performanceAnalytics.trend == .improving
    }
    
    /// Get formatted total time
    public var formattedTotalTime: String {
        let hours = Int(totalLearningTime)
        let minutes = Int((totalLearningTime - Double(hours)) * 60)
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}



public struct LearningOverview: Codable {
    public let totalSessions: Int
    public let totalLessons: Int
    public let totalTime: TimeInterval
    public let averageSessionDuration: TimeInterval
    public let completionRate: Double
    public let improvementRate: Double
    public let consistencyScore: Double
    public let engagementScore: Double
    
    public init(
        totalSessions: Int,
        totalLessons: Int,
        totalTime: TimeInterval,
        averageSessionDuration: TimeInterval,
        completionRate: Double,
        improvementRate: Double,
        consistencyScore: Double,
        engagementScore: Double
    ) {
        self.totalSessions = totalSessions
        self.totalLessons = totalLessons
        self.totalTime = totalTime
        self.averageSessionDuration = averageSessionDuration
        self.completionRate = completionRate
        self.improvementRate = improvementRate
        self.consistencyScore = consistencyScore
        self.engagementScore = engagementScore
    }
    
    /// Get completion rate percentage
    public var completionRatePercentage: Int {
        return Int(completionRate * 100)
    }
    
    /// Get improvement rate percentage
    public var improvementRatePercentage: Int {
        return Int(improvementRate * 100)
    }
    
    /// Get consistency score percentage
    public var consistencyScorePercentage: Int {
        return Int(consistencyScore * 100)
    }
    
    /// Get engagement score percentage
    public var engagementScorePercentage: Int {
        return Int(engagementScore * 100)
    }
}

public struct SubjectAnalytics: Codable, Identifiable {
    public let id: UUID
    public let subject: Subject
    public let totalTime: TimeInterval
    public let sessionsCount: Int
    public let lessonsCompleted: Int
    public let averageScore: Double
    public let bestScore: Double
    public let improvementRate: Double
    public let difficultyLevel: DifficultyLevel
    public let engagementLevel: EngagementLevel
    public let lastStudied: Date?
    
    public init(
        id: UUID = UUID(),
        subject: Subject,
        totalTime: TimeInterval,
        sessionsCount: Int,
        lessonsCompleted: Int,
        averageScore: Double,
        bestScore: Double,
        improvementRate: Double,
        difficultyLevel: DifficultyLevel,
        engagementLevel: EngagementLevel,
        lastStudied: Date? = nil
    ) {
        self.id = id
        self.subject = subject
        self.totalTime = totalTime
        self.sessionsCount = sessionsCount
        self.lessonsCompleted = lessonsCompleted
        self.averageScore = averageScore
        self.bestScore = bestScore
        self.improvementRate = improvementRate
        self.difficultyLevel = difficultyLevel
        self.engagementLevel = engagementLevel
        self.lastStudied = lastStudied
    }
    
    /// Get total time in hours
    public var totalTimeHours: Double {
        return totalTime / 3600.0
    }
    
    /// Get average score percentage
    public var averageScorePercentage: Int {
        return Int(averageScore * 100)
    }
    
    /// Get best score percentage
    public var bestScorePercentage: Int {
        return Int(bestScore * 100)
    }
    
    /// Get improvement rate percentage
    public var improvementRatePercentage: Int {
        return Int(improvementRate * 100)
    }
    
    /// Check if subject needs attention
    public var needsAttention: Bool {
        return averageScore < 0.7
    }
    
    /// Get days since last studied
    public var daysSinceLastStudied: Int? {
        guard let lastStudied = lastStudied else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: lastStudied, to: Date())
        return components.day
    }
}

public struct TimeAnalytics: Codable {
    public let totalTime: TimeInterval
    public let averageDailyTime: TimeInterval
    public let peakLearningHours: [Int]
    public let weeklyDistribution: [DayOfWeek: TimeInterval]
    public let monthlyTrend: [String: TimeInterval]
    public let sessionFrequency: SessionFrequency
    public let consistencyScore: Double
    
    public init(
        totalTime: TimeInterval,
        averageDailyTime: TimeInterval,
        peakLearningHours: [Int],
        weeklyDistribution: [DayOfWeek: TimeInterval],
        monthlyTrend: [String: TimeInterval],
        sessionFrequency: SessionFrequency,
        consistencyScore: Double
    ) {
        self.totalTime = totalTime
        self.averageDailyTime = averageDailyTime
        self.peakLearningHours = peakLearningHours
        self.weeklyDistribution = weeklyDistribution
        self.monthlyTrend = monthlyTrend
        self.sessionFrequency = sessionFrequency
        self.consistencyScore = consistencyScore
    }
    
    /// Get total time in hours
    public var totalTimeHours: Double {
        return totalTime / 3600.0
    }
    
    /// Get average daily time in minutes
    public var averageDailyTimeMinutes: Int {
        return Int(averageDailyTime / 60.0)
    }
    
    /// Get consistency score percentage
    public var consistencyScorePercentage: Int {
        return Int(consistencyScore * 100)
    }
}

public struct PerformanceAnalytics: Codable {
    public let overallScore: Double
    public let scoreTrend: PerformanceTrend
    public let improvementRate: Double
    public let accuracyRate: Double
    public let speedMetrics: SpeedMetrics
    public let retentionRate: Double
    public let applicationRate: Double
    public let assessmentResults: [AssessmentResult]
    public let trend: ProgressTrend
    
    public init(
        overallScore: Double,
        scoreTrend: PerformanceTrend,
        improvementRate: Double,
        accuracyRate: Double,
        speedMetrics: SpeedMetrics,
        retentionRate: Double,
        applicationRate: Double,
        assessmentResults: [AssessmentResult],
        trend: ProgressTrend
    ) {
        self.overallScore = overallScore
        self.scoreTrend = scoreTrend
        self.improvementRate = improvementRate
        self.accuracyRate = accuracyRate
        self.speedMetrics = speedMetrics
        self.retentionRate = retentionRate
        self.applicationRate = applicationRate
        self.assessmentResults = assessmentResults
        self.trend = trend
    }
    
    /// Get overall score percentage
    public var overallScorePercentage: Int {
        return Int(overallScore * 100)
    }
    
    /// Get improvement rate percentage
    public var improvementRatePercentage: Int {
        return Int(improvementRate * 100)
    }
    
    /// Get accuracy rate percentage
    public var accuracyRatePercentage: Int {
        return Int(accuracyRate * 100)
    }
    
    /// Get retention rate percentage
    public var retentionRatePercentage: Int {
        return Int(retentionRate * 100)
    }
    
    /// Get application rate percentage
    public var applicationRatePercentage: Int {
        return Int(applicationRate * 100)
    }
}

public enum EngagementTrend: String, Codable, CaseIterable {
    case improving = "improving"
    case stable = "stable"
    case declining = "declining"
}

public struct EngagementAnalytics: Codable {
    public let currentStreak: Int
    public let longestStreak: Int
    public let averageSessionsPerDay: Double
    public let activeDays: Int
    public let totalDays: Int
    public let engagementTrend: EngagementTrend
    public let motivationFactors: [MotivationFactor]
    public let interactionPatterns: [InteractionPattern]
    
    public init(
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        averageSessionsPerDay: Double = 0.0,
        activeDays: Int = 0,
        totalDays: Int = 0,
        engagementTrend: EngagementTrend = .stable,
        motivationFactors: [MotivationFactor] = [],
        interactionPatterns: [InteractionPattern] = []
    ) {
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.averageSessionsPerDay = averageSessionsPerDay
        self.activeDays = activeDays
        self.totalDays = totalDays
        self.engagementTrend = engagementTrend
        self.motivationFactors = motivationFactors
        self.interactionPatterns = interactionPatterns
    }
    
    public init(from date: Date) {
        self.currentStreak = 0
        self.longestStreak = 0
        self.averageSessionsPerDay = 0.0
        self.activeDays = 0
        self.totalDays = 0
        self.engagementTrend = .stable
        self.motivationFactors = []
        self.interactionPatterns = []
    }
    
    public init() {
        self.currentStreak = 0
        self.longestStreak = 0
        self.averageSessionsPerDay = 0.0
        self.activeDays = 0
        self.totalDays = 0
        self.engagementTrend = .stable
        self.motivationFactors = []
        self.interactionPatterns = []
    }
    
    /// Get engagement rate
    public var engagementRate: Double {
        guard totalDays > 0 else { return 0.0 }
        return Double(activeDays) / Double(totalDays)
    }
    
    /// Get engagement rate percentage
    public var engagementRatePercentage: Int {
        return Int(engagementRate * 100)
    }
    
    /// Check if user is on fire (high engagement)
    public var isOnFire: Bool {
        return currentStreak >= 7
    }
}

public struct SkillAnalytics: Codable {
    public let skillsAcquired: [Skill]
    public let skillLevels: [SkillLevel]
    public let skillGaps: [SkillGap]
    public let skillProgression: [SkillProgression]
    public let crossSubjectSkills: [CrossSubjectSkill]
    
    public init(
        skillsAcquired: [Skill],
        skillLevels: [SkillLevel],
        skillGaps: [SkillGap],
        skillProgression: [SkillProgression],
        crossSubjectSkills: [CrossSubjectSkill]
    ) {
        self.skillsAcquired = skillsAcquired
        self.skillLevels = skillLevels
        self.skillGaps = skillGaps
        self.skillProgression = skillProgression
        self.crossSubjectSkills = crossSubjectSkills
    }
    
    /// Get total skills count
    public var totalSkillsCount: Int {
        return skillsAcquired.count
    }
    
    /// Get skills that need improvement
    public var skillsNeedingImprovement: [Skill] {
        return skillsAcquired.filter { skill in
            skill.currentLevel == .beginner || skill.currentLevel == .intermediate
        }
    }
    
    /// Get advanced skills
    public var advancedSkills: [Skill] {
        return skillsAcquired.filter { skill in
            skill.currentLevel == .advanced || skill.currentLevel == .expert
        }
    }
}

public struct AnalyticsRecommendation: Codable, Identifiable {
    public let id: UUID
    public let type: RecommendationType
    public let title: String
    public let description: String
    public let priority: Priority
    public let impact: ImpactLevel
    public let effort: EffortLevel
    public let deadline: Date?
    public let relatedData: [String: String]
    
    public init(
        id: UUID = UUID(),
        type: RecommendationType,
        title: String,
        description: String,
        priority: Priority,
        impact: ImpactLevel,
        effort: EffortLevel,
        deadline: Date? = nil,
        relatedData: [String: String] = [:]
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.description = description
        self.priority = priority
        self.impact = impact
        self.effort = effort
        self.deadline = deadline
        self.relatedData = relatedData
    }
}

public struct LearningInsight: Codable, Identifiable {
    public let id: UUID
    public let title: String
    public let description: String
    public let type: InsightType
    public let confidence: Double
    public let actionable: Bool
    public let relatedMetrics: [String]
    public let generatedAt: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        type: InsightType,
        confidence: Double,
        actionable: Bool,
        relatedMetrics: [String],
        generatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.confidence = confidence
        self.actionable = actionable
        self.relatedMetrics = relatedMetrics
        self.generatedAt = generatedAt
    }
    
    /// Get confidence percentage
    public var confidencePercentage: Int {
        return Int(confidence * 100)
    }
}

// MARK: - Additional Supporting Types



public enum EngagementLevel: String, Codable, CaseIterable {
    case low = "low"
    case moderate = "moderate"
    case high = "high"
    case excellent = "excellent"
}

// These enums are already defined in other files

public enum InsightType: String, Codable, CaseIterable {
    case performance = "performance"
    case engagement = "engagement"
    case time = "time"
    case skill = "skill"
    case pattern = "pattern"
    case recommendation = "recommendation"
}


public enum DayOfWeek: String, Codable, CaseIterable {
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thursday = "thursday"
    case friday = "friday"
    case saturday = "saturday"
    case sunday = "sunday"
}

public enum SessionFrequency: String, Codable, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
}

public struct SpeedMetrics: Codable {
    public let averageResponseTime: TimeInterval
    public let completionSpeed: Double
    public let timeEfficiency: Double
    
    public init(
        averageResponseTime: TimeInterval = 0.0,
        completionSpeed: Double = 0.0,
        timeEfficiency: Double = 0.0
    ) {
        self.averageResponseTime = averageResponseTime
        self.completionSpeed = completionSpeed
        self.timeEfficiency = timeEfficiency
    }
}

public struct AssessmentResult: Codable, Identifiable {
    public let id: UUID
    public let type: String
    public let score: Double
    public let maxScore: Double
    public let completedAt: Date
}


// This struct conflicts with the enum defined in UserProfile.swift





public struct MotivationFactor: Codable, Identifiable {
    public let id: UUID
    public let factor: String
    public let impact: Double
    public let frequency: Int
}

public struct InteractionPattern: Codable, Identifiable {
    public let id: UUID
    public let pattern: String
    public let frequency: Int
    public let effectiveness: Double
}
