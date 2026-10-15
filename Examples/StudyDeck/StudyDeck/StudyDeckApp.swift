import SwiftUI

@main
struct StudyDeckApp: App {
    @State private var store: DeckStore
    private let launch = LaunchOptions(arguments: ProcessInfo.processInfo.arguments)

    init() {
        _store = State(initialValue: launch.demoDate.map { DeckStore(demoEndingAt: $0) } ?? DeckStore())
    }

    var body: some Scene {
        WindowGroup {
            ContentView(initialTab: launch.tab, launch: launch)
                .environment(store)
                .tint(.studyBlue)
        }
        #if os(macOS)
        .defaultSize(width: 460, height: 760)
        #endif
    }
}

/// Launch arguments that open a screen in a known state, used by scripts/capture-screens.sh.
struct LaunchOptions {
    /// `-demo`: three weeks of simulated study ending at 09:41 on 15 October 2026.
    var demoDate: Date?
    /// `-tab review|quiz|progress|deck`
    var tab: AppTab = .review
    /// `-show-answer`: the review screen starts with the answer shown.
    var showsAnswer = false
    /// `-quiz-typo`: the quiz screen answers its first question with one letter missing.
    var answersWithTypo = false

    init(arguments: [String]) {
        func value(after flag: String) -> String? {
            guard let index = arguments.firstIndex(of: flag), arguments.indices.contains(index + 1) else { return nil }
            return arguments[index + 1]
        }
        if arguments.contains("-demo") {
            demoDate = Calendar.current.date(from: DateComponents(year: 2026, month: 10, day: 15, hour: 9, minute: 41))
        }
        tab = value(after: "-tab").flatMap(AppTab.init(rawValue:)) ?? .review
        showsAnswer = arguments.contains("-show-answer")
        answersWithTypo = arguments.contains("-quiz-typo")
    }
}

extension Color {
    /// The accent color of the example app.
    static let studyBlue = Color(red: 0, green: 0x71 / 255, blue: 0xE3 / 255)
}
