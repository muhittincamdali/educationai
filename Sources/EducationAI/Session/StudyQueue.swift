import Foundation

/// Picks the items to study now from a collection, in the order to show them.
///
/// ```swift
/// let queue = StudyQueue.items(from: cards, newLimit: 10) { $0.review }
/// ```
///
/// The order is: items in a learning or relearning step that are due (earliest first), then due
/// review items (most overdue first, at most `reviewLimit`), then new items in the order of the
/// collection (at most `newLimit`). Items whose due date is not a finite time are left out.
public enum StudyQueue {
    /// The items to study at `date`.
    ///
    /// - Parameters:
    ///   - items: All items, for example the cards of a deck.
    ///   - date: The time to plan for. Defaults to now.
    ///   - newLimit: The most new items to include. Negative values count as 0.
    ///   - reviewLimit: The most review items to include. Negative values count as 0. Items in a
    ///     learning or relearning step are always included, as they are part of a session in progress.
    ///   - state: Returns an item's review state.
    public static func items<Item>(
        from items: some Sequence<Item>,
        at date: Date = .now,
        newLimit: Int = 20,
        reviewLimit: Int = 200,
        state: (Item) -> ReviewState
    ) -> [Item] {
        var inSteps: [(item: Item, due: Date)] = []
        var reviews: [(item: Item, due: Date)] = []
        var fresh: [Item] = []
        for item in items {
            let itemState = state(item)
            guard SafeNumerics.isFinite(itemState.due), itemState.due <= date else { continue }
            if itemState.isNew {
                fresh.append(item)
            } else if itemState.phase == .review {
                reviews.append((item, itemState.due))
            } else {
                inSteps.append((item, itemState.due))
            }
        }
        inSteps.sort { $0.due < $1.due }
        reviews.sort { $0.due < $1.due }
        return inSteps.map(\.item)
            + reviews.prefix(max(0, reviewLimit)).map(\.item)
            + fresh.prefix(max(0, newLimit))
    }

    /// The states to study at `date`; see ``items(from:at:newLimit:reviewLimit:state:)``.
    public static func states(
        from states: some Sequence<ReviewState>,
        at date: Date = .now,
        newLimit: Int = 20,
        reviewLimit: Int = 200
    ) -> [ReviewState] {
        items(from: states, at: date, newLimit: newLimit, reviewLimit: reviewLimit) { $0 }
    }
}
