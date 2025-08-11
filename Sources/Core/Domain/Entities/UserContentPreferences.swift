import Foundation

public struct UserContentPreferences: Codable {
    public let preferredFormats: [ContentFormat]
    public let difficultyPreference: DifficultyPreference
    public let contentLengthPreference: ContentLengthPreference
    public let interactiveElementPreference: InteractiveElementPreference
    
    public init(
        preferredFormats: [ContentFormat] = [],
        difficultyPreference: DifficultyPreference = .current,
        contentLengthPreference: ContentLengthPreference = .medium,
        interactiveElementPreference: InteractiveElementPreference = .moderate
    ) {
        self.preferredFormats = preferredFormats
        self.difficultyPreference = difficultyPreference
        self.contentLengthPreference = contentLengthPreference
        self.interactiveElementPreference = interactiveElementPreference
    }
}
