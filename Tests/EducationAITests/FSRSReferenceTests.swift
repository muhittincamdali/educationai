import Foundation
import Testing
@testable import EducationAI

/// Compares the scheduler with py-fsrs 6.3.2 on the cases in Fixtures/fsrs-reference.json,
/// written by scripts/generate-fsrs-fixtures.py: 8 configurations, 25 review histories each.
struct FSRSReferenceTests {
    struct Fixture: Decodable {
        struct Configuration: Decodable {
            let name: String
            let weights: [Double]
            let desiredRetention: Double
            let learningSteps: [Double]
            let relearningSteps: [Double]
            let maximumInterval: Int
            let cases: [Case]
        }
        struct Case: Decodable { let reviews: [Review] }
        struct Review: Decodable {
            let rating: Int
            let reviewedAt: Double
            let expected: Expected
        }
        struct Expected: Decodable {
            let phase: String
            let step: Int?
            let stability: Double
            let difficulty: Double
            let due: Double
            let lastReview: Double
            let retrievabilityOneDayLater: Double
        }
        let generator: String
        let configurations: [Configuration]
    }

    static let fixture: Fixture = {
        let url = Bundle.module.url(forResource: "fsrs-reference", withExtension: "json", subdirectory: "Fixtures")!
        return try! JSONDecoder().decode(Fixture.self, from: Data(contentsOf: url))
    }()

    static var configurationNames: [String] { fixture.configurations.map(\.name) }

    @Test func fixtureComesFromTheReferenceImplementation() {
        #expect(Self.fixture.generator == "py-fsrs 6.3.2")
        #expect(Self.fixture.configurations.count == 8)
        #expect(Self.fixture.configurations.allSatisfy { $0.cases.count == 25 })
    }

    @Test(arguments: configurationNames)
    func matchesReferenceImplementation(configurationName: String) throws {
        let configuration = try #require(Self.fixture.configurations.first { $0.name == configurationName })
        let scheduler = try FSRSScheduler(
            weights: configuration.weights,
            desiredRetention: configuration.desiredRetention,
            learningSteps: configuration.learningSteps,
            relearningSteps: configuration.relearningSteps,
            maximumInterval: configuration.maximumInterval,
            fuzzEnabled: false
        )
        for (caseIndex, reviewCase) in configuration.cases.enumerated() {
            var state = ReviewState(due: Date(timeIntervalSince1970: reviewCase.reviews[0].reviewedAt))
            for (reviewIndex, review) in reviewCase.reviews.enumerated() {
                let rating = try #require(Rating(rawValue: review.rating))
                let date = Date(timeIntervalSince1970: review.reviewedAt)
                state = try scheduler.review(state, rating: rating, at: date).state
                let expected = review.expected
                let where_ = "case \(caseIndex), review \(reviewIndex)"
                #expect(state.phase.rawValue == expected.phase, "\(where_)")
                #expect(state.step == expected.step, "\(where_)")
                #expect(isClose(state.stability, expected.stability), "\(where_): stability \(state.stability ?? .nan) vs \(expected.stability)")
                #expect(isClose(state.difficulty, expected.difficulty), "\(where_): difficulty \(state.difficulty ?? .nan) vs \(expected.difficulty)")
                #expect(abs(state.due.timeIntervalSince1970 - expected.due) < 0.001, "\(where_): due")
                #expect(state.lastReview?.timeIntervalSince1970 == expected.lastReview, "\(where_)")
                let oneDayLater = date.addingTimeInterval(86_400)
                #expect(isClose(scheduler.retrievability(of: state, at: oneDayLater), expected.retrievabilityOneDayLater), "\(where_)")
            }
        }
    }

    private func isClose(_ actual: Double?, _ expected: Double) -> Bool {
        guard let actual else { return false }
        return abs(actual - expected) <= 1e-9 * max(1, abs(expected))
    }
}
