import Foundation

/// An educational subject or topic grouping.
public struct Subject: Identifiable, Codable, Sendable, Hashable {

    /// Unique identifier.
    public let id: UUID

    /// Human-readable name (e.g. "Algebra", "Spanish Vocabulary").
    public var name: String

    /// Short description of the subject.
    public var description: String

    /// Category this subject belongs to.
    public var category: SubjectCategory

    /// Optional icon name (SF Symbol or custom asset).
    public var iconName: String?

    /// Tags for search / filtering.
    public var tags: [String]

    /// Creation timestamp.
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        category: SubjectCategory = .general,
        iconName: String? = nil,
        tags: [String] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.iconName = iconName
        self.tags = tags
        self.createdAt = createdAt
    }
}

// MARK: - Subject Category

/// High-level subject category.
public enum SubjectCategory: String, Codable, Sendable, CaseIterable {
    case mathematics
    case science
    case language
    case history
    case geography
    case arts
    case music
    case technology
    case programming
    case business
    case health
    case literature
    case philosophy
    case general

    /// Human-readable display name.
    public var displayName: String {
        switch self {
        case .mathematics:  return "Mathematics"
        case .science:      return "Science"
        case .language:     return "Language"
        case .history:      return "History"
        case .geography:    return "Geography"
        case .arts:         return "Arts"
        case .music:        return "Music"
        case .technology:   return "Technology"
        case .programming:  return "Programming"
        case .business:     return "Business"
        case .health:       return "Health"
        case .literature:   return "Literature"
        case .philosophy:   return "Philosophy"
        case .general:      return "General"
        }
    }

    /// SF Symbol name for each category.
    public var systemImage: String {
        switch self {
        case .mathematics:  return "function"
        case .science:      return "atom"
        case .language:     return "textformat"
        case .history:      return "book"
        case .geography:    return "globe"
        case .arts:         return "paintbrush"
        case .music:        return "music.note"
        case .technology:   return "desktopcomputer"
        case .programming:  return "chevron.left.forwardslash.chevron.right"
        case .business:     return "briefcase"
        case .health:       return "heart"
        case .literature:   return "text.book.closed"
        case .philosophy:   return "brain"
        case .general:      return "square.grid.2x2"
        }
    }
}
