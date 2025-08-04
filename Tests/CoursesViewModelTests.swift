//
//  CoursesViewModelTests.swift
//  EducationAI
//
//  Created by Muhittin Camdali on 2024
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import XCTest
import Combine
@testable import EducationAI

class CoursesViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    var viewModel: CoursesViewModel!
    var mockCourseService: MockCourseService!
    var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        mockCourseService = MockCourseService()
        viewModel = CoursesViewModel(courseService: mockCourseService)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        mockCourseService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testLoadCoursesSuccess() {
        // Given
        let expectedCourses = Course.mockCourses
        mockCourseService.mockCourses = expectedCourses
        
        // When
        let expectation = XCTestExpectation(description: "Courses loaded successfully")
        
        viewModel.$courses
            .dropFirst() // Skip initial empty state
            .sink { courses in
                XCTAssertEqual(courses.count, expectedCourses.count)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.loadCourses()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }
    
    func testLoadCoursesFailure() {
        // Given
        let expectedError = NetworkError.serverError("Test error")
        mockCourseService.shouldFail = true
        mockCourseService.mockError = expectedError
        
        // When
        let expectation = XCTestExpectation(description: "Courses loading failed")
        
        viewModel.$error
            .dropFirst() // Skip initial nil state
            .sink { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.loadCourses()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.courses.isEmpty)
    }
    
    func testGetCourseById() {
        // Given
        let courses = Course.mockCourses
        viewModel.courses = courses
        let targetId = courses.first!.id
        
        // When
        let result = viewModel.getCourse(byId: targetId)
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, targetId)
    }
    
    func testGetCourseByIdNotFound() {
        // Given
        let courses = Course.mockCourses
        viewModel.courses = courses
        let nonExistentId = UUID()
        
        // When
        let result = viewModel.getCourse(byId: nonExistentId)
        
        // Then
        XCTAssertNil(result)
    }
    
    func testGetCoursesBySubject() {
        // Given
        let courses = Course.mockCourses
        viewModel.courses = courses
        let targetSubject = "Mathematics"
        
        // When
        let result = viewModel.getCourses(bySubject: targetSubject)
        
        // Then
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.allSatisfy { $0.subject == targetSubject })
    }
    
    func testGetCoursesByDifficulty() {
        // Given
        let courses = Course.mockCourses
        viewModel.courses = courses
        let targetDifficulty = CourseDifficulty.beginner
        
        // When
        let result = viewModel.getCourses(byDifficulty: targetDifficulty)
        
        // Then
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.allSatisfy { $0.difficulty == targetDifficulty })
    }
    
    func testGetRecommendedCourses() {
        // Given
        let courses = Course.mockCourses
        viewModel.courses = courses
        
        // When
        let result = viewModel.getRecommendedCourses()
        
        // Then
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.allSatisfy { !$0.isCompleted })
    }
    
    func testGetCompletedCourses() {
        // Given
        let courses = Course.mockCourses
        viewModel.courses = courses
        
        // When
        let result = viewModel.getCompletedCourses()
        
        // Then
        XCTAssertTrue(result.allSatisfy { $0.isCompleted })
    }
    
    func testGetInProgressCourses() {
        // Given
        let courses = Course.mockCourses
        viewModel.courses = courses
        
        // When
        let result = viewModel.getInProgressCourses()
        
        // Then
        XCTAssertTrue(result.allSatisfy { course in
            course.completedLessonCount > 0 && !course.isCompleted
        })
    }
    
    func testGetNewCourses() {
        // Given
        let courses = Course.mockCourses
        viewModel.courses = courses
        
        // When
        let result = viewModel.getNewCourses()
        
        // Then
        let calendar = Calendar.current
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        XCTAssertTrue(result.allSatisfy { $0.createdAt >= oneWeekAgo })
    }
    
    func testSearchCourses() {
        // Given
        let courses = Course.mockCourses
        viewModel.courses = courses
        let searchQuery = "Mathematics"
        
        // When
        let result = viewModel.searchCourses(query: searchQuery)
        
        // Then
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.allSatisfy { course in
            course.title.localizedCaseInsensitiveContains(searchQuery) ||
            course.description.localizedCaseInsensitiveContains(searchQuery) ||
            course.subject.localizedCaseInsensitiveContains(searchQuery)
        })
    }
    
    func testSearchCoursesEmptyQuery() {
        // Given
        let courses = Course.mockCourses
        viewModel.courses = courses
        let searchQuery = ""
        
        // When
        let result = viewModel.searchCourses(query: searchQuery)
        
        // Then
        XCTAssertEqual(result.count, courses.count)
    }
    
    func testFilterCourses() {
        // Given
        let courses = Course.mockCourses
        viewModel.courses = courses
        let subjects = ["Mathematics", "Physics"]
        let difficulties = [CourseDifficulty.beginner, CourseDifficulty.intermediate]
        
        // When
        let result = viewModel.filterCourses(by: subjects, difficulties: difficulties)
        
        // Then
        XCTAssertTrue(result.allSatisfy { course in
            subjects.contains(course.subject) && difficulties.contains(course.difficulty)
        })
    }
    
    func testSortCoursesByTitle() {
        // Given
        let courses = Course.mockCourses
        viewModel.courses = courses
        
        // When
        let result = viewModel.sortCourses(by: .title)
        
        // Then
        XCTAssertEqual(result.count, courses.count)
        for i in 0..<(result.count - 1) {
            XCTAssertLessThanOrEqual(result[i].title, result[i + 1].title)
        }
    }
    
    func testSortCoursesByProgress() {
        // Given
        let courses = Course.mockCourses
        viewModel.courses = courses
        
        // When
        let result = viewModel.sortCourses(by: .progress)
        
        // Then
        XCTAssertEqual(result.count, courses.count)
        for i in 0..<(result.count - 1) {
            let progress1 = result[i].lessonCount > 0 ? Double(result[i].completedLessonCount) / Double(result[i].lessonCount) : 0
            let progress2 = result[i + 1].lessonCount > 0 ? Double(result[i + 1].completedLessonCount) / Double(result[i + 1].lessonCount) : 0
            XCTAssertGreaterThanOrEqual(progress1, progress2)
        }
    }
    
    func testGetCourseStatistics() {
        // Given
        let courses = Course.mockCourses
        viewModel.courses = courses
        
        // When
        let statistics = viewModel.getCourseStatistics()
        
        // Then
        XCTAssertEqual(statistics.totalCourses, courses.count)
        XCTAssertGreaterThanOrEqual(statistics.completedCourses, 0)
        XCTAssertGreaterThanOrEqual(statistics.inProgressCourses, 0)
        XCTAssertGreaterThanOrEqual(statistics.newCourses, 0)
        XCTAssertGreaterThanOrEqual(statistics.totalLessons, 0)
        XCTAssertGreaterThanOrEqual(statistics.completedLessons, 0)
        XCTAssertGreaterThanOrEqual(statistics.averageProgress, 0.0)
        XCTAssertLessThanOrEqual(statistics.averageProgress, 1.0)
        XCTAssertFalse(statistics.subjectDistribution.isEmpty)
        XCTAssertFalse(statistics.difficultyDistribution.isEmpty)
    }
    
    func testRefreshCourses() {
        // Given
        let expectation = XCTestExpectation(description: "Courses refreshed")
        mockCourseService.mockCourses = Course.mockCourses
        
        viewModel.$courses
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewModel.refreshCourses()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock Course Service

class MockCourseService: CourseServiceProtocol {
    var mockCourses: [Course] = []
    var shouldFail = false
    var mockError: Error = NetworkError.unknown
    
    func fetchCourses() -> AnyPublisher<[Course], Error> {
        if shouldFail {
            return Fail(error: mockError)
                .eraseToAnyPublisher()
        } else {
            return Just(mockCourses)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchCourse(byId id: UUID) -> AnyPublisher<Course, Error> {
        if shouldFail {
            return Fail(error: mockError)
                .eraseToAnyPublisher()
        } else {
            if let course = mockCourses.first(where: { $0.id == id }) {
                return Just(course)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: NetworkError.notFound)
                    .eraseToAnyPublisher()
            }
        }
    }
    
    func updateCourse(_ course: Course) -> AnyPublisher<Course, Error> {
        if shouldFail {
            return Fail(error: mockError)
                .eraseToAnyPublisher()
        } else {
            return Just(course)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func deleteCourse(byId id: UUID) -> AnyPublisher<Void, Error> {
        if shouldFail {
            return Fail(error: mockError)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
} 