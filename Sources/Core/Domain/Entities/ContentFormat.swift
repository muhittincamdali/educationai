import Foundation

public enum ContentFormat: String, Codable, CaseIterable {
    case text = "text"
    case video = "video"
    case audio = "audio"
    case interactive = "interactive"
    case quiz = "quiz"
    case exercise = "exercise"
    case simulation = "simulation"
    case game = "game"
}
