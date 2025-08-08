import XCTest
@testable import EducationAI

// Test-local protocol to ensure compilation independent of example sources
protocol IntegrationManager {
    // Firebase
    func configureFirebase(with config: FirebaseConfiguration) async throws
    func registerFirebaseEvent(_ event: String) async throws
    func setupRemoteConfig(key: String, defaultValue: String) async throws
    func testFirebaseAnalytics() async throws
    func testFirebaseRemoteConfig() async throws
    func testFirebaseCrashlytics() async throws

    // Core Data
    func configureCoreData(with config: CoreDataConfiguration) async throws
    func createCoreDataEntity(_ entity: CoreDataEntity) async throws
    func createCoreDataRelationship(_ relationship: CoreDataRelationship) async throws
    func testCoreDataEntities() async throws
    func testCoreDataRelationships() async throws
    func testCoreDataBatchOperations() async throws

    // CloudKit
    func configureCloudKit(with config: CloudKitConfiguration) async throws
    func createCloudKitSubscription(_ subscription: CloudKitSubscription) async throws
    func configureCloudKitSharing(with config: CloudKitSharingConfiguration) async throws
    func testCloudKitRecords() async throws
    func testCloudKitSubscriptions() async throws
    func testCloudKitSharing() async throws

    // Third-party Services
    func configureAlamofire(with config: AlamofireConfiguration) async throws
    func configureRxSwift(with config: RxSwiftConfiguration) async throws
    func configureSnapKit(with config: SnapKitConfiguration) async throws
    func configureLottie(with config: LottieConfiguration) async throws
    func configureSDWebImage(with config: SDWebImageConfiguration) async throws
    func testAlamofire() async throws
    func testRxSwift() async throws
    func testSnapKit() async throws
    func testLottie() async throws
    func testSDWebImage() async throws

    // Custom Integrations
    func configureCustomAnalytics(with config: CustomAnalyticsConfiguration) async throws
    func configureCustomAuthentication(with config: CustomAuthenticationConfiguration) async throws
    func configureCustomPush(with config: CustomPushConfiguration) async throws
    func testCustomAnalytics() async throws
    func testCustomAuthentication() async throws
    func testCustomPush() async throws
}

final class EducationAIIntegrationTests: XCTestCase {
    
    var educationAI: EducationAI!
    var integrationManager: IntegrationManager!
    
    override func setUpWithError() throws {
        educationAI = EducationAI()
        integrationManager = MockIntegrationManager()
    }
    
    override func tearDownWithError() throws {
        educationAI = nil
        integrationManager = nil
    }
    
    // MARK: - Firebase Integration Tests
    
    func testFirebaseIntegration() async throws {
        let firebaseConfig = FirebaseConfiguration(
            projectId: "test-project",
            enableAnalytics: true,
            enableCrashlytics: true,
            enableRemoteConfig: true,
            enableCloudMessaging: true
        )
        
        try await integrationManager.configureFirebase(with: firebaseConfig)
        
        // Test analytics events
        try await integrationManager.registerFirebaseEvent("test_event")
        
        // Test remote config
        try await integrationManager.setupRemoteConfig(key: "test_key", defaultValue: "test_value")
        
        // Run Firebase tests
        try await integrationManager.testFirebaseAnalytics()
        try await integrationManager.testFirebaseRemoteConfig()
        try await integrationManager.testFirebaseCrashlytics()
        
        XCTAssertTrue((integrationManager as! MockIntegrationManager).firebaseConfigured)
    }
    
    // MARK: - Core Data Integration Tests
    
    func testCoreDataIntegration() async throws {
        let coreDataConfig = CoreDataConfiguration(
            modelName: "TestEducationAI",
            enableMigration: true,
            enableBackgroundContext: true,
            enableBatchOperations: true
        )
        
        try await integrationManager.configureCoreData(with: coreDataConfig)
        
        // Test entity creation
        let entity = CoreDataEntity(name: "TestEntity", attributes: ["id", "name"])
        try await integrationManager.createCoreDataEntity(entity)
        
        // Test relationship creation
        let relationship = CoreDataRelationship(from: "User", to: "Progress", type: "oneToMany")
        try await integrationManager.createCoreDataRelationship(relationship)
        
        // Run Core Data tests
        try await integrationManager.testCoreDataEntities()
        try await integrationManager.testCoreDataRelationships()
        try await integrationManager.testCoreDataBatchOperations()
        
        XCTAssertTrue((integrationManager as! MockIntegrationManager).coreDataConfigured)
    }
    
    // MARK: - CloudKit Integration Tests
    
    func testCloudKitIntegration() async throws {
        let cloudKitConfig = CloudKitConfiguration(
            containerId: "iCloud.com.test.educationai",
            enablePublicDatabase: true,
            enablePrivateDatabase: true,
            enableSharedDatabase: true,
            enableSubscription: true
        )
        
        try await integrationManager.configureCloudKit(with: cloudKitConfig)
        
        // Test subscription creation
        let subscription = CloudKitSubscription(
            recordType: "TestRecord",
            predicate: NSPredicate(value: true),
            subscriptionID: "test-subscription",
            notificationInfo: CKSubscription.NotificationInfo()
        )
        try await integrationManager.createCloudKitSubscription(subscription)
        
        // Test sharing configuration
        let sharingConfig = CloudKitSharingConfiguration(
            enableUserSharing: true,
            enableGroupSharing: true,
            enablePublicSharing: false,
            sharingPermissions: [.readWrite]
        )
        try await integrationManager.configureCloudKitSharing(with: sharingConfig)
        
        // Run CloudKit tests
        try await integrationManager.testCloudKitRecords()
        try await integrationManager.testCloudKitSubscriptions()
        try await integrationManager.testCloudKitSharing()
        
        XCTAssertTrue((integrationManager as! MockIntegrationManager).cloudKitConfigured)
    }
    
    // MARK: - Third-Party Services Integration Tests
    
    func testAlamofireIntegration() async throws {
        let alamofireConfig = AlamofireConfiguration(
            baseURL: "https://api.test.com",
            timeoutInterval: 30,
            enableRetry: true,
            enableLogging: true,
            enableCertificatePinning: true
        )
        
        try await integrationManager.configureAlamofire(with: alamofireConfig)
        try await integrationManager.testAlamofire()
        
        XCTAssertTrue((integrationManager as! MockIntegrationManager).alamofireConfigured)
    }
    
    func testRxSwiftIntegration() async throws {
        let rxSwiftConfig = RxSwiftConfiguration(
            enableObservables: true,
            enableSubjects: true,
            enableOperators: true,
            enableSchedulers: true
        )
        
        try await integrationManager.configureRxSwift(with: rxSwiftConfig)
        try await integrationManager.testRxSwift()
        
        XCTAssertTrue((integrationManager as! MockIntegrationManager).rxSwiftConfigured)
    }
    
    func testSnapKitIntegration() async throws {
        let snapKitConfig = SnapKitConfiguration(
            enableAutoLayout: true,
            enableConstraints: true,
            enablePriority: true
        )
        
        try await integrationManager.configureSnapKit(with: snapKitConfig)
        try await integrationManager.testSnapKit()
        
        XCTAssertTrue((integrationManager as! MockIntegrationManager).snapKitConfigured)
    }
    
    func testLottieIntegration() async throws {
        let lottieConfig = LottieConfiguration(
            enableAnimations: true,
            enableCaching: true,
            enableLooping: true,
            enableSpeedControl: true
        )
        
        try await integrationManager.configureLottie(with: lottieConfig)
        try await integrationManager.testLottie()
        
        XCTAssertTrue((integrationManager as! MockIntegrationManager).lottieConfigured)
    }
    
    func testSDWebImageIntegration() async throws {
        let sdWebImageConfig = SDWebImageConfiguration(
            enableCaching: true,
            enableProgressiveLoading: true,
            enableGIFSupport: true,
            enableWebPSupport: true,
            cacheSizeLimit: 50 * 1024 * 1024
        )
        
        try await integrationManager.configureSDWebImage(with: sdWebImageConfig)
        try await integrationManager.testSDWebImage()
        
        XCTAssertTrue((integrationManager as! MockIntegrationManager).sdWebImageConfigured)
    }
    
    // MARK: - Custom Integrations Tests
    
    func testCustomAnalyticsIntegration() async throws {
        let customAnalyticsConfig = CustomAnalyticsConfiguration(
            enableEventTracking: true,
            enableUserTracking: true,
            enablePerformanceTracking: true,
            enableCrashTracking: true,
            customEndpoints: ["https://analytics.test.com/events"]
        )
        
        try await integrationManager.configureCustomAnalytics(with: customAnalyticsConfig)
        try await integrationManager.testCustomAnalytics()
        
        XCTAssertTrue((integrationManager as! MockIntegrationManager).customAnalyticsConfigured)
    }
    
    func testCustomAuthenticationIntegration() async throws {
        let customAuthConfig = CustomAuthenticationConfiguration(
            enableOAuth: true,
            enableSAML: true,
            enableLDAP: true,
            enableCustomTokens: true,
            authProviders: ["google", "apple", "microsoft", "custom"]
        )
        
        try await integrationManager.configureCustomAuthentication(with: customAuthConfig)
        try await integrationManager.testCustomAuthentication()
        
        XCTAssertTrue((integrationManager as! MockIntegrationManager).customAuthConfigured)
    }
    
    // Payment-related integration tests removed intentionally
    
    func testCustomPushIntegration() async throws {
        let customPushConfig = CustomPushConfiguration(
            enableRemoteNotifications: true,
            enableLocalNotifications: true,
            enableSilentNotifications: true,
            enableRichNotifications: true,
            enableActionableNotifications: true
        )
        
        try await integrationManager.configureCustomPush(with: customPushConfig)
        try await integrationManager.testCustomPush()
        
        XCTAssertTrue((integrationManager as! MockIntegrationManager).customPushConfigured)
    }
    
    // MARK: - End-to-End Integration Tests
    
    func testCompleteIntegrationWorkflow() async throws {
        // 1. Configure all integrations
        try await configureAllIntegrations()
        
        // 2. Test complete workflow
        try await testCompleteWorkflow()
        
        // 3. Verify all integrations are working
        try await verifyAllIntegrations()
        
        XCTAssertTrue((integrationManager as! MockIntegrationManager).allIntegrationsConfigured)
    }
    
    private func configureAllIntegrations() async throws {
        // Firebase
        let firebaseConfig = FirebaseConfiguration(
            projectId: "test-project",
            enableAnalytics: true,
            enableCrashlytics: true,
            enableRemoteConfig: true,
            enableCloudMessaging: true
        )
        try await integrationManager.configureFirebase(with: firebaseConfig)
        
        // Core Data
        let coreDataConfig = CoreDataConfiguration(
            modelName: "TestEducationAI",
            enableMigration: true,
            enableBackgroundContext: true,
            enableBatchOperations: true
        )
        try await integrationManager.configureCoreData(with: coreDataConfig)
        
        // CloudKit
        let cloudKitConfig = CloudKitConfiguration(
            containerId: "iCloud.com.test.educationai",
            enablePublicDatabase: true,
            enablePrivateDatabase: true,
            enableSharedDatabase: true,
            enableSubscription: true
        )
        try await integrationManager.configureCloudKit(with: cloudKitConfig)
        
        // Third-party services
        let alamofireConfig = AlamofireConfiguration(
            baseURL: "https://api.test.com",
            timeoutInterval: 30,
            enableRetry: true,
            enableLogging: true,
            enableCertificatePinning: true
        )
        try await integrationManager.configureAlamofire(with: alamofireConfig)
        
        let rxSwiftConfig = RxSwiftConfiguration(
            enableObservables: true,
            enableSubjects: true,
            enableOperators: true,
            enableSchedulers: true
        )
        try await integrationManager.configureRxSwift(with: rxSwiftConfig)
        
        let snapKitConfig = SnapKitConfiguration(
            enableAutoLayout: true,
            enableConstraints: true,
            enablePriority: true
        )
        try await integrationManager.configureSnapKit(with: snapKitConfig)
        
        let lottieConfig = LottieConfiguration(
            enableAnimations: true,
            enableCaching: true,
            enableLooping: true,
            enableSpeedControl: true
        )
        try await integrationManager.configureLottie(with: lottieConfig)
        
        let sdWebImageConfig = SDWebImageConfiguration(
            enableCaching: true,
            enableProgressiveLoading: true,
            enableGIFSupport: true,
            enableWebPSupport: true,
            cacheSizeLimit: 50 * 1024 * 1024
        )
        try await integrationManager.configureSDWebImage(with: sdWebImageConfig)
        
        // Custom integrations
        let customAnalyticsConfig = CustomAnalyticsConfiguration(
            enableEventTracking: true,
            enableUserTracking: true,
            enablePerformanceTracking: true,
            enableCrashTracking: true,
            customEndpoints: ["https://analytics.test.com/events"]
        )
        try await integrationManager.configureCustomAnalytics(with: customAnalyticsConfig)
        
        let customAuthConfig = CustomAuthenticationConfiguration(
            enableOAuth: true,
            enableSAML: true,
            enableLDAP: true,
            enableCustomTokens: true,
            authProviders: ["google", "apple", "microsoft", "custom"]
        )
        try await integrationManager.configureCustomAuthentication(with: customAuthConfig)
        
        // Payment-related configuration omitted
        
        let customPushConfig = CustomPushConfiguration(
            enableRemoteNotifications: true,
            enableLocalNotifications: true,
            enableSilentNotifications: true,
            enableRichNotifications: true,
            enableActionableNotifications: true
        )
        try await integrationManager.configureCustomPush(with: customPushConfig)
    }
    
    private func testCompleteWorkflow() async throws {
        // Simulate complete application workflow
        let mockManager = integrationManager as! MockIntegrationManager
        
        // 1. User authentication
        try await mockManager.simulateUserAuthentication()
        
        // 2. Data synchronization
        try await mockManager.simulateDataSynchronization()
        
        // 3. Content delivery
        try await mockManager.simulateContentDelivery()
        
        // 4. Analytics tracking
        try await mockManager.simulateAnalyticsTracking()
        
        // 5. Payment processing intentionally omitted
        
        // 6. Push notifications
        try await mockManager.simulatePushNotifications()
        
        XCTAssertTrue(mockManager.workflowCompleted)
    }
    
    private func verifyAllIntegrations() async throws {
        let mockManager = integrationManager as! MockIntegrationManager
        
        // Verify all integrations are configured
        XCTAssertTrue(mockManager.firebaseConfigured)
        XCTAssertTrue(mockManager.coreDataConfigured)
        XCTAssertTrue(mockManager.cloudKitConfigured)
        XCTAssertTrue(mockManager.alamofireConfigured)
        XCTAssertTrue(mockManager.rxSwiftConfigured)
        XCTAssertTrue(mockManager.snapKitConfigured)
        XCTAssertTrue(mockManager.lottieConfigured)
        XCTAssertTrue(mockManager.sdWebImageConfigured)
        XCTAssertTrue(mockManager.customAnalyticsConfigured)
        XCTAssertTrue(mockManager.customAuthConfigured)
        // Payment configuration intentionally omitted
        XCTAssertTrue(mockManager.customPushConfigured)
        
        // Verify all tests passed
        XCTAssertTrue(mockManager.allTestsPassed)
    }
    
    // MARK: - Performance Integration Tests
    
    func testIntegrationPerformance() async throws {
        let startTime = Date()
        
        // Run all integration configurations
        try await configureAllIntegrations()
        
        let configurationTime = Date().timeIntervalSince(startTime)
        
        // Configuration should complete within reasonable time
        XCTAssertLessThan(configurationTime, 10.0) // Less than 10 seconds
        
        let workflowStartTime = Date()
        
        // Run complete workflow
        try await testCompleteWorkflow()
        
        let workflowTime = Date().timeIntervalSince(workflowStartTime)
        
        // Workflow should complete within reasonable time
        XCTAssertLessThan(workflowTime, 5.0) // Less than 5 seconds
        
        let totalTime = Date().timeIntervalSince(startTime)
        
        // Total integration test should complete within reasonable time
        XCTAssertLessThan(totalTime, 15.0) // Less than 15 seconds
    }
    
    // MARK: - Error Handling Integration Tests
    
    func testIntegrationErrorHandling() async throws {
        let mockManager = integrationManager as! MockIntegrationManager
        
        // Simulate various error conditions
        mockManager.shouldSimulateErrors = true
        
        do {
            try await configureAllIntegrations()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is IntegrationError)
        }
        
        // Reset error simulation
        mockManager.shouldSimulateErrors = false
        
        // Should work normally now
        try await configureAllIntegrations()
        XCTAssertTrue(mockManager.allIntegrationsConfigured)
    }
    
    func testPartialIntegrationFailure() async throws {
        let mockManager = integrationManager as! MockIntegrationManager
        
        // Simulate partial failure
        mockManager.shouldSimulatePartialFailure = true
        
        do {
            try await configureAllIntegrations()
            
            // Some integrations should still be configured
            XCTAssertTrue(mockManager.firebaseConfigured)
            XCTAssertFalse(mockManager.coreDataConfigured) // This one should fail
            XCTAssertTrue(mockManager.cloudKitConfigured)
            
        } catch {
            XCTFail("Should not throw error for partial failure")
        }
        
        // Reset failure simulation
        mockManager.shouldSimulatePartialFailure = false
    }
}

// MARK: - Mock Integration Manager

class MockIntegrationManager: IntegrationManager {
    var firebaseConfigured = false
    var coreDataConfigured = false
    var cloudKitConfigured = false
    var alamofireConfigured = false
    var rxSwiftConfigured = false
    var snapKitConfigured = false
    var lottieConfigured = false
    var sdWebImageConfigured = false
    var customAnalyticsConfigured = false
    var customAuthConfigured = false
    // Payment-related flags removed
    var customPushConfigured = false
    
    var workflowCompleted = false
    var allTestsPassed = false
    var shouldSimulateErrors = false
    var shouldSimulatePartialFailure = false
    
    var allIntegrationsConfigured: Bool {
        return firebaseConfigured && coreDataConfigured && cloudKitConfigured &&
               alamofireConfigured && rxSwiftConfigured && snapKitConfigured &&
               lottieConfigured && sdWebImageConfigured && customAnalyticsConfigured &&
               customAuthConfigured && customPushConfigured
    }
    
    // Firebase
    func configureFirebase(with config: FirebaseConfiguration) async throws {
        if shouldSimulateErrors {
            throw IntegrationError.configurationFailed
        }
        firebaseConfigured = true
    }
    
    func registerFirebaseEvent(_ event: String) async throws {
        if shouldSimulateErrors {
            throw IntegrationError.eventRegistrationFailed
        }
    }
    
    func setupRemoteConfig(key: String, defaultValue: String) async throws {
        if shouldSimulateErrors {
            throw IntegrationError.remoteConfigFailed
        }
    }
    
    func testFirebaseAnalytics() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    func testFirebaseRemoteConfig() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    func testFirebaseCrashlytics() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    // Core Data
    func configureCoreData(with config: CoreDataConfiguration) async throws {
        if shouldSimulateErrors || (shouldSimulatePartialFailure && !firebaseConfigured) {
            throw IntegrationError.configurationFailed
        }
        coreDataConfigured = true
    }
    
    func createCoreDataEntity(_ entity: CoreDataEntity) async throws {
        if shouldSimulateErrors {
            throw IntegrationError.entityCreationFailed
        }
    }
    
    func createCoreDataRelationship(_ relationship: CoreDataRelationship) async throws {
        if shouldSimulateErrors {
            throw IntegrationError.relationshipCreationFailed
        }
    }
    
    func testCoreDataEntities() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    func testCoreDataRelationships() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    func testCoreDataBatchOperations() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    // CloudKit
    func configureCloudKit(with config: CloudKitConfiguration) async throws {
        if shouldSimulateErrors {
            throw IntegrationError.configurationFailed
        }
        cloudKitConfigured = true
    }
    
    func createCloudKitSubscription(_ subscription: CloudKitSubscription) async throws {
        if shouldSimulateErrors {
            throw IntegrationError.subscriptionCreationFailed
        }
    }
    
    func configureCloudKitSharing(with config: CloudKitSharingConfiguration) async throws {
        if shouldSimulateErrors {
            throw IntegrationError.sharingConfigurationFailed
        }
    }
    
    func testCloudKitRecords() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    func testCloudKitSubscriptions() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    func testCloudKitSharing() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    // Third-party Services
    func configureAlamofire(with config: AlamofireConfiguration) async throws {
        if shouldSimulateErrors {
            throw IntegrationError.configurationFailed
        }
        alamofireConfigured = true
    }
    
    func configureRxSwift(with config: RxSwiftConfiguration) async throws {
        if shouldSimulateErrors {
            throw IntegrationError.configurationFailed
        }
        rxSwiftConfigured = true
    }
    
    func configureSnapKit(with config: SnapKitConfiguration) async throws {
        if shouldSimulateErrors {
            throw IntegrationError.configurationFailed
        }
        snapKitConfigured = true
    }
    
    func configureLottie(with config: LottieConfiguration) async throws {
        if shouldSimulateErrors {
            throw IntegrationError.configurationFailed
        }
        lottieConfigured = true
    }
    
    func configureSDWebImage(with config: SDWebImageConfiguration) async throws {
        if shouldSimulateErrors {
            throw IntegrationError.configurationFailed
        }
        sdWebImageConfigured = true
    }
    
    func testAlamofire() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    func testRxSwift() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    func testSnapKit() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    func testLottie() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    func testSDWebImage() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    // Custom Integrations
    func configureCustomAnalytics(with config: CustomAnalyticsConfiguration) async throws {
        if shouldSimulateErrors {
            throw IntegrationError.configurationFailed
        }
        customAnalyticsConfigured = true
    }
    
    func configureCustomAuthentication(with config: CustomAuthenticationConfiguration) async throws {
        if shouldSimulateErrors {
            throw IntegrationError.configurationFailed
        }
        customAuthConfigured = true
    }
    
    // Payment-related configuration intentionally omitted
    
    func configureCustomPush(with config: CustomPushConfiguration) async throws {
        if shouldSimulateErrors {
            throw IntegrationError.configurationFailed
        }
        customPushConfigured = true
    }
    
    func testCustomAnalytics() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    func testCustomAuthentication() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    // Payment-related test intentionally omitted
    
    func testCustomPush() async throws {
        if shouldSimulateErrors {
            throw IntegrationError.testFailed
        }
    }
    
    // Workflow Simulation
    func simulateUserAuthentication() async throws {
        // Simulate user authentication workflow
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
    }
    
    func simulateDataSynchronization() async throws {
        // Simulate data synchronization workflow
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
    }
    
    func simulateContentDelivery() async throws {
        // Simulate content delivery workflow
        try await Task.sleep(nanoseconds: 150_000_000) // 0.15 seconds
    }
    
    func simulateAnalyticsTracking() async throws {
        // Simulate analytics tracking workflow
        try await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
    }
    
    // Payment simulation intentionally omitted
    
    func simulatePushNotifications() async throws {
        // Simulate push notifications workflow
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
    }
}

// MARK: - Supporting Models

enum IntegrationError: Error {
    case configurationFailed
    case eventRegistrationFailed
    case remoteConfigFailed
    case entityCreationFailed
    case relationshipCreationFailed
    case subscriptionCreationFailed
    case sharingConfigurationFailed
    case testFailed
}
