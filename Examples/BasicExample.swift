import EducationAI
import SwiftUI

// MARK: - Basic EducationAI Integration Example

/// This example demonstrates the basic setup and usage of EducationAI framework
/// for creating a simple learning application with AI-powered recommendations.

@main
struct EducationAIExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Main Content View

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                HeaderView()
                
                // Authentication Section
                if viewModel.isAuthenticated {
                    LearningDashboardView()
                } else {
                    AuthenticationView()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("EducationAI Example")
        }
        .onAppear {
            viewModel.checkAuthenticationStatus()
        }
    }
}

// MARK: - Header View

struct HeaderView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("EducationAI")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("AI-Powered Learning Platform")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// MARK: - Authentication View

struct AuthenticationView: View {
    @StateObject private var authViewModel = AuthenticationViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to EducationAI")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Sign in to access your personalized learning experience")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            // Biometric Authentication Button
            Button(action: {
                Task {
                    await authViewModel.authenticateWithBiometrics()
                }
            }) {
                HStack {
                    Image(systemName: "faceid")
                        .font(.title2)
                    Text("Sign in with Face ID")
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .disabled(authViewModel.isAuthenticating)
            
            // Manual Sign In
            Button("Sign in with Email") {
                authViewModel.showManualSignIn = true
            }
            .foregroundColor(.blue)
            
            if authViewModel.isAuthenticating {
                ProgressView("Authenticating...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
            
            if let error = authViewModel.error {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
        .sheet(isPresented: $authViewModel.showManualSignIn) {
            ManualSignInView()
        }
    }
}

// MARK: - Learning Dashboard View

struct LearningDashboardView: View {
    @StateObject private var dashboardViewModel = LearningDashboardViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // User Welcome
                UserWelcomeView()
                
                // AI Recommendations
                AIRecommendationsView()
                
                // Learning Progress
                LearningProgressView()
                
                // Available Courses
                AvailableCoursesView()
            }
            .padding()
        }
        .refreshable {
            await dashboardViewModel.refreshData()
        }
        .onAppear {
            Task {
                await dashboardViewModel.loadData()
            }
        }
    }
}

// MARK: - AI Recommendations View

struct AIRecommendationsView: View {
    @StateObject private var recommendationsViewModel = AIRecommendationsViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.blue)
                Text("AI Recommendations")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            if recommendationsViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(recommendationsViewModel.recommendations) { recommendation in
                    RecommendationCardView(recommendation: recommendation)
                }
            }
            
            Button("Get New Recommendations") {
                Task {
                    await recommendationsViewModel.getNewRecommendations()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(recommendationsViewModel.isLoading)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onAppear {
            Task {
                await recommendationsViewModel.loadRecommendations()
            }
        }
    }
}

// MARK: - Recommendation Card View

struct RecommendationCardView: View {
    let recommendation: Recommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(recommendation.title)
                    .font(.headline)
                    .fontWeight(.medium)
                Spacer()
                Text("\(Int(recommendation.relevanceScore * 100))%")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Text(recommendation.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack {
                Label("\(recommendation.duration) min", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Label(recommendation.difficulty.rawValue.capitalized, systemImage: "star.fill")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

// MARK: - Learning Progress View

struct LearningProgressView: View {
    @StateObject private var progressViewModel = LearningProgressViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.green)
                Text("Learning Progress")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            if let progress = progressViewModel.progress {
                VStack(spacing: 12) {
                    ProgressRowView(
                        title: "Total Study Time",
                        value: "\(Int(progress.totalStudyTime / 3600)) hours",
                        icon: "clock.fill"
                    )
                    
                    ProgressRowView(
                        title: "Completed Lessons",
                        value: "\(progress.completedLessons.count)",
                        icon: "checkmark.circle.fill"
                    )
                    
                    ProgressRowView(
                        title: "Average Score",
                        value: "\(Int(progress.averageScore))%",
                        icon: "star.fill"
                    )
                    
                    ProgressRowView(
                        title: "Current Streak",
                        value: "\(progress.currentStreak) days",
                        icon: "flame.fill"
                    )
                }
            } else {
                ProgressView("Loading progress...")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onAppear {
            Task {
                await progressViewModel.loadProgress()
            }
        }
    }
}

// MARK: - Progress Row View

struct ProgressRowView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Available Courses View

struct AvailableCoursesView: View {
    @StateObject private var coursesViewModel = AvailableCoursesViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "book.fill")
                    .foregroundColor(.purple)
                Text("Available Courses")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            if coursesViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(coursesViewModel.courses) { course in
                    CourseCardView(course: course)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onAppear {
            Task {
                await coursesViewModel.loadCourses()
            }
        }
    }
}

// MARK: - Course Card View

struct CourseCardView: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(course.title)
                    .font(.headline)
                    .fontWeight(.medium)
                Spacer()
                Text(course.difficulty.rawValue.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(difficultyColor.opacity(0.2))
                    .foregroundColor(difficultyColor)
                    .cornerRadius(8)
            }
            
            Text(course.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Label("\(course.lessons.count) lessons", systemImage: "list.bullet")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Label("\(Int(course.estimatedDuration / 60)) min", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
    
    private var difficultyColor: Color {
        switch course.difficulty {
        case .beginner:
            return .green
        case .intermediate:
            return .orange
        case .advanced:
            return .red
        case .expert:
            return .purple
        }
    }
}

// MARK: - View Models

@MainActor
class ContentViewModel: ObservableObject {
    @Published var isAuthenticated = false
    
    func checkAuthenticationStatus() {
        // Check if user is authenticated
        let securityManager = SecurityManager()
        isAuthenticated = securityManager.isAuthenticated
    }
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticating = false
    @Published var error: Error?
    @Published var showManualSignIn = false
    
    func authenticateWithBiometrics() async {
        isAuthenticating = true
        error = nil
        
        do {
            let securityManager = SecurityManager()
            try await securityManager.authenticateWithBiometrics()
            // Authentication successful
        } catch {
            self.error = error
        }
        
        isAuthenticating = false
    }
}

@MainActor
class LearningDashboardViewModel: ObservableObject {
    @Published var isLoading = false
    
    func loadData() async {
        isLoading = true
        // Load dashboard data
        isLoading = false
    }
    
    func refreshData() async {
        await loadData()
    }
}

@MainActor
class AIRecommendationsViewModel: ObservableObject {
    @Published var recommendations: [Recommendation] = []
    @Published var isLoading = false
    
    func loadRecommendations() async {
        isLoading = true
        
        do {
            let aiService = AIService()
            let recommendations = try await aiService.getPersonalizedRecommendations(for: "user123")
            self.recommendations = recommendations
        } catch {
            print("Failed to load recommendations: \(error)")
        }
        
        isLoading = false
    }
    
    func getNewRecommendations() async {
        await loadRecommendations()
    }
}

@MainActor
class LearningProgressViewModel: ObservableObject {
    @Published var progress: LearningProgress?
    
    func loadProgress() async {
        // Load user progress
        progress = LearningProgress(
            completedLessons: ["lesson1", "lesson2"],
            currentCourse: "course1",
            totalStudyTime: 7200, // 2 hours
            averageScore: 85.0,
            currentStreak: 7
        )
    }
}

@MainActor
class AvailableCoursesViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var isLoading = false
    
    func loadCourses() async {
        isLoading = true
        
        // Load available courses
        courses = [
            Course(
                id: "course1",
                title: "Swift Programming Basics",
                description: "Learn the fundamentals of Swift programming language",
                difficulty: .beginner,
                lessons: [],
                estimatedDuration: 3600
            ),
            Course(
                id: "course2",
                title: "iOS App Development",
                description: "Build your first iOS app with SwiftUI",
                difficulty: .intermediate,
                lessons: [],
                estimatedDuration: 7200
            ),
            Course(
                id: "course3",
                title: "Advanced iOS Patterns",
                description: "Master advanced iOS development patterns and architectures",
                difficulty: .advanced,
                lessons: [],
                estimatedDuration: 10800
            )
        ]
        
        isLoading = false
    }
}

// MARK: - Manual Sign In View

struct ManualSignInView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var error: Error?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Sign In")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Button("Sign In") {
                    Task {
                        await signIn()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(email.isEmpty || password.isEmpty || isLoading)
                
                if isLoading {
                    ProgressView("Signing in...")
                }
                
                if let error = error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func signIn() async {
        isLoading = true
        error = nil
        
        do {
            let authManager = AuthManager()
            try await authManager.signIn(email: email, password: password)
            dismiss()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}

// MARK: - User Welcome View

struct UserWelcomeView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.blue)
            
            Text("Welcome back, User!")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Ready to continue your learning journey?")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// MARK: - Data Models

struct Recommendation: Identifiable {
    let id: String
    let title: String
    let description: String
    let relevanceScore: Double
    let duration: TimeInterval
    let difficulty: DifficultyLevel
}

struct LearningProgress {
    let completedLessons: [String]
    let currentCourse: String?
    let totalStudyTime: TimeInterval
    let averageScore: Double
    let currentStreak: Int
}

struct Course: Identifiable {
    let id: String
    let title: String
    let description: String
    let difficulty: DifficultyLevel
    let lessons: [Lesson]
    let estimatedDuration: TimeInterval
}

struct Lesson {
    let id: String
    let title: String
    let content: String
    let duration: TimeInterval
}

enum DifficultyLevel: String, CaseIterable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
    case expert = "expert"
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
