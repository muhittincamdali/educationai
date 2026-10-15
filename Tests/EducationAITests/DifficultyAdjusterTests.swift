import Foundation
import Testing
@testable import EducationAI

struct DifficultyAdjusterTests {
    @Test func startsInTheMiddleAndRisesWhenAnswersAreTooEasy() throws {
        var adjuster = try DifficultyAdjuster(levels: 1...5, windowSize: 10, minimumAnswers: 5)
        #expect(adjuster.level == 3)
        let changes = (0..<5).map { _ in adjuster.record(correct: true) }
        #expect(changes == [.unchanged, .unchanged, .unchanged, .unchanged, .raised])
        #expect(adjuster.level == 4)
        #expect(adjuster.recentAnswers.isEmpty)
    }

    @Test func fallsWhenAnswersAreTooHard() throws {
        var adjuster = try DifficultyAdjuster(levels: 1...5, minimumAnswers: 4)
        for correct in [true, false, false] { #expect(adjuster.record(correct: correct) == .unchanged) }
        #expect(adjuster.record(correct: false) == .lowered)
        #expect(adjuster.level == 2)
    }

    @Test func staysWhenAccuracyIsInsideTheBand() throws {
        var adjuster = try DifficultyAdjuster(windowSize: 8, minimumAnswers: 8)
        for index in 0..<40 { adjuster.record(correct: index % 4 != 0) } // 3 of every 4 correct
        #expect(adjuster.level == 3)
        #expect(adjuster.accuracy == 0.75)
        #expect(adjuster.recentAnswers.count == 8)
    }

    @Test func staysAtTheEndsOfTheRange() throws {
        var top = try DifficultyAdjuster(levels: 1...3, startingLevel: 3, minimumAnswers: 1)
        for _ in 0..<20 { top.record(correct: true) }
        #expect(top.level == 3)
        var bottom = try DifficultyAdjuster(levels: 1...3, startingLevel: 1, minimumAnswers: 1)
        for _ in 0..<20 { bottom.record(correct: false) }
        #expect(bottom.level == 1)
    }

    @Test func widestRangeHasAMiddleAndDoesNotOverflowAtItsEnds() throws {
        // The exact middle of Int.min...Int.max is -0.5; it rounds down.
        #expect(try DifficultyAdjuster(levels: Int.min...Int.max).level == -1)
        #expect(try DifficultyAdjuster(levels: -4...4).level == 0)
        #expect(try DifficultyAdjuster(levels: 0...Int.max).level == Int.max / 2)
        var adjuster = try DifficultyAdjuster(levels: Int.min...Int.max, startingLevel: .max, minimumAnswers: 1)
        adjuster.record(correct: true)
        #expect(adjuster.level == .max)
    }

    @Test(arguments: [
        (1...5, nil, 0.7...0.85, 0, 1),
        (1...5, nil, 0.7...0.85, 1_001, 1),
        (1...5, nil, 0.7...0.85, 10, 0),
        (1...5, nil, 0.7...0.85, 10, 11),
        (1...5, 6, 0.7...0.85, 10, 5),
        (1...5, nil, -0.1...0.5, 10, 5),
        (1...5, nil, 0.5...1.5, 10, 5)
    ] as [(ClosedRange<Int>, Int?, ClosedRange<Double>, Int, Int)])
    func rejectsSettingsOutOfRange(levels: ClosedRange<Int>, start: Int?, target: ClosedRange<Double>, window: Int, minimum: Int) {
        #expect(throws: AdaptiveError.self) {
            try DifficultyAdjuster(levels: levels, startingLevel: start, targetAccuracy: target, windowSize: window, minimumAnswers: minimum)
        }
    }

    @Test func savedAdjusterResumesAndRejectsEditedValues() throws {
        var adjuster = try DifficultyAdjuster(windowSize: 6, minimumAnswers: 6)
        for correct in [true, false, true] { adjuster.record(correct: correct) }
        let data = try JSONEncoder().encode(adjuster)
        #expect(try JSONDecoder().decode(DifficultyAdjuster.self, from: data) == adjuster)

        var json = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
        json["level"] = 99
        #expect(throws: AdaptiveError.self) { try JSONDecoder().decode(DifficultyAdjuster.self, from: JSONSerialization.data(withJSONObject: json)) }
        json["level"] = 3
        json["recentAnswers"] = Array(repeating: true, count: 7)
        #expect(throws: AdaptiveError.self) { try JSONDecoder().decode(DifficultyAdjuster.self, from: JSONSerialization.data(withJSONObject: json)) }
    }
}
