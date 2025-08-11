# EducationAI API Documentation

> Complete API reference for the EducationAI platform

## Table of Contents

- [Overview](#overview)
- [Authentication](#authentication)
- [Core Services](#core-services)
- [Entities](#entities)
- [Error Handling](#error-handling)
- [Examples](#examples)
- [Rate Limiting](#rate-limiting)
- [SDK Integration](#sdk-integration)

## Overview

The EducationAI API provides a comprehensive set of endpoints for building AI-powered educational applications. The API follows RESTful principles and uses JSON for data exchange.

### Base URL
```
https://api.educationai.com/v1
```

### API Versioning
- Current version: `v1`
- Version is specified in the URL path
- Breaking changes will result in a new major version

## Authentication

EducationAI uses OAuth 2.0 with JWT tokens for authentication.

### Getting an Access Token

```http
POST /auth/token
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials
&client_id=YOUR_CLIENT_ID
&client_secret=YOUR_CLIENT_SECRET
```

### Response

```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "read write"
}
```

### Using the Access Token

```http
Authorization: Bearer YOUR_ACCESS_TOKEN
```

## Core Services

### AIService

The core AI service that provides intelligent learning recommendations and content generation.

#### Get Personalized Recommendations

```http
GET /ai/recommendations?user_id={user_id}&limit={limit}
```

**Parameters:**
- `user_id` (required): UUID of the user
- `limit` (optional): Maximum number of recommendations (default: 10)

**Response:**
```json
{
  "recommendations": [
    {
      "id": "uuid",
      "course_id": "uuid",
      "confidence": 0.95,
      "reason": "Based on your strong performance in mathematics",
      "estimated_completion_time": 7200,
      "difficulty_match": 0.87,
      "interest_match": 0.92
    }
  ]
}
```

#### Generate Adaptive Learning Path

```http
POST /ai/learning-path
Content-Type: application/json

{
  "user_id": "uuid",
  "subject": "mathematics",
  "target_skill_level": "advanced"
}
```

**Response:**
```json
{
  "id": "uuid",
  "user_id": "uuid",
  "subject": "mathematics",
  "target_skill_level": "advanced",
  "modules": [
    {
      "id": "uuid",
      "course_id": "uuid",
      "order": 1,
      "estimated_duration": 3600,
      "prerequisites": [],
      "learning_objectives": ["Understand calculus fundamentals"]
    }
  ],
  "estimated_duration": 14400,
  "difficulty_progression": [0.3, 0.5, 0.7, 0.9],
  "milestones": [
    {
      "id": "uuid",
      "title": "Complete Calculus Basics",
      "description": "Master fundamental calculus concepts",
      "target_date": "2024-03-15T00:00:00Z",
      "is_completed": false
    }
  ]
}
```

#### Analyze Learning Progress

```http
GET /ai/progress?user_id={user_id}&time_range={time_range}
```

**Parameters:**
- `user_id` (required): UUID of the user
- `time_range` (optional): Time range for analysis (default: last_month)

**Response:**
```json
{
  "overall_progress": 0.75,
  "strengths": ["mathematics", "computer_science"],
  "areas_for_improvement": ["language", "history"],
  "learning_velocity": 0.12,
  "consistency_score": 0.88,
  "recommendations": [
    "Focus on language studies to improve overall balance",
    "Consider advanced mathematics courses given your strong performance"
  ],
  "time_spent": 86400,
  "completed_items": 15,
  "average_score": 0.87
}
```

#### Generate Personalized Content

```http
POST /ai/content
Content-Type: application/json

{
  "user_id": "uuid",
  "content_type": "lesson",
  "subject": "mathematics"
}
```

**Response:**
```json
{
  "id": "uuid",
  "type": "lesson",
  "title": "Advanced Calculus: Derivatives and Applications",
  "content": "In this lesson, we'll explore the fundamental concepts...",
  "metadata": {
    "difficulty": "advanced",
    "estimated_duration": "45 minutes",
    "prerequisites": ["basic_calculus"]
  },
  "difficulty": "advanced",
  "estimated_duration": 2700,
  "tags": ["calculus", "derivatives", "applications"]
}
```

#### Assess Current Skills

```http
POST /ai/assessment
Content-Type: application/json

{
  "user_id": "uuid",
  "subject": "mathematics"
}
```

**Response:**
```json
{
  "subject": "mathematics",
  "current_level": "intermediate",
  "confidence": 0.89,
  "strengths": [
    "Algebra fundamentals",
    "Basic calculus operations"
  ],
  "weaknesses": [
    "Complex integration techniques",
    "Advanced proof methods"
  ],
  "recommendations": [
    "Focus on integration practice",
    "Study proof techniques",
    "Consider advanced calculus courses"
  ],
  "next_milestone": "Master integration techniques"
}
```

#### Optimize Study Schedule

```http
POST /ai/schedule
Content-Type: application/json

{
  "user_id": "uuid",
  "available_time": 7200,
  "goals": [
    {
      "title": "Master Calculus",
      "description": "Complete advanced calculus course",
      "priority": "high"
    }
  ]
}
```

**Response:**
```json
{
  "daily_schedule": [
    {
      "time_slot": {
        "start_time": "2024-01-15T09:00:00Z",
        "end_time": "2024-01-15T10:30:00Z"
      },
      "subject": "mathematics",
      "duration": 5400,
      "type": "learning",
      "priority": "high"
    }
  ],
  "weekly_goals": [
    {
      "week": 1,
      "subject": "mathematics",
      "target": "Complete calculus fundamentals module",
      "is_completed": false
    }
  ],
  "optimal_study_times": [
    {
      "day_of_week": 1,
      "time_range": [9, 11],
      "productivity_score": 0.95
    }
  ],
  "break_recommendations": [
    {
      "duration": 300,
      "frequency": 1500,
      "activities": ["Stretch", "Eye rest", "Quick walk"]
    }
  ],
  "estimated_completion_date": "2024-02-15T00:00:00Z"
}
```

### User Management

#### Create User

```http
POST /users
Content-Type: application/json

{
  "email": "student@example.com",
  "username": "student123",
  "first_name": "John",
  "last_name": "Doe",
  "learning_style": "visual",
  "preferred_subjects": ["mathematics", "science"],
  "skill_level": "beginner"
}
```

**Response:**
```json
{
  "id": "uuid",
  "email": "student@example.com",
  "username": "student123",
  "first_name": "John",
  "last_name": "Doe",
  "profile_image_url": null,
  "date_of_birth": null,
  "created_at": "2024-01-15T10:00:00Z",
  "last_active_at": "2024-01-15T10:00:00Z",
  "learning_style": "visual",
  "preferred_subjects": ["mathematics", "science"],
  "skill_level": "beginner",
  "time_zone": "America/New_York",
  "total_study_time": 0,
  "completed_courses": 0,
  "current_streak": 0,
  "longest_streak": 0,
  "average_score": 0.0
}
```

#### Get User Profile

```http
GET /users/{user_id}
```

**Response:**
```json
{
  "id": "uuid",
  "email": "student@example.com",
  "username": "student123",
  "first_name": "John",
  "last_name": "Doe",
  "profile_image_url": "https://example.com/avatar.jpg",
  "date_of_birth": "1995-06-15T00:00:00Z",
  "created_at": "2024-01-15T10:00:00Z",
  "last_active_at": "2024-01-15T15:30:00Z",
  "learning_style": "visual",
  "preferred_subjects": ["mathematics", "science"],
  "skill_level": "intermediate",
  "time_zone": "America/New_York",
  "total_study_time": 86400,
  "completed_courses": 5,
  "current_streak": 7,
  "longest_streak": 12,
  "average_score": 0.87
}
```

#### Update User Profile

```http
PUT /users/{user_id}
Content-Type: application/json

{
  "learning_style": "mixed",
  "preferred_subjects": ["mathematics", "computer_science", "physics"]
}
```

### Course Management

#### Get Available Courses

```http
GET /courses?subject={subject}&difficulty={difficulty}&limit={limit}
```

**Parameters:**
- `subject` (optional): Filter by subject
- `difficulty` (optional): Filter by difficulty level
- `limit` (optional): Maximum number of courses (default: 20)

**Response:**
```json
{
  "courses": [
    {
      "id": "uuid",
      "title": "Advanced Calculus",
      "description": "Comprehensive course covering advanced calculus concepts",
      "short_description": "Master advanced calculus techniques",
      "thumbnail_url": "https://example.com/calc-thumb.jpg",
      "banner_url": "https://example.com/calc-banner.jpg",
      "category": "mathematics",
      "subject": "mathematics",
      "difficulty": "advanced",
      "estimated_duration": 14400,
      "language": "en",
      "modules": [],
      "prerequisites": [],
      "learning_objectives": [
        "Understand complex integration techniques",
        "Master differential equations",
        "Apply calculus to real-world problems"
      ],
      "tags": ["calculus", "mathematics", "advanced"],
      "author": {
        "id": "uuid",
        "name": "Dr. Sarah Wilson",
        "bio": "Mathematics professor with 15 years of experience",
        "avatar_url": "https://example.com/sarah-avatar.jpg",
        "expertise": ["calculus", "analysis", "mathematical_physics"],
        "verified": true,
        "total_courses": 8,
        "average_rating": 4.8
      },
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-15T00:00:00Z",
      "published_at": "2024-01-01T00:00:00Z",
      "version": "1.0.0",
      "enrollment_count": 1250,
      "completion_rate": 0.78,
      "average_rating": 4.6,
      "review_count": 89,
      "is_free": false,
      "price": 99.99,
      "currency": "USD",
      "access_level": "premium",
      "is_published": true
    }
  ],
  "pagination": {
    "page": 1,
    "per_page": 20,
    "total": 150,
    "total_pages": 8
  }
}
```

#### Get Course Details

```http
GET /courses/{course_id}
```

#### Enroll in Course

```http
POST /courses/{course_id}/enroll
Content-Type: application/json

{
  "user_id": "uuid"
}
```

#### Get Course Progress

```http
GET /courses/{course_id}/progress?user_id={user_id}
```

## Entities

### User

Represents a user in the EducationAI system.

```swift
public struct User: Codable, Identifiable, Equatable {
    public let id: UUID
    public let email: String
    public let username: String
    public let firstName: String
    public let lastName: String
    public let profileImageURL: URL?
    public let dateOfBirth: Date?
    public let createdAt: Date
    public let lastActiveAt: Date
    public let learningStyle: LearningStyle
    public let preferredSubjects: [Subject]
    public let skillLevel: SkillLevel
    public let timeZone: TimeZone
    public let totalStudyTime: TimeInterval
    public let completedCourses: Int
    public let currentStreak: Int
    public let longestStreak: Int
    public let averageScore: Double
    public let notificationPreferences: NotificationPreferences
    public let accessibilitySettings: AccessibilitySettings
    public let languagePreference: Language
}
```

### Course

Represents an educational course.

```swift
public struct Course: Codable, Identifiable, Equatable {
    public let id: UUID
    public let title: String
    public let description: String
    public let shortDescription: String
    public let thumbnailURL: URL?
    public let bannerURL: URL?
    public let category: CourseCategory
    public let subject: Subject
    public let difficulty: SkillLevel
    public let estimatedDuration: TimeInterval
    public let language: Language
    public let modules: [Module]
    public let prerequisites: [UUID]
    public let learningObjectives: [String]
    public let tags: [String]
    public let author: CourseAuthor
    public let createdAt: Date
    public let updatedAt: Date
    public let publishedAt: Date?
    public let version: String
    public let enrollmentCount: Int
    public let completionRate: Double
    public let averageRating: Double
    public let reviewCount: Int
    public let isFree: Bool
    public let price: Decimal?
    public let currency: String?
    public let accessLevel: AccessLevel
    public let isPublished: Bool
}
```

### Module

Represents a module within a course.

```swift
public struct Module: Codable, Identifiable, Equatable {
    public let id: UUID
    public let title: String
    public let description: String
    public let order: Int
    public let lessons: [Lesson]
    public let quizzes: [Quiz]
    public let assignments: [Assignment]
    public let estimatedDuration: TimeInterval
    public let isCompleted: Bool
}
```

### Lesson

Represents a lesson within a module.

```swift
public struct Lesson: Codable, Identifiable, Equatable {
    public let id: UUID
    public let title: String
    public let content: String
    public let type: LessonType
    public let duration: TimeInterval
    public let order: Int
    public let isCompleted: Bool
    public let resources: [Resource]
}
```

## Error Handling

The API uses standard HTTP status codes and returns detailed error information.

### Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input parameters",
    "details": [
      {
        "field": "email",
        "message": "Email format is invalid"
      }
    ],
    "request_id": "req_123456789",
    "timestamp": "2024-01-15T10:00:00Z"
  }
}
```

### Common Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `VALIDATION_ERROR` | 400 | Input validation failed |
| `UNAUTHORIZED` | 401 | Authentication required |
| `FORBIDDEN` | 403 | Insufficient permissions |
| `NOT_FOUND` | 404 | Resource not found |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests |
| `INTERNAL_ERROR` | 500 | Internal server error |

## Examples

### Complete Learning Workflow

```swift
import EducationAI

// 1. Initialize AI service
let aiService = AIService()

// 2. Get personalized recommendations
let recommendations = try await aiService.getPersonalizedRecommendations(
    for: userId,
    limit: 5
)

// 3. Generate adaptive learning path
let learningPath = try await aiService.generateAdaptiveLearningPath(
    for: userId,
    subject: .mathematics,
    targetSkillLevel: .advanced
)

// 4. Analyze progress
let progress = try await aiService.analyzeLearningProgress(
    for: userId,
    timeRange: .lastMonth
)

// 5. Generate personalized content
let content = try await aiService.generatePersonalizedContent(
    for: userId,
    contentType: .lesson,
    subject: .mathematics
)

// 6. Optimize study schedule
let schedule = try await aiService.optimizeStudySchedule(
    for: userId,
    availableTime: 2 * 60 * 60, // 2 hours
    goals: [learningGoal]
)
```

### User Management

```swift
// Create new user
let user = User(
    email: "student@example.com",
    username: "student123",
    firstName: "John",
    lastName: "Doe",
    learningStyle: .visual,
    preferredSubjects: [.mathematics, .science],
    skillLevel: .beginner
)

// Update user progress
let updatedUser = user
    .updateStudyTime(3600) // 1 hour
    .completeCourse()
    .updateStreak(5)
    .updateAverageScore(0.85)
```

### Course Management

```swift
// Create course with modules
let course = Course(
    title: "Advanced Mathematics",
    description: "Comprehensive advanced mathematics course",
    shortDescription: "Master advanced mathematical concepts",
    category: .mathematics,
    subject: .mathematics,
    difficulty: .advanced,
    estimatedDuration: 14400, // 4 hours
    author: courseAuthor
)

// Add modules to course
let module = Module(
    title: "Calculus Fundamentals",
    description: "Introduction to calculus concepts",
    order: 1,
    lessons: [lesson1, lesson2],
    quizzes: [quiz1],
    assignments: [assignment1]
)

let updatedCourse = course.addModule(module)
```

## Rate Limiting

The API implements rate limiting to ensure fair usage:

- **Free Tier**: 100 requests per hour
- **Premium Tier**: 1000 requests per hour
- **Enterprise Tier**: 10000 requests per hour

Rate limit headers are included in responses:

```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 875
X-RateLimit-Reset: 1642233600
```

## SDK Integration

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/educationai.git", from: "1.0.0")
]
```

### CocoaPods

```ruby
pod 'EducationAI', '~> 1.0'
```

### Carthage

```ruby
github "muhittincamdali/educationai" ~> 1.0
```

## Support

For API support and questions:

- **Documentation**: [docs.educationai.com](https://docs.educationai.com)
- **API Status**: [status.educationai.com](https://status.educationai.com)
- **Support Email**: api-support@educationai.com
- **Developer Community**: [community.educationai.com](https://community.educationai.com)

---

*This documentation is continuously updated. For the latest version, visit [docs.educationai.com](https://docs.educationai.com)*
