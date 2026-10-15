import Foundation

/// Totals over a set of review logs: how many reviews, which ratings, and how much was retained.
///
/// ```swift
/// let stats = ReviewStatistics(logs: todaysLogs)
/// if let retention = stats.retention { print("Retention: \(retention.formatted(.percent))") }
/// ```
public struct ReviewStatistics: Sendable, Hashable {
    /// The number of reviews.
    public let reviewCount: Int
    /// The number of reviews with each rating. Ratings never given are absent.
    public let ratingCounts: [Rating: Int]
    /// The share of reviews of learned items (review phase) that were remembered, from 0 to 1;
    /// `nil` when there were none. This is the "true retention" that ``FSRSScheduler/desiredRetention``
    /// aims for.
    public let retention: Double?
    /// The mean answer time in seconds over the logs that have a duration; `nil` when none has.
    /// Durations that are negative or not finite are ignored.
    public let averageDuration: TimeInterval?

    /// Computes the totals for `logs`.
    public init(logs: some Sequence<ReviewLog>) {
        var reviewCount = 0
        var ratingCounts: [Rating: Int] = [:]
        var matureReviews = 0
        var matureRecalls = 0
        var durationCount = 0
        var meanDuration = 0.0
        for log in logs {
            reviewCount += 1
            ratingCounts[log.rating, default: 0] += 1
            if log.phase == .review {
                matureReviews += 1
                if log.rating.isSuccessfulRecall { matureRecalls += 1 }
            }
            if let duration = log.duration, duration.isFinite, duration >= 0 {
                durationCount += 1
                // A running mean cannot overflow to infinity the way a sum of large values can.
                meanDuration += (duration - meanDuration) / Double(durationCount)
            }
        }
        self.reviewCount = reviewCount
        self.ratingCounts = ratingCounts
        self.retention = matureReviews > 0 ? Double(matureRecalls) / Double(matureReviews) : nil
        self.averageDuration = durationCount > 0 ? meanDuration : nil
    }
}
