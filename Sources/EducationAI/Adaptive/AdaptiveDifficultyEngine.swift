import Foundation

/// Adapts content difficulty in real-time based on learner performance.
///
/// Uses a sliding window of recent study events to compute an
/// optimal difficulty level that keeps the learner in a flow state —
/// challenged but not overwhelmed.
///
/// ```swift
/// let engine = AdaptiveDifficultyEngine()
/// engine.ingest(event: studyEvent)
/// let recommended = engine.recommendedDifficulty(for: subjectID)
/// ```
public final class AdaptiveDifficultyEngine: @unchecked Sendable {

    // MARK: - Configuration

    /// How aggressively difficulty changes (0 = sluggish, 1 = aggressive).
    public let sensitivity: Double

    /// Number of recent events to consider.
    public var windowSize: Int = 20

    /// Target accuracy zone — difficulty adjusts to keep learner here.
    public var targetAccuracy: ClosedRange<Double> = 0.70...0.85

    // MARK: - State

    /// Per-subject event buffers.
    private var eventBuffers: [UUID: [StudyEvent]] = [:]

    /// Per-subject current difficulty.
    private var currentDifficulties: [UUID: DifficultyLevel] = [:]

    private let lock = NSLock()

    // MARK: - Initialization

    public init(sensitivity: Double = 0.5) {
        self.sensitivity = max(0, min(1, sensitivity))
    }

    // MARK: - Public API

    /// Feed a new study event into the engine.
    public func ingest(event: StudyEvent) {
        lock.lock()
        defer { lock.unlock() }

        var buffer = eventBuffers[event.subjectID, default: []]
        buffer.append(event)
        if buffer.count > windowSize {
            buffer.removeFirst(buffer.count - windowSize)
        }
        eventBuffers[event.subjectID] = buffer

        // Recompute difficulty
        let newDifficulty = computeDifficulty(for: event.subjectID, buffer: buffer)
        currentDifficulties[event.subjectID] = newDifficulty
    }

    /// Get the recommended difficulty for a subject.
    public func recommendedDifficulty(for subjectID: UUID) -> DifficultyLevel {
        lock.lock()
        defer { lock.unlock() }
        return currentDifficulties[subjectID] ?? .medium
    }

    /// Get detailed performance metrics for a subject.
    public func performanceMetrics(for subjectID: UUID) -> PerformanceSnapshot {
        lock.lock()
        defer { lock.unlock() }

        guard let buffer = eventBuffers[subjectID], !buffer.isEmpty else {
            return PerformanceSnapshot(
                accuracy: 0,
                averageResponseTime: 0,
                eventCount: 0,
                difficulty: .medium,
                trend: .stable
            )
        }

        let accuracy = computeAccuracy(buffer)
        let avgTime = computeAverageResponseTime(buffer)
        let difficulty = currentDifficulties[subjectID] ?? .medium
        let trend = computeTrend(buffer)

        return PerformanceSnapshot(
            accuracy: accuracy,
            averageResponseTime: avgTime,
            eventCount: buffer.count,
            difficulty: difficulty,
            trend: trend
        )
    }

    /// Reset state for a specific subject.
    public func reset(for subjectID: UUID) {
        lock.lock()
        defer { lock.unlock() }
        eventBuffers.removeValue(forKey: subjectID)
        currentDifficulties.removeValue(forKey: subjectID)
    }

    /// Reset all state.
    public func resetAll() {
        lock.lock()
        defer { lock.unlock() }
        eventBuffers.removeAll()
        currentDifficulties.removeAll()
    }

    // MARK: - Private Logic

    private func computeDifficulty(for subjectID: UUID, buffer: [StudyEvent]) -> DifficultyLevel {
        let accuracy = computeAccuracy(buffer)
        let current = currentDifficulties[subjectID] ?? .medium

        if accuracy > targetAccuracy.upperBound {
            // Too easy — step up if sensitivity allows
            return stepUp(from: current)
        } else if accuracy < targetAccuracy.lowerBound {
            // Too hard — step down
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

/// Snapshot of current performance for a subject.
public struct PerformanceSnapshot: Sendable {
    /// Accuracy in the current sliding window (0-1).
    public let accuracy: Double
    /// Average response time in seconds.
    public let averageResponseTime: TimeInterval
    /// Number of events in the window.
    public let eventCount: Int
    /// Current recommended difficulty.
    public let difficulty: DifficultyLevel
    /// Performance direction.
    public let trend: PerformanceTrend
}

/// Direction of performance change.
public enum PerformanceTrend: String, Codable, Sendable {
    case improving
    case stable
    case declining
}
