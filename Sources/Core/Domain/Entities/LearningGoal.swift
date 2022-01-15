import Foundation

/// Represents a learning goal that a user wants to achieve
public struct LearningGoal: Codable, Identifiable, Hashable {
    
    // MARK: - Properties
    public let id: UUID
    public let title: String
    public let description: String
    public let category: GoalCategory
    public let targetDate: Date?
    public let priority: GoalPriority
    public var status: GoalStatus
    public var progress: Double // 0.0 to 1.0
    public var milestones: [Milestone]
    public let relatedSubjects: [Subject]
    public let estimatedEffort: TimeInterval
    public let createdAt: Date
    public var updatedAt: Date
    
    // MARK: - Initialization
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        category: GoalCategory,
        targetDate: Date? = nil,
        priority: GoalPriority = .medium,
        status: GoalStatus = .active,
        progress: Double = 0.0,
        milestones: [Milestone] = [],
        relatedSubjects: [Subject] = [],
        estimatedEffort: TimeInterval = 0,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.targetDate = targetDate
        self.priority = priority
        self.status = status
        self.progress = progress
        self.milestones = milestones
        self.relatedSubjects = relatedSubjects
        self.estimatedEffort = estimatedEffort
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // MARK: - Public Methods
    /// Update goal progress
    public mutating func updateProgress(_ newProgress: Double) {
        progress = max(0.0, min(1.0, newProgress))
        updatedAt = Date()
        
        if progress >= 1.0 {
            status = .completed
        }
    }
    
    /// Add a new milestone
    public mutating func addMilestone(_ milestone: Milestone) {
        milestones.append(milestone)
        updateProgress()
    }
    
    /// Complete a milestone
    public mutating func completeMilestone(_ milestoneId: UUID) {
        if let index = milestones.firstIndex(where: { $0.id == milestoneId }) {
            milestones[index].isCompleted = true
            updateProgress()
        }
    }
    
    /// Update goal status
    public mutating func updateStatus(_ newStatus: GoalStatus) {
        status = newStatus
        updatedAt = Date()
    }
    
    /// Check if goal is overdue
    public var isOverdue: Bool {
        guard let targetDate = targetDate else { return false }
        return Date() > targetDate && status != .completed
    }
    
    /// Get days until target date
    public var daysUntilTarget: Int? {
        guard let targetDate = targetDate else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: targetDate)
        return components.day
    }
    
    /// Get progress percentage
    public var progressPercentage: Int {
        return Int(progress * 100)
    }
    
    /// Get formatted estimated effort
    public var formattedEffort: String {
        let hours = Int(estimatedEffort) / 3600
        let minutes = Int(estimatedEffort) % 3600 / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    /// Check if goal is active
    public var isActive: Bool {
        return status == .active
    }
    
    /// Check if goal is completed
    public var isCompleted: Bool {
        return status == .completed
    }
    
    // MARK: - Private Methods
    private mutating func updateProgress() {
        let totalMilestones = milestones.count
        let completedMilestones = milestones.filter { $0.isCompleted }.count
        
        if totalMilestones > 0 {
            progress = Double(completedMilestones) / Double(totalMilestones)
        }
    }
    
    // MARK: - Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: LearningGoal, rhs: LearningGoal) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Supporting Types
public enum GoalCategory: String, Codable, CaseIterable {
    case academic = "academic"
    case professional = "professional"
    case personal = "personal"
    case skill = "skill"
    case certification = "certification"
    case language = "language"
    case hobby = "hobby"
    case health = "health"
    case financial = "financial"
    case creative = "creative"
    
    public var displayName: String {
        switch self {
        case .academic: return "Academic"
        case .professional: return "Professional"
        case .personal: return "Personal"
        case .skill: return "Skill Development"
        case .certification: return "Certification"
        case .language: return "Language Learning"
        case .hobby: return "Hobby"
        case .health: return "Health & Wellness"
        case .financial: return "Financial Literacy"
        case .creative: return "Creative Arts"
        }
    }
    
    public var icon: String {
        switch self {
        case .academic: return "graduationcap"
        case .professional: return "briefcase"
        case .personal: return "person"
        case .skill: return "hammer"
        case .certification: return "checkmark.seal"
        case .language: return "textformat"
        case .hobby: return "heart"
        case .health: return "heart.fill"
        case .financial: return "dollarsign.circle"
        case .creative: return "paintbrush"
        }
    }
}

public enum GoalPriority: String, Codable, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case critical = "critical"
    
    public var displayName: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .critical: return "Critical"
        }
    }
    
    public var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "blue"
        case .high: return "orange"
        case .critical: return "red"
        }
    }
}

public enum GoalStatus: String, Codable, CaseIterable {
    case active = "active"
    case paused = "paused"
    case completed = "completed"
    case abandoned = "abandoned"
    case onHold = "onHold"
    
    public var displayName: String {
        switch self {
        case .active: return "Active"
        case .paused: return "Paused"
        case .completed: return "Completed"
        case .abandoned: return "Abandoned"
        case .onHold: return "On Hold"
        }
    }
    
    public var icon: String {
        switch self {
        case .active: return "play.circle"
        case .paused: return "pause.circle"
        case .completed: return "checkmark.circle"
        case .abandoned: return "xmark.circle"
        case .onHold: return "clock"
        }
    }
}

public struct Milestone: Codable, Identifiable {
    public let id: UUID
    public let title: String
    public let description: String
    public let targetDate: Date?
    public var isCompleted: Bool
    public let order: Int
    public let weight: Double // 0.0 to 1.0, represents importance in overall goal
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        targetDate: Date? = nil,
        isCompleted: Bool = false,
        order: Int,
        weight: Double = 1.0
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.targetDate = targetDate
        self.isCompleted = isCompleted
        self.order = order
        self.weight = weight
    }
    
    /// Check if milestone is overdue
    public var isOverdue: Bool {
        guard let targetDate = targetDate else { return false }
        return Date() > targetDate && !isCompleted
    }
    
    /// Get days until target date
    public var daysUntilTarget: Int? {
        guard let targetDate = targetDate else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: targetDate)
        return components.day
    }
}
