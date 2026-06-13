import Foundation
import SwiftAI

/// Adapts content difficulty in real-time based on learner performance using Neural Networks.
///
/// Uses a combination of sliding window statistics and a SwiftAI-powered 
/// neural network to predict the optimal difficulty level.
public final class AdaptiveDifficultyEngine: Sendable {

    // MARK: - Types
    
    private struct SubjectState {
        var buffer: [StudyEvent] = []
        var currentDifficulty: DifficultyLevel = .medium
    }

    // MARK: - Properties

    private let state = Locked<[UUID: SubjectState]>([:])
    private let neuralPredictor = Locked<NeuralNetwork?>(nil)
    
    private let _windowSize = Locked<Int>(20)
    private let _targetAccuracy = Locked<ClosedRange<Double>>(0.70...0.85)
    
    public var windowSize: Int {
        get { _windowSize.withLock { $0 } }
        set { _windowSize.withLock { $0 = newValue } }
    }
    
    public var targetAccuracy: ClosedRange<Double> {
        get { _targetAccuracy.withLock { $0 } }
        set { _targetAccuracy.withLock { $0 = newValue } }
    }

    /// How aggressively difficulty changes (0 = sluggish, 1 = aggressive).
    public let sensitivity: Double

    // MARK: - Initialization

    public init(sensitivity: Double = 0.5) {
        self.sensitivity = max(0, min(1, sensitivity))
        setupNeuralNetwork()
    }

    // MARK: - Public API

    /// Feed a new study event into the engine.
    public func ingest(event: StudyEvent) {
        state.withLock { dict in
            var subjectState = dict[event.subjectID, default: SubjectState()]
            subjectState.buffer.append(event)
            if subjectState.buffer.count > windowSize {
                subjectState.buffer.removeFirst(subjectState.buffer.count - windowSize)
            }
            
            // Use neural network for prediction if available, fallback to legacy math
            if let nn = neuralPredictor.withLock({ $0 }) {
                subjectState.currentDifficulty = predictDifficulty(nn: nn, buffer: subjectState.buffer)
            } else {
                subjectState.currentDifficulty = fallbackComputeDifficulty(buffer: subjectState.buffer, current: subjectState.currentDifficulty)
            }
            
            dict[event.subjectID] = subjectState
        }
    }

    /// Get the recommended difficulty for a subject.
    public func recommendedDifficulty(for subjectID: UUID) -> DifficultyLevel {
        state.withLock { $0[subjectID]?.currentDifficulty ?? .medium }
    }

    /// Get detailed performance metrics for a subject.
    public func performanceMetrics(for subjectID: UUID) -> PerformanceSnapshot {
        state.withLock { dict in
            guard let subjectState = dict[subjectID], !subjectState.buffer.isEmpty else {
                return PerformanceSnapshot(
                    accuracy: 0,
                    averageResponseTime: 0,
                    eventCount: 0,
                    difficulty: .medium,
                    trend: .stable
                )
            }

            let buffer = subjectState.buffer
            let accuracy = computeAccuracy(buffer)
            let avgTime = computeAverageResponseTime(buffer)
            let trend = computeTrend(buffer)

            return PerformanceSnapshot(
                accuracy: accuracy,
                averageResponseTime: avgTime,
                eventCount: buffer.count,
                difficulty: subjectState.currentDifficulty,
                trend: trend
            )
        }
    }

    // MARK: - Private Logic

    private func setupNeuralNetwork() {
        let nn = NeuralNetwork()
        // Simple architecture: [Accuracy, AvgResponseTime, Trend] -> [Difficulty Score]
        nn.dense(3, 16, activation: .relu)
        nn.dense(16, 4, activation: .softmax) // 4 output neurons for 4 difficulty levels
        neuralPredictor.withLock { $0 = nn }
    }

    private func predictDifficulty(nn: NeuralNetwork, buffer: [StudyEvent]) -> DifficultyLevel {
        let acc = Float(computeAccuracy(buffer))
        let time = Float(computeAverageResponseTime(buffer) / 60.0) // Normalized to minutes
        let trend: Float = {
            switch computeTrend(buffer) {
            case .improving: return 1.0
            case .stable:    return 0.5
            case .declining: return 0.0
            }
        }()
        
        let input = Tensor<Float>(shape: [1, 3], data: [acc, time, trend])
        let prediction = nn.predict(input)
        let levelIndex = prediction.argmax()
        
        return DifficultyLevel.allCases[min(levelIndex, DifficultyLevel.allCases.count - 1)]
    }

    private func fallbackComputeDifficulty(buffer: [StudyEvent], current: DifficultyLevel) -> DifficultyLevel {
        let accuracy = computeAccuracy(buffer)
        if accuracy > targetAccuracy.upperBound {
            return stepUp(from: current)
        } else if accuracy < targetAccuracy.lowerBound {
            return stepDown(from: current)
        }
        return current
    }

    private func computeAccuracy(_ events: [StudyEvent]) -> Double {
        guard !events.isEmpty else { return 0 }
        let correct = events.filter { $0.rating.isCorrect }.count
        return Double(correct) / Double(events.count)
    }

    private func computeAverageResponseTime(_ events: [StudyEvent]) -> TimeInterval {
        guard !events.isEmpty else { return 0 }
        let total = events.reduce(0.0) { $0 + $1.responseTime }
        return total / Double(events.count)
    }

    private func computeTrend(_ events: [StudyEvent]) -> PerformanceTrend {
        guard events.count >= 6 else { return .stable }
        let half = events.count / 2
        let first = Array(events[..<half])
        let second = Array(events[half...])
        let accFirst = computeAccuracy(first)
        let accSecond = computeAccuracy(second)
        let delta = accSecond - accFirst
        if delta > 0.1 { return .improving }
        if delta < -0.1 { return .declining }
        return .stable
    }

    private func stepUp(from level: DifficultyLevel) -> DifficultyLevel {
        switch level {
        case .easy:   return .medium
        case .medium: return .hard
        case .hard:   return .expert
        case .expert: return .expert
        }
    }

    private func stepDown(from level: DifficultyLevel) -> DifficultyLevel {
        switch level {
        case .easy:   return .easy
        case .medium: return .easy
        case .hard:   return .medium
        case .expert: return .hard
        }
    }
}

// MARK: - Supporting Types

public struct PerformanceSnapshot: Sendable {
    public let accuracy: Double
    public let averageResponseTime: TimeInterval
    public let eventCount: Int
    public let difficulty: DifficultyLevel
    public let trend: PerformanceTrend
}

public enum PerformanceTrend: String, Codable, Sendable {
    case improving
    case stable
    case declining
}
