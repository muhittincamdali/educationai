import Foundation

public enum RecommendationType: String, Codable, CaseIterable {
    case content = "content"
    case studyStrategy = "studyStrategy"
    case timeManagement = "timeManagement"
    case skillDevelopment = "skillDevelopment"
    case assessment = "assessment"
    case collaboration = "collaboration"
    case motivation = "motivation"
    case accessibility = "accessibility"
}
