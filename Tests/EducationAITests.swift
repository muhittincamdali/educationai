//
//  EducationAITests.swift
//  EducationAI
//
//  Created by Muhittin Camdali on 2024
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import XCTest
@testable import EducationAI

final class EducationAITests: XCTestCase {
    
    // MARK: - User Tests
    
    func testUserInitialization() {
        let user = User(
            email: "test@example.com",
            name: "Test User",
            learningLevel: .intermediate,
            preferredSubjects: [.mathematics, .language],
            learningGoals: [.learnNewSkill]
        )
        
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.name, "Test User")
        XCTAssertEqual(user.learningLevel, .intermediate)
        XCTAssertEqual(user.preferredSubjects.count, 2)
        XCTAssertEqual(user.learningGoals.count, 1)
        XCTAssertEqual(user.streakCount, 0)
        XCTAssertEqual(user.totalPoints, 0)
    }
    
    func testUserLevelCalculation() {
        let user = User(
            email: "test@example.com",
            name: "Test User",
            totalPoints: 2500
        )
        
        XCTAssertEqual(user.level, 3)
        XCTAssertEqual(user.levelProgress, 0.5, accuracy: 0.01)
    }
    
    func testUserPointsAddition() {
        var user = User(
            email: "test@example.com",
            name: "Test User",
            totalPoints: 100
        )
        
        user.addPoints(50)
        XCTAssertEqual(user.totalPoints, 150)
    }
    
    func testUserStudyTimeAddition() {
        var user = User(
            email: "test@example.com",
            name: "Test User",
            totalStudyTime: 1800 // 30 dakika
        )
        
        user.addStudyTime(900) // 15 dakika
        XCTAssertEqual(user.totalStudyTime, 2700) // 45 dakika
        XCTAssertEqual(user.totalStudyTimeInHours, 0.75, accuracy: 0.01)
    }
    
    // MARK: - Course Tests
    
    func testCourseInitialization() {
        let course = Course(
            title: "Test Course",
            description: "Test Description",
            subject: .mathematics,
            level: .beginner,
            instructor: "Test Instructor",
            duration: 3600, // 1 saat
            lessonCount: 5,
            quizCount: 2,
            totalPoints: 300
        )
        
        XCTAssertEqual(course.title, "Test Course")
        XCTAssertEqual(course.subject, .mathematics)
        XCTAssertEqual(course.level, .beginner)
        XCTAssertEqual(course.durationInHours, 1.0, accuracy: 0.01)
        XCTAssertEqual(course.averageLessonDuration, 12.0, accuracy: 0.01) // 60/5
    }
    
    func testCourseRatingCalculation() {
        var course = Course(
            title: "Test Course",
            description: "Test Description",
            subject: .mathematics,
            level: .beginner,
            instructor: "Test Instructor",
            duration: 3600,
            lessonCount: 5,
            quizCount: 2,
            totalPoints: 300,
            rating: 4.0,
            reviewCount: 10
        )
        
        course.addReview(rating: 5.0)
        XCTAssertEqual(course.reviewCount, 11)
        XCTAssertEqual(course.rating, 4.09, accuracy: 0.01)
    }
    
    func testCourseEnrollmentIncrement() {
        var course = Course(
            title: "Test Course",
            description: "Test Description",
            subject: .mathematics,
            level: .beginner,
            instructor: "Test Instructor",
            duration: 3600,
            lessonCount: 5,
            quizCount: 2,
            totalPoints: 300,
            enrolledCount: 100
        )
        
        course.incrementEnrollment()
        XCTAssertEqual(course.enrolledCount, 101)
    }
    
    func testCoursePriceFormatting() {
        let freeCourse = Course(
            title: "Free Course",
            description: "Test Description",
            subject: .mathematics,
            level: .beginner,
            instructor: "Test Instructor",
            duration: 3600,
            lessonCount: 5,
            quizCount: 2,
            totalPoints: 300
        )
        
        let paidCourse = Course(
            title: "Paid Course",
            description: "Test Description",
            subject: .mathematics,
            level: .beginner,
            instructor: "Test Instructor",
            duration: 3600,
            lessonCount: 5,
            quizCount: 2,
            totalPoints: 300,
            isPremium: true,
            price: 99.99
        )
        
        XCTAssertEqual(freeCourse.formattedPrice, "Ücretsiz")
        XCTAssertTrue(paidCourse.formattedPrice.contains("₺"))
    }
    
    // MARK: - Design System Tests
    
    func testColorSystem() {
        XCTAssertNotNil(EducationAIColors.primary)
        XCTAssertNotNil(EducationAIColors.success)
        XCTAssertNotNil(EducationAIColors.warning)
        XCTAssertNotNil(EducationAIColors.error)
        XCTAssertNotNil(EducationAIColors.neutral)
    }
    
    func testTypographySystem() {
        let largeTitleFont = EducationAIDesignSystem.Typography.largeTitle()
        let bodyFont = EducationAIDesignSystem.Typography.body()
        
        XCTAssertEqual(largeTitleFont.pointSize, EducationAIDesignSystem.FontSize.largeTitle)
        XCTAssertEqual(bodyFont.pointSize, EducationAIDesignSystem.FontSize.body)
    }
    
    func testSpacingSystem() {
        XCTAssertEqual(EducationAIDesignSystem.Spacing.xs, 4)
        XCTAssertEqual(EducationAIDesignSystem.Spacing.sm, 8)
        XCTAssertEqual(EducationAIDesignSystem.Spacing.md, 16)
        XCTAssertEqual(EducationAIDesignSystem.Spacing.lg, 24)
        XCTAssertEqual(EducationAIDesignSystem.Spacing.xl, 32)
        XCTAssertEqual(EducationAIDesignSystem.Spacing.xxl, 48)
    }
    
    func testCornerRadiusSystem() {
        XCTAssertEqual(EducationAIDesignSystem.CornerRadius.small, 8)
        XCTAssertEqual(EducationAIDesignSystem.CornerRadius.medium, 12)
        XCTAssertEqual(EducationAIDesignSystem.CornerRadius.large, 16)
        XCTAssertEqual(EducationAIDesignSystem.CornerRadius.xlarge, 24)
    }
    
    // MARK: - Animation Tests
    
    func testAnimationDurations() {
        XCTAssertEqual(EducationAIAnimations.quick, 0.2)
        XCTAssertEqual(EducationAIAnimations.standard, 0.3)
        XCTAssertEqual(EducationAIAnimations.slow, 0.5)
        XCTAssertEqual(EducationAIAnimations.loading, 1.0)
    }
    
    func testAnimationCurves() {
        XCTAssertNotNil(EducationAIAnimations.easeInOut)
        XCTAssertNotNil(EducationAIAnimations.easeOut)
        XCTAssertNotNil(EducationAIAnimations.spring)
    }
    
    // MARK: - Performance Tests
    
    func testUserCreationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = User(
                    email: "test@example.com",
                    name: "Test User",
                    learningLevel: .intermediate,
                    preferredSubjects: [.mathematics, .language],
                    learningGoals: [.learnNewSkill]
                )
            }
        }
    }
    
    func testCourseCreationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = Course(
                    title: "Test Course",
                    description: "Test Description",
                    subject: .mathematics,
                    level: .beginner,
                    instructor: "Test Instructor",
                    duration: 3600,
                    lessonCount: 5,
                    quizCount: 2,
                    totalPoints: 300
                )
            }
        }
    }
    
    // MARK: - Sample Data Tests
    
    func testSampleCourses() {
        let sampleCourses = Course.sampleCourses
        
        XCTAssertEqual(sampleCourses.count, 3)
        XCTAssertEqual(sampleCourses[0].title, "Matematik Temelleri")
        XCTAssertEqual(sampleCourses[1].title, "İngilizce Konuşma")
        XCTAssertEqual(sampleCourses[2].title, "Python Programlama")
    }
    
    func testSampleCourseProperties() {
        let mathCourse = Course.sampleCourses[0]
        
        XCTAssertEqual(mathCourse.subject, .mathematics)
        XCTAssertEqual(mathCourse.level, .beginner)
        XCTAssertEqual(mathCourse.durationInHours, 2.0, accuracy: 0.01)
        XCTAssertEqual(mathCourse.lessonCount, 12)
        XCTAssertEqual(mathCourse.quizCount, 6)
        XCTAssertEqual(mathCourse.rating, 4.8, accuracy: 0.01)
        XCTAssertEqual(mathCourse.reviewCount, 156)
        XCTAssertEqual(mathCourse.enrolledCount, 1247)
    }
} 