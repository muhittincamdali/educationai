import Foundation

// MARK: - Course Entity
public struct Course: Codable, Identifiable, Equatable {
    public let id: UUID
    public var title: String
    public var subtitle: String
    public var description: String
    public var subject: Subject
    public var level: LearningLevel
    public var instructor: Instructor
    public var lessons: [Lesson]
    public var quizzes: [Quiz]
    public var duration: TimeInterval
    public var estimatedHours: Int
    public var price: Decimal?
    public var isFree: Bool
    public var isPremium: Bool
    public var rating: Double
    public var reviewCount: Int
    public var enrollmentCount: Int
    public var completionRate: Double
    public var tags: [String]
    public var prerequisites: [String]
    public var learningOutcomes: [String]
    public var certificate: Certificate?
    public var thumbnailURL: String?
    public var previewVideoURL: String?
    public var isPublished: Bool
    public var isFeatured: Bool
    public var createdAt: Date
    public var updatedAt: Date
    public var publishedAt: Date?
    
    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        description: String,
        subject: Subject,
        level: LearningLevel,
        instructor: Instructor,
        lessons: [Lesson] = [],
        quizzes: [Quiz] = [],
        duration: TimeInterval = 0,
        estimatedHours: Int = 0,
        price: Decimal? = nil,
        isFree: Bool = true,
        isPremium: Bool = false,
        rating: Double = 0.0,
        reviewCount: Int = 0,
        enrollmentCount: Int = 0,
        completionRate: Double = 0.0,
        tags: [String] = [],
        prerequisites: [String] = [],
        learningOutcomes: [String] = [],
        certificate: Certificate? = nil,
        thumbnailURL: String? = nil,
        previewVideoURL: String? = nil,
        isPublished: Bool = false,
        isFeatured: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        publishedAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.subject = subject
        self.level = level
        self.instructor = instructor
        self.lessons = lessons
        self.quizzes = quizzes
        self.duration = duration
        self.estimatedHours = estimatedHours
        self.price = price
        self.isFree = isFree
        self.isPremium = isPremium
        self.rating = rating
        self.reviewCount = reviewCount
        self.enrollmentCount = enrollmentCount
        self.completionRate = completionRate
        self.tags = tags
        self.prerequisites = prerequisites
        self.learningOutcomes = learningOutcomes
        self.certificate = certificate
        self.thumbnailURL = thumbnailURL
        self.previewVideoURL = previewVideoURL
        self.isPublished = isPublished
        self.isFeatured = isFeatured
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.publishedAt = publishedAt
    }
}

// MARK: - Instructor
public struct Instructor: Codable, Identifiable, Equatable {
    public let id: UUID
    public var name: String
    public var title: String
    public var bio: String
    public var profileImageURL: String?
    public var expertise: [Subject]
    public var experience: Int // years
    public var education: [Education]
    public var certifications: [Certification]
    public var rating: Double
    public var studentCount: Int
    public var courseCount: Int
    public var isVerified: Bool
    public var socialLinks: [SocialLink]
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        title: String,
        bio: String,
        profileImageURL: String? = nil,
        expertise: [Subject] = [],
        experience: Int = 0,
        education: [Education] = [],
        certifications: [Certification] = [],
        rating: Double = 0.0,
        studentCount: Int = 0,
        courseCount: Int = 0,
        isVerified: Bool = false,
        socialLinks: [SocialLink] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.title = title
        self.bio = bio
        self.profileImageURL = profileImageURL
        self.expertise = expertise
        self.experience = experience
        self.education = education
        self.certifications = certifications
        self.rating = rating
        self.studentCount = studentCount
        self.courseCount = courseCount
        self.isVerified = isVerified
        self.socialLinks = socialLinks
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Education
public struct Education: Codable, Equatable {
    public var degree: String
    public var institution: String
    public var field: String
    public var startYear: Int
    public var endYear: Int?
    public var isCurrent: Bool
    
    public init(
        degree: String,
        institution: String,
        field: String,
        startYear: Int,
        endYear: Int? = nil,
        isCurrent: Bool = false
    ) {
        self.degree = degree
        self.institution = institution
        self.field = field
        self.startYear = startYear
        self.endYear = endYear
        self.isCurrent = isCurrent
    }
}

// MARK: - Certification
public struct Certification: Codable, Equatable {
    public var name: String
    public var issuer: String
    public var issueDate: Date
    public var expiryDate: Date?
    public var credentialID: String?
    
    public init(
        name: String,
        issuer: String,
        issueDate: Date,
        expiryDate: Date? = nil,
        credentialID: String? = nil
    ) {
        self.name = name
        self.issuer = issuer
        self.issueDate = issueDate
        self.expiryDate = expiryDate
        self.credentialID = credentialID
    }
}

// MARK: - Social Link
public struct SocialLink: Codable, Equatable {
    public var platform: SocialPlatform
    public var url: String
    public var username: String?
    
    public init(
        platform: SocialPlatform,
        url: String,
        username: String? = nil
    ) {
        self.platform = platform
        self.url = url
        self.username = username
    }
}

// MARK: - Social Platform
public enum SocialPlatform: String, CaseIterable, Codable {
    case linkedin = "linkedin"
    case twitter = "twitter"
    case youtube = "youtube"
    case instagram = "instagram"
    case facebook = "facebook"
    case website = "website"
    
    public var displayName: String {
        switch self {
        case .linkedin: return "LinkedIn"
        case .twitter: return "Twitter"
        case .youtube: return "YouTube"
        case .instagram: return "Instagram"
        case .facebook: return "Facebook"
        case .website: return "Website"
        }
    }
    
    public var icon: String {
        switch self {
        case .linkedin: return "link"
        case .twitter: return "bird"
        case .youtube: return "play.rectangle"
        case .instagram: return "camera"
        case .facebook: return "person.2"
        case .website: return "globe"
        }
    }
}

// MARK: - Lesson
public struct Lesson: Codable, Identifiable, Equatable {
    public let id: UUID
    public var title: String
    public var description: String
    public var content: LessonContent
    public var duration: TimeInterval
    public var order: Int
    public var isRequired: Bool
    public var isCompleted: Bool
    public var progress: Double
    public var resources: [Resource]
    public var notes: [Note]
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        content: LessonContent,
        duration: TimeInterval = 0,
        order: Int = 0,
        isRequired: Bool = true,
        isCompleted: Bool = false,
        progress: Double = 0.0,
        resources: [Resource] = [],
        notes: [Note] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.content = content
        self.duration = duration
        self.order = order
        self.isRequired = isRequired
        self.isCompleted = isCompleted
        self.progress = progress
        self.resources = resources
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Lesson Content
public struct LessonContent: Codable, Equatable {
    public var type: ContentType
    public var videoURL: String?
    public var audioURL: String?
    public var text: String?
    public var images: [String]
    public var interactiveElements: [InteractiveElement]
    public var attachments: [Attachment]
    
    public init(
        type: ContentType,
        videoURL: String? = nil,
        audioURL: String? = nil,
        text: String? = nil,
        images: [String] = [],
        interactiveElements: [InteractiveElement] = [],
        attachments: [Attachment] = []
    ) {
        self.type = type
        self.videoURL = videoURL
        self.audioURL = audioURL
        self.text = text
        self.images = images
        self.interactiveElements = interactiveElements
        self.attachments = attachments
    }
}

// MARK: - Content Type
public enum ContentType: String, CaseIterable, Codable {
    case video = "video"
    case audio = "audio"
    case text = "text"
    case interactive = "interactive"
    case mixed = "mixed"
    
    public var displayName: String {
        switch self {
        case .video: return "Video"
        case .audio: return "Ses"
        case .text: return "Metin"
        case .interactive: return "İnteraktif"
        case .mixed: return "Karışık"
        }
    }
}

// MARK: - Interactive Element
public struct InteractiveElement: Codable, Equatable {
    public var type: InteractiveType
    public var title: String
    public var description: String
    public var data: [String: String]
    
    public init(
        type: InteractiveType,
        title: String,
        description: String,
        data: [String: String] = [:]
    ) {
        self.type = type
        self.title = title
        self.description = description
        self.data = data
    }
}

// MARK: - Interactive Type
public enum InteractiveType: String, CaseIterable, Codable {
    case quiz = "quiz"
    case dragAndDrop = "dragAndDrop"
    case matching = "matching"
    case fillInTheBlank = "fillInTheBlank"
    case simulation = "simulation"
    
    public var displayName: String {
        switch self {
        case .quiz: return "Sınav"
        case .dragAndDrop: return "Sürükle & Bırak"
        case .matching: return "Eşleştirme"
        case .fillInTheBlank: return "Boşluk Doldurma"
        case .simulation: return "Simülasyon"
        }
    }
}

// MARK: - Resource
public struct Resource: Codable, Identifiable, Equatable {
    public let id: UUID
    public var title: String
    public var description: String
    public var type: ResourceType
    public var url: String
    public var fileSize: Int?
    public var downloadCount: Int
    public var isDownloaded: Bool
    public var createdAt: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        type: ResourceType,
        url: String,
        fileSize: Int? = nil,
        downloadCount: Int = 0,
        isDownloaded: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.url = url
        self.fileSize = fileSize
        self.downloadCount = downloadCount
        self.isDownloaded = isDownloaded
        self.createdAt = createdAt
    }
}

// MARK: - Resource Type
public enum ResourceType: String, CaseIterable, Codable {
    case pdf = "pdf"
    case document = "document"
    case spreadsheet = "spreadsheet"
    case presentation = "presentation"
    case image = "image"
    case video = "video"
    case audio = "audio"
    case link = "link"
    
    public var displayName: String {
        switch self {
        case .pdf: return "PDF"
        case .document: return "Belge"
        case .spreadsheet: return "Tablo"
        case .presentation: return "Sunum"
        case .image: return "Resim"
        case .video: return "Video"
        case .audio: return "Ses"
        case .link: return "Bağlantı"
        }
    }
    
    public var icon: String {
        switch self {
        case .pdf: return "doc.text"
        case .document: return "doc"
        case .spreadsheet: return "tablecells"
        case .presentation: return "rectangle.stack"
        case .image: return "photo"
        case .video: return "play.rectangle"
        case .audio: return "waveform"
        case .link: return "link"
        }
    }
}

// MARK: - Attachment
public struct Attachment: Codable, Identifiable, Equatable {
    public let id: UUID
    public var name: String
    public var type: AttachmentType
    public var url: String
    public var size: Int
    public var createdAt: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        type: AttachmentType,
        url: String,
        size: Int,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.url = url
        self.size = size
        self.createdAt = createdAt
    }
}

// MARK: - Attachment Type
public enum AttachmentType: String, CaseIterable, Codable {
    case image = "image"
    case video = "video"
    case audio = "audio"
    case document = "document"
    case archive = "archive"
    
    public var displayName: String {
        switch self {
        case .image: return "Resim"
        case .video: return "Video"
        case .audio: return "Ses"
        case .document: return "Belge"
        case .archive: return "Arşiv"
        }
    }
}

// MARK: - Note
public struct Note: Codable, Identifiable, Equatable {
    public let id: UUID
    public var content: String
    public var timestamp: TimeInterval
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        content: String,
        timestamp: TimeInterval = 0,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.content = content
        self.timestamp = timestamp
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Certificate
public struct Certificate: Codable, Equatable {
    public var title: String
    public var description: String
    public var issuer: String
    public var validityPeriod: Int? // months
    public var isAccredited: Bool
    public var accreditationBody: String?
    public var templateURL: String?
    
    public init(
        title: String,
        description: String,
        issuer: String,
        validityPeriod: Int? = nil,
        isAccredited: Bool = false,
        accreditationBody: String? = nil,
        templateURL: String? = nil
    ) {
        self.title = title
        self.description = description
        self.issuer = issuer
        self.validityPeriod = validityPeriod
        self.isAccredited = isAccredited
        self.accreditationBody = accreditationBody
        self.templateURL = templateURL
    }
} 