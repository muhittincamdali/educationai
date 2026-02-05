import Foundation

/// Tracks learning progress across subjects and over time.
///
/// Persists progress data using ``LocalStorage`` so it survives
/// app restarts. All processing happens on-device.
///
/// ```swift
/// let tracker = ProgressTracker(storage: storage)
/// tracker.record(event: studyEvent)
/// let progress = tracker.progress
/// print("Overall mastery:", progress.globalMastery)
/// ```
public final class ProgressTracker: @unchecked Sendable {

    // MARK: - Properties

    private let storage: LocalStorage
    private let storageKey = "educationai.progress"
    private let lock = NSLock()

    /// Current learning progress (thread-safe read).
    public var progress: LearningProgress {
        lock.lock()
        defer { lock.unlock() }
        return _progress
    }

    private var _progress: LearningProgress

    // MARK: - Initialization

    public init(storage: LocalStorage) {
        self.storage = storage
        if let saved: LearningProgress = storage.load(forKey: "educationai.progress") {
            self._progress = saved
        } else {
            self._progress = LearningProgress()
        }
    }

    // MARK: - Recording

    /// Record a single study event.
    public func record(event: StudyEvent) {
        lock.lock()
        defer { lock.unlock() }

        // Update recent events (keep last 500)
        _progress.recentEvents.insert(event, at: 0)
        if _progress.recentEvents.count > 500 {
            _progress.recentEvents = Array(_progress.recentEvents.prefix(500))
        }

        _progress.totalReviews += 1
        _progress.totalStudyTime += event.responseTime

        // Update subject-level progress
        var subjectProgress = _progress.subjects[event.subjectID] ?? SubjectProgress(subjectID: event.subjectID)
        subjectProgress.reviewedCards += 1
        subjectProgress.studyTime += event.responseTime
        subjectProgress.lastStudied = event.timestamp

        // Running accuracy
        let subjectEvents = _progress.recentEvents.filter { $0.subjectID == event.subjectID }
        let correct = subjectEvents.filter { $0.rating.isCorrect }.count
        let total = subjectEvents.count
        subjectProgress.accuracy = total > 0 ? Double(correct) / Double(total) : 0

        _progress.subjects[event.subjectID] = subjectProgress

        persist()
    }

    /// Update card mastery counts for a subject.
    ///
    /// Call this when a card's interval crosses the mastery threshold (21+ days).
    public func updateMastery(subjectID: UUID, totalCards: Int, masteredCards: Int) {
        lock.lock()
        defer { lock.unlock() }

        var sp = _progress.subjects[subjectID] ?? SubjectProgress(subjectID: subjectID)
        sp.totalCards = totalCards
        sp.masteredCards = masteredCards
        _progress.subjects[subjectID] = sp

        persist()
    }

    /// Get progress for a specific subject.
    public func subjectProgress(for subjectID: UUID) -> SubjectProgress? {
        lock.lock()
        defer { lock.unlock() }
        return _progress.subjects[subjectID]
    }

    /// Get study events for a specific date range.
    public func events(from start: Date, to end: Date) -> [StudyEvent] {
        lock.lock()
        defer { lock.unlock() }
        return _progress.recentEvents.filter { $0.timestamp >= start && $0.timestamp <= end }
    }

    /// Get study events for today.
    public func todayEvents() -> [StudyEvent] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        return events(from: startOfDay, to: endOfDay)
    }

    /// Number of unique days studied in the last N days.
    public func studyDays(inLast days: Int) -> Int {
        let calendar = Calendar.current
        let cutoff = calendar.date(byAdding: .day, value: -days, to: Date())!
        let recentDates = progress.recentEvents
            .filter { $0.timestamp >= cutoff }
            .map { calendar.startOfDay(for: $0.timestamp) }
        return Set(recentDates).count
    }

    /// Reset all progress data.
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        _progress = LearningProgress()
        persist()
    }

    // MARK: - Private

    private func persist() {
        storage.save(_progress, forKey: storageKey)
    }
}
