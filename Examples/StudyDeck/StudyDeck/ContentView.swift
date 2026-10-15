import SwiftUI

enum AppTab: String, CaseIterable {
    case review, quiz, progress, deck
}

struct ContentView: View {
    @State private var tab: AppTab
    let launch: LaunchOptions

    init(initialTab: AppTab, launch: LaunchOptions) {
        _tab = State(initialValue: initialTab)
        self.launch = launch
    }

    var body: some View {
        TabView(selection: $tab) {
            ReviewView(startsWithAnswer: launch.showsAnswer)
                .tabItem { Label("Review", systemImage: "rectangle.stack") }
                .tag(AppTab.review)
            QuizView(answersWithTypo: launch.answersWithTypo)
                .tabItem { Label("Quiz", systemImage: "questionmark.bubble") }
                .tag(AppTab.quiz)
            StatsView()
                .tabItem { Label("Progress", systemImage: "chart.bar") }
                .tag(AppTab.progress)
            DeckListView()
                .tabItem { Label("Deck", systemImage: "list.bullet") }
                .tag(AppTab.deck)
        }
    }
}

/// Short interval labels such as "1m", "10m", "3d" or "2mo".
enum IntervalText {
    static func short(_ seconds: TimeInterval) -> String {
        let minutes = seconds / 60
        if minutes < 60 { return "\(max(1, Int(minutes.rounded())))m" }
        let hours = minutes / 60
        if hours < 24 { return "\(Int(hours.rounded()))h" }
        let days = hours / 24
        if days < 31 { return "\(Int(days.rounded()))d" }
        if days < 365 { return "\(Int((days / 30.4).rounded()))mo" }
        return String(format: "%.1fy", days / 365)
    }
}

/// A rounded card background used by every screen.
struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(.background.secondary, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

extension View {
    func cardBackground() -> some View { modifier(CardBackground()) }
}
