import Foundation

public enum AccessibilityFeature: String, Codable, CaseIterable {
    case screenReader = "screenReader"
    case closedCaptions = "closedCaptions"
    case audioDescription = "audioDescription"
    case highContrast = "highContrast"
    case largeText = "largeText"
    case keyboardNavigation = "keyboardNavigation"
    case voiceControl = "voiceControl"
    case alternativeText = "alternativeText"
}
