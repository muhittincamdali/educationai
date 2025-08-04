//
//  Goal.swift
//  EducationAI
//
//  Created by Muhittin Camdali on 2024
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation

struct Goal: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let targetValue: Int
    let currentValue: Int
    let unit: String
    let deadline: Date?
    let category: GoalCategory
    let isCompleted: Bool
    let createdAt: Date
    let updatedAt: Date
    
    enum GoalCategory: String, Codable, CaseIterable {
        case daily = "daily"
        case weekly = "weekly"
        case monthly = "monthly"
        case custom = "custom"
        
        var displayName: String {
            switch self {
            case .daily: return "Daily"
            case .weekly: return "Weekly"
            case .monthly: return "Monthly"
            case .custom: return "Custom"
            }
        }
    }
    
    var progress: Double {
        guard targetValue > 0 else { return 0.0 }
        return min(Double(currentValue) / Double(targetValue), 1.0)
    }
    
    var isOverdue: Bool {
        guard let deadline = deadline else { return false }
        return Date() > deadline && !isCompleted
    }
    
    init(id: UUID = UUID(),
         title: String,
         description: String,
         targetValue: Int,
         currentValue: Int = 0,
         unit: String,
         deadline: Date? = nil,
         category: GoalCategory,
         isCompleted: Bool = false,
         createdAt: Date = Date(),
         updatedAt: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.targetValue = targetValue
        self.currentValue = currentValue
        self.unit = unit
        self.deadline = deadline
        self.category = category
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    func updated(with newValue: Int) -> Goal {
        Goal(
            id: id,
            title: title,
            description: description,
            targetValue: targetValue,
            currentValue: newValue,
            unit: unit,
            deadline: deadline,
            category: category,
            isCompleted: newValue >= targetValue,
            createdAt: createdAt,
            updatedAt: Date()
        )
    }
}

// MARK: - Mock Data
extension Goal {
    static let mockGoals: [Goal] = [
        Goal(
            title: "Daily Learning",
            description: "Complete 3 lessons today",
            targetValue: 3,
            currentValue: 2,
            unit: "lessons",
            deadline: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            category: .daily
        ),
        Goal(
            title: "Weekly Streak",
            description: "Maintain 7-day learning streak",
            targetValue: 7,
            currentValue: 5,
            unit: "days",
            deadline: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
            category: .weekly
        ),
        Goal(
            title: "Subject Mastery",
            description: "Complete 20 lessons in Mathematics",
            targetValue: 20,
            currentValue: 15,
            unit: "lessons",
            deadline: Calendar.current.date(byAdding: .month, value: 1, to: Date()),
            category: .monthly
        ),
        Goal(
            title: "Social Learning",
            description: "Join 3 study groups",
            targetValue: 3,
            currentValue: 1,
            unit: "groups",
            deadline: Calendar.current.date(byAdding: .day, value: 14, to: Date()),
            category: .custom
        )
    ]
} 