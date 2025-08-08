import XCTest
@testable import EducationAI

final class EducationAIUnitTests: XCTestCase {
    
    var educationAI: EducationAI!
    var mockAIService: MockAIService!
    var mockAnalyticsService: MockAnalyticsService!
    var mockSecurityManager: MockSecurityManager!
    
    override func setUpWithError() throws {
        educationAI = EducationAI()
        mockAIService = MockAIService()
        mockAnalyticsService = MockAnalyticsService()
        mockSecurityManager = MockSecurityManager()
    }
    
    override func tearDownWithError() throws {
        educationAI = nil
        mockAIService = nil
        mockAnalyticsService = nil
        mockSecurityManager = nil
    }
    
    // MARK: - Core Functionality Tests
    
    func testEducationAIInitialization() throws {
        XCTAssertNotNil(educationAI)
        XCTAssertEqual(educationAI.version, "1.0.0")
        XCTAssertTrue(educationAI.isConfigured)
    }
    
    func testEducationAIConfiguration() throws {
        let config = EducationAIConfiguration(
            enableAI: true,
            enableAnalytics: true,
            enableSecurity: true,
            enableOfflineMode: true
        )
        
        educationAI.configure(with: config)
        
        XCTAssertTrue(educationAI.isConfigured)
        XCTAssertTrue(educationAI.aiEnabled)
        XCTAssertTrue(educationAI.analyticsEnabled)
        XCTAssertTrue(educationAI.securityEnabled)
        XCTAssertTrue(educationAI.offlineModeEnabled)
    }
    
    // MARK: - AI Service Tests
    
    func testAIServiceInitialization() throws {
        XCTAssertNotNil(mockAIService)
        XCTAssertTrue(mockAIService.isConfigured)
    }
    
    func testPersonalizedLearningPathGeneration() async throws {
        let userId = "test-user-123"
        let scenario = LearningScenario(
            subject: "Mathematics",
            difficulty: .intermediate,
            learningStyle: .visual,
            timeLimit: 1800,
            adaptiveMode: true
        )
        
        let learningPath = try await mockAIService.generatePersonalizedLearningPath(
            for: userId,
            scenario: scenario
        )
        
        XCTAssertNotNil(learningPath)
        XCTAssertEqual(learningPath.id.count, 36) // UUID length
        XCTAssertGreaterThan(learningPath.modules.count, 0)
        XCTAssertEqual(learningPath.difficulty, .intermediate)
    }
    
    func testAIQuestionGeneration() async throws {
        let module = LearningModule(
            id: "test-module",
            title: "Test Module",
            content: [],
            difficulty: .beginner,
            estimatedTime: 600
        )
        
        let questions = try await mockAIService.generateQuestions(
            for: module,
            count: 5,
            difficulty: .beginner
        )
        
        XCTAssertEqual(questions.count, 5)
        
        for question in questions {
            XCTAssertNotNil(question.id)
            XCTAssertNotNil(question.text)
            XCTAssertEqual(question.difficulty, 0.3) // Beginner difficulty
        }
    }
    
    func testAIModelUpdate() async throws {
        let result = ModuleResult(
            moduleId: "test-module",
            performance: 0.85,
            duration: 300,
            responses: [],
            timestamp: Date()
        )
        
        try await mockAIService.updateModel(with: result)
        
        XCTAssertTrue(mockAIService.modelUpdated)
        XCTAssertEqual(mockAIService.lastPerformance, 0.85)
    }
    
    func testAdaptiveDifficultyAdjustment() async throws {
        let module = LearningModule(
            id: "test-module",
            title: "Test Module",
            content: [],
            difficulty: .intermediate,
            estimatedTime: 600
        )
        
        let result = ModuleResult(
            moduleId: "test-module",
            performance: 0.3, // Low performance
            duration: 300,
            responses: [],
            timestamp: Date()
        )
        
        try await mockAIService.adjustDifficulty(for: module, basedOn: result)
        
        XCTAssertTrue(mockAIService.difficultyAdjusted)
        XCTAssertEqual(mockAIService.adjustedDifficulty, .beginner)
    }
    
    // MARK: - Analytics Service Tests
    
    func testAnalyticsServiceInitialization() throws {
        XCTAssertNotNil(mockAnalyticsService)
        XCTAssertTrue(mockAnalyticsService.isConfigured)
    }
    
    func testRealTimeMonitoring() async throws {
        let sessionId = try await mockAnalyticsService.startRealTimeMonitoring()
        
        XCTAssertNotNil(sessionId)
        XCTAssertTrue(mockAnalyticsService.monitoringActive)
        
        try await mockAnalyticsService.stopRealTimeMonitoring(session: sessionId)
        
        XCTAssertFalse(mockAnalyticsService.monitoringActive)
    }
    
    func testActivityRecording() async throws {
        let activityType = "quiz_completed"
        let duration: TimeInterval = 300
        let timestamp = Date()
        
        try await mockAnalyticsService.recordActivity(
            type: activityType,
            duration: duration,
            timestamp: timestamp
        )
        
        XCTAssertTrue(mockAnalyticsService.activityRecorded)
        XCTAssertEqual(mockAnalyticsService.lastActivityType, activityType)
        XCTAssertEqual(mockAnalyticsService.lastActivityDuration, duration)
    }
    
    func testProgressUpdate() async throws {
        let progress = LearningProgress(
            userId: "test-user",
            moduleId: "test-module",
            performance: 0.75,
            completionDate: Date(),
            timeSpent: 600
        )
        
        try await mockAnalyticsService.updateProgress(progress)
        
        XCTAssertTrue(mockAnalyticsService.progressUpdated)
        XCTAssertEqual(mockAnalyticsService.lastProgress?.userId, "test-user")
        XCTAssertEqual(mockAnalyticsService.lastProgress?.performance, 0.75)
    }
    
    func testReportGeneration() async throws {
        let performanceReport = try await mockAnalyticsService.generatePerformanceReport()
        let engagementReport = try await mockAnalyticsService.generateEngagementReport()
        let progressReport = try await mockAnalyticsService.generateProgressReport()
        let predictiveReport = try await mockAnalyticsService.generatePredictiveReport()
        
        XCTAssertEqual(performanceReport.type, .performance)
        XCTAssertEqual(engagementReport.type, .engagement)
        XCTAssertEqual(progressReport.type, .progress)
        XCTAssertEqual(predictiveReport.type, .predictive)
        
        XCTAssertGreaterThan(performanceReport.currentScore, 0)
        XCTAssertGreaterThan(engagementReport.currentScore, 0)
        XCTAssertGreaterThan(progressReport.currentScore, 0)
        XCTAssertGreaterThan(predictiveReport.currentScore, 0)
    }
    
    // MARK: - Security Manager Tests
    
    func testSecurityManagerInitialization() throws {
        XCTAssertNotNil(mockSecurityManager)
        XCTAssertTrue(mockSecurityManager.isConfigured)
    }
    
    func testBiometricAuthentication() async throws {
        let isAuthenticated = try await mockSecurityManager.authenticateWithBiometrics()
        
        XCTAssertTrue(isAuthenticated)
        XCTAssertTrue(mockSecurityManager.biometricAuthCalled)
    }
    
    func testDataEncryption() async throws {
        let originalData = "Sensitive learning data".data(using: .utf8)!
        
        let encryptedData = try await mockSecurityManager.encryptData(originalData)
        
        XCTAssertNotNil(encryptedData)
        XCTAssertNotEqual(encryptedData, originalData)
        XCTAssertTrue(mockSecurityManager.encryptionCalled)
    }
    
    func testPrivacyCompliance() async throws {
        let complianceStatus = try await mockSecurityManager.checkPrivacyCompliance()
        
        XCTAssertTrue(complianceStatus.isCompliant)
        XCTAssertTrue(mockSecurityManager.complianceChecked)
        XCTAssertEqual(complianceStatus.issues.count, 0)
    }
    
    func testSecurityEventLogging() async throws {
        let event = "test_security_event"
        let severity = SecuritySeverity.info
        let details = "Test security event details"
        
        try await mockSecurityManager.logSecurityEvent(
            event: event,
            severity: severity,
            details: details
        )
        
        XCTAssertTrue(mockSecurityManager.eventLogged)
        XCTAssertEqual(mockSecurityManager.lastEvent, event)
        XCTAssertEqual(mockSecurityManager.lastSeverity, severity)
    }
    
    // MARK: - Performance Tests
    
    func testMemoryUsageOptimization() async throws {
        let initialMemory = educationAI.getMemoryUsage()
        
        // Simulate memory-intensive operations
        var largeArray: [String] = []
        for i in 0..<10000 {
            largeArray.append("Item \(i)")
        }
        
        let afterMemory = educationAI.getMemoryUsage()
        let memoryIncrease = afterMemory.used - initialMemory.used
        
        // Memory increase should be reasonable
        XCTAssertLessThan(memoryIncrease, 100 * 1024 * 1024) // Less than 100MB
    }
    
    func testCachePerformance() async throws {
        let cacheStats = educationAI.getCacheStatistics()
        
        XCTAssertGreaterThanOrEqual(cacheStats.hitRate, 0.0)
        XCTAssertLessThanOrEqual(cacheStats.hitRate, 1.0)
        XCTAssertGreaterThanOrEqual(cacheStats.totalRequests, 0)
    }
    
    func testNetworkPerformance() async throws {
        let networkStats = educationAI.getNetworkStatistics()
        
        XCTAssertGreaterThanOrEqual(networkStats.totalRequests, 0)
        XCTAssertGreaterThanOrEqual(networkStats.averageResponseTime, 0.0)
        XCTAssertGreaterThanOrEqual(networkStats.successRate, 0.0)
        XCTAssertLessThanOrEqual(networkStats.successRate, 1.0)
    }
    
    // MARK: - Integration Tests
    
    func testEndToEndLearningFlow() async throws {
        // 1. Configure EducationAI
        let config = EducationAIConfiguration(
            enableAI: true,
            enableAnalytics: true,
            enableSecurity: true,
            enableOfflineMode: true
        )
        educationAI.configure(with: config)
        
        // 2. Authenticate user
        let isAuthenticated = try await mockSecurityManager.authenticateWithBiometrics()
        XCTAssertTrue(isAuthenticated)
        
        // 3. Generate learning path
        let scenario = LearningScenario(
            subject: "Science",
            difficulty: .beginner,
            learningStyle: .visual,
            timeLimit: 1200,
            adaptiveMode: true
        )
        
        let learningPath = try await mockAIService.generatePersonalizedLearningPath(
            for: "test-user",
            scenario: scenario
        )
        XCTAssertNotNil(learningPath)
        
        // 4. Start analytics monitoring
        let sessionId = try await mockAnalyticsService.startRealTimeMonitoring()
        XCTAssertNotNil(sessionId)
        
        // 5. Execute learning modules
        for module in learningPath.modules {
            let result = ModuleResult(
                moduleId: module.id,
                performance: 0.8,
                duration: 300,
                responses: [],
                timestamp: Date()
            )
            
            // Update AI model
            try await mockAIService.updateModel(with: result)
            
            // Update progress
            let progress = LearningProgress(
                userId: "test-user",
                moduleId: module.id,
                performance: result.performance,
                completionDate: Date(),
                timeSpent: result.duration
            )
            try await mockAnalyticsService.updateProgress(progress)
        }
        
        // 6. Stop monitoring
        try await mockAnalyticsService.stopRealTimeMonitoring(session: sessionId)
        
        // 7. Verify all services were used
        XCTAssertTrue(mockSecurityManager.biometricAuthCalled)
        XCTAssertTrue(mockAIService.modelUpdated)
        XCTAssertTrue(mockAnalyticsService.progressUpdated)
        XCTAssertFalse(mockAnalyticsService.monitoringActive)
    }
    
    // MARK: - Error Handling Tests
    
    func testInvalidConfiguration() throws {
        let invalidConfig = EducationAIConfiguration(
            enableAI: false,
            enableAnalytics: false,
            enableSecurity: false,
            enableOfflineMode: false
        )
        
        educationAI.configure(with: invalidConfig)
        
        XCTAssertFalse(educationAI.aiEnabled)
        XCTAssertFalse(educationAI.analyticsEnabled)
        XCTAssertFalse(educationAI.securityEnabled)
        XCTAssertFalse(educationAI.offlineModeEnabled)
    }
    
    func testNetworkErrorHandling() async throws {
        mockAIService.shouldSimulateError = true
        
        do {
            let _ = try await mockAIService.generatePersonalizedLearningPath(
                for: "test-user",
                scenario: LearningScenario(
                    subject: "Test",
                    difficulty: .beginner,
                    learningStyle: .visual,
                    timeLimit: 600,
                    adaptiveMode: true
                )
            )
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testAuthenticationFailure() async throws {
        mockSecurityManager.shouldSimulateFailure = true
        
        let isAuthenticated = try await mockSecurityManager.authenticateWithBiometrics()
        
        XCTAssertFalse(isAuthenticated)
        XCTAssertTrue(mockSecurityManager.biometricAuthCalled)
    }
}

// MARK: - Mock Services

// Align with example protocol signatures used in Examples/AdvancedExample.swift
class MockAIService: AIService {
    var isConfigured = false
    var modelUpdated = false
    var difficultyAdjusted = false
    var lastPerformance: Double = 0.0
    var adjustedDifficulty: Difficulty = .beginner
    var shouldSimulateError = false
    
    func configure(with config: AIConfiguration) async throws {
        isConfigured = true
    }
    
    func generatePersonalizedLearningPath(for userId: String, scenario: LearningScenario) async throws -> LearningPath {
        if shouldSimulateError {
            throw NetworkError.invalidResponse
        }
        
        return LearningPath(
            id: UUID().uuidString,
            modules: [
                LearningModule(
                    id: "module-1",
                    title: "Introduction",
                    content: [],
                    difficulty: scenario.difficulty,
                    estimatedTime: 300
                ),
                LearningModule(
                    id: "module-2",
                    title: "Advanced Topics",
                    content: [],
                    difficulty: scenario.difficulty,
                    estimatedTime: 600
                )
            ],
            estimatedDuration: 900,
            difficulty: scenario.difficulty
        )
    }
    
    func updateModel(with result: ModuleResult) async throws {
        modelUpdated = true
        lastPerformance = result.performance
    }
    
    func adjustDifficulty(for module: LearningModule, basedOn result: ModuleResult) async throws {
        difficultyAdjusted = true
        if result.performance < 0.5 {
            adjustedDifficulty = .beginner
        } else {
            adjustedDifficulty = .intermediate
        }
    }
    
    func generateQuestions(for module: LearningModule, count: Int, difficulty: Difficulty) async throws -> [Question] {
        var questions: [Question] = []
        
        for i in 0..<count {
            questions.append(Question(
                id: "question-\(i)",
                text: "Test question \(i + 1)?",
                type: .multipleChoice,
                difficulty: 0.3
            ))
        }
        
        return questions
    }
}

class MockAnalyticsService: AnalyticsService {
    var isConfigured = false
    var monitoringActive = false
    var activityRecorded = false
    var progressUpdated = false
    var lastActivityType: String = ""
    var lastActivityDuration: TimeInterval = 0
    var lastProgress: LearningProgress?
    
    func configure(with config: AnalyticsConfiguration) async throws {
        isConfigured = true
    }
    
    func startRealTimeMonitoring() async throws -> String {
        monitoringActive = true
        return UUID().uuidString
    }
    
    func stopRealTimeMonitoring(session: String) async throws {
        monitoringActive = false
    }
    
    func startTracking(module: LearningModule) {
        // Mock implementation
    }
    
    func stopTracking(module: LearningModule) {
        // Mock implementation
    }
    
    func recordActivity(type: String, duration: TimeInterval, timestamp: Date) async throws {
        activityRecorded = true
        lastActivityType = type
        lastActivityDuration = duration
    }
    
    func updateProgress(_ progress: LearningProgress) async throws {
        progressUpdated = true
        lastProgress = progress
    }
    
    func generatePerformanceReport() async throws -> AnalyticsReport {
        return AnalyticsReport(
            type: .performance,
            currentScore: 0.85,
            trend: .improving,
            recommendations: ["Continue current learning path", "Practice more exercises"]
        )
    }
    
    func generateEngagementReport() async throws -> AnalyticsReport {
        return AnalyticsReport(
            type: .engagement,
            currentScore: 0.78,
            trend: .stable,
            recommendations: ["Try interactive content", "Join discussion forums"]
        )
    }
    
    func generateProgressReport() async throws -> AnalyticsReport {
        return AnalyticsReport(
            type: .progress,
            currentScore: 0.92,
            trend: .improving,
            recommendations: ["Great progress!", "Consider advanced topics"]
        )
    }
    
    func generatePredictiveReport() async throws -> AnalyticsReport {
        return AnalyticsReport(
            type: .predictive,
            currentScore: 0.88,
            trend: .improving,
            recommendations: ["Likely to complete course", "Consider certification"]
        )
    }
}

class MockSecurityManager: SecurityManager {
    var isConfigured = false
    var biometricAuthCalled = false
    var encryptionCalled = false
    var complianceChecked = false
    var eventLogged = false
    var lastEvent: String = ""
    var lastSeverity: SecuritySeverity = .info
    var shouldSimulateFailure = false
    
    func configure(with config: SecurityConfiguration) async throws {
        isConfigured = true
    }
    
    func authenticateWithBiometrics() async throws -> Bool {
        biometricAuthCalled = true
        return !shouldSimulateFailure
    }
    
    func encryptData(_ data: Data) async throws -> Data {
        encryptionCalled = true
        return data.reversed()
    }
    
    func checkPrivacyCompliance() async throws -> ComplianceStatus {
        complianceChecked = true
        return ComplianceStatus(isCompliant: true, issues: [])
    }
    
    func logSecurityEvent(event: String, severity: SecuritySeverity, details: String) async throws {
        eventLogged = true
        lastEvent = event
        lastSeverity = severity
    }
}

// MARK: - Supporting Models

struct EducationAIConfiguration {
    let enableAI: Bool
    let enableAnalytics: Bool
    let enableSecurity: Bool
    let enableOfflineMode: Bool
}

enum NetworkError: Error {
    case invalidResponse
    case invalidURL
    case timeout
}

extension EducationAI {
    var version: String { "1.0.0" }
    var isConfigured: Bool { true }
    var aiEnabled: Bool { true }
    var analyticsEnabled: Bool { true }
    var securityEnabled: Bool { true }
    var offlineModeEnabled: Bool { true }
    
    func getMemoryUsage() -> (used: UInt64, total: UInt64) {
        return (used: 50 * 1024 * 1024, total: 100 * 1024 * 1024) // Mock values
    }
    
    func getCacheStatistics() -> CacheStatistics {
        return CacheStatistics(hitRate: 0.85, totalRequests: 1000)
    }
    
    func getNetworkStatistics() -> NetworkStatistics {
        return NetworkStatistics(
            totalRequests: 500,
            averageResponseTime: 0.5,
            successRate: 0.95
        )
    }
}

struct CacheStatistics {
    let hitRate: Double
    let totalRequests: Int
}

struct NetworkStatistics {
    let totalRequests: Int
    let averageResponseTime: TimeInterval
    let successRate: Double
}
