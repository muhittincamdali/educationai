//
//  Community.swift
//  EducationAI
//
//  Created by Muhittin Camdali on 2024
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation

struct Community: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let subject: String
    let memberCount: Int
    let maxMembers: Int?
    let isPrivate: Bool
    let createdAt: Date
    let createdBy: UUID
    let tags: [String]
    let rules: [String]
    let isJoined: Bool
    
    var isFull: Bool {
        guard let maxMembers = maxMembers else { return false }
        return memberCount >= maxMembers
    }
    
    var memberPercentage: Double {
        guard let maxMembers = maxMembers else { return 0.0 }
        return Double(memberCount) / Double(maxMembers)
    }
    
    init(id: UUID = UUID(),
         name: String,
         description: String,
         subject: String,
         memberCount: Int = 0,
         maxMembers: Int? = nil,
         isPrivate: Bool = false,
         createdAt: Date = Date(),
         createdBy: UUID,
         tags: [String] = [],
         rules: [String] = [],
         isJoined: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.subject = subject
        self.memberCount = memberCount
        self.maxMembers = maxMembers
        self.isPrivate = isPrivate
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.tags = tags
        self.rules = rules
        self.isJoined = isJoined
    }
}

struct CommunityPost: Identifiable, Codable {
    let id: UUID
    let communityId: UUID
    let authorId: UUID
    let authorName: String
    let authorAvatar: String?
    let content: String
    let type: PostType
    let attachments: [PostAttachment]
    let likes: Int
    let comments: Int
    let isLiked: Bool
    let createdAt: Date
    
    enum PostType: String, Codable {
        case text = "text"
        case question = "question"
        case resource = "resource"
        case achievement = "achievement"
        case poll = "poll"
    }
    
    init(id: UUID = UUID(),
         communityId: UUID,
         authorId: UUID,
         authorName: String,
         authorAvatar: String? = nil,
         content: String,
         type: PostType = .text,
         attachments: [PostAttachment] = [],
         likes: Int = 0,
         comments: Int = 0,
         isLiked: Bool = false,
         createdAt: Date = Date()) {
        self.id = id
        self.communityId = communityId
        self.authorId = authorId
        self.authorName = authorName
        self.authorAvatar = authorAvatar
        self.content = content
        self.type = type
        self.attachments = attachments
        self.likes = likes
        self.comments = comments
        self.isLiked = isLiked
        self.createdAt = createdAt
    }
}

struct PostAttachment: Identifiable, Codable {
    let id: UUID
    let type: AttachmentType
    let url: String
    let title: String?
    let size: Int?
    
    enum AttachmentType: String, Codable {
        case image = "image"
        case video = "video"
        case document = "document"
        case link = "link"
    }
    
    init(id: UUID = UUID(),
         type: AttachmentType,
         url: String,
         title: String? = nil,
         size: Int? = nil) {
        self.id = id
        self.type = type
        self.url = url
        self.title = title
        self.size = size
    }
}

// MARK: - Mock Data
extension Community {
    static let mockCommunities: [Community] = [
        Community(
            name: "Mathematics Enthusiasts",
            description: "A community for math lovers to discuss problems and share solutions",
            subject: "Mathematics",
            memberCount: 1250,
            maxMembers: 2000,
            createdBy: UUID(),
            tags: ["mathematics", "algebra", "calculus", "geometry"],
            rules: ["Be respectful", "No spam", "Stay on topic"],
            isJoined: true
        ),
        Community(
            name: "English Learners",
            description: "Practice English with native speakers and other learners",
            subject: "English",
            memberCount: 890,
            maxMembers: 1500,
            createdBy: UUID(),
            tags: ["english", "grammar", "vocabulary", "conversation"],
            rules: ["English only", "Be patient", "Help others"],
            isJoined: false
        ),
        Community(
            name: "Science Explorers",
            description: "Discover the wonders of science through experiments and discussions",
            subject: "Science",
            memberCount: 567,
            maxMembers: 1000,
            createdBy: UUID(),
            tags: ["science", "physics", "chemistry", "biology"],
            rules: ["Share experiments", "Ask questions", "Be curious"],
            isJoined: true
        )
    ]
}

extension CommunityPost {
    static let mockPosts: [CommunityPost] = [
        CommunityPost(
            communityId: UUID(),
            authorId: UUID(),
            authorName: "Alex Johnson",
            content: "Just solved a challenging calculus problem! Anyone want to discuss the solution?",
            type: .question,
            likes: 12,
            comments: 5
        ),
        CommunityPost(
            communityId: UUID(),
            authorId: UUID(),
            authorName: "Maria Garcia",
            content: "Great resource for learning English grammar: https://grammar.com",
            type: .resource,
            likes: 8,
            comments: 3
        ),
        CommunityPost(
            communityId: UUID(),
            authorId: UUID(),
            authorName: "David Chen",
            content: "Achieved my goal of completing 50 lessons this month! 🎉",
            type: .achievement,
            likes: 25,
            comments: 10
        )
    ]
} 