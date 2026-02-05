import Foundation

/// Privacy-first on-device storage using UserDefaults.
///
/// All data stays on the user's device — nothing is sent to servers.
/// Uses JSON encoding for type-safe persistence.
///
/// ```swift
/// let storage = LocalStorage()
/// storage.save(myModel, forKey: "my.key")
/// let loaded: MyModel? = storage.load(forKey: "my.key")
/// ```
public final class LocalStorage: @unchecked Sendable {

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let lock = NSLock()

    /// Create a LocalStorage instance backed by UserDefaults.
    ///
    /// - Parameter suiteName: UserDefaults suite name. Pass `nil` for `.standard`.
    public init(suiteName: String? = nil) {
        if let suiteName = suiteName {
            self.defaults = UserDefaults(suiteName: suiteName) ?? .standard
        } else {
            self.defaults = .standard
        }
    }

    // MARK: - Save

    /// Save a Codable value to storage.
    ///
    /// - Parameters:
    ///   - value: The value to persist.
    ///   - key: Storage key.
    public func save<T: Encodable>(_ value: T, forKey key: String) {
        lock.lock()
        defer { lock.unlock() }
        do {
            let data = try encoder.encode(value)
            defaults.set(data, forKey: key)
        } catch {
            #if DEBUG
            print("[EducationAI] Failed to encode \(T.self) for key '\(key)': \(error)")
            #endif
        }
    }

    // MARK: - Load

    /// Load a Codable value from storage.
    ///
    /// - Parameter key: Storage key.
    /// - Returns: The decoded value, or `nil` if not found or decode fails.
    public func load<T: Decodable>(forKey key: String) -> T? {
        lock.lock()
        defer { lock.unlock() }
        guard let data = defaults.data(forKey: key) else { return nil }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            #if DEBUG
            print("[EducationAI] Failed to decode \(T.self) for key '\(key)': \(error)")
            #endif
            return nil
        }
    }

    // MARK: - Delete

    /// Remove a value from storage.
    ///
    /// - Parameter key: Storage key to remove.
    public func remove(forKey key: String) {
        lock.lock()
        defer { lock.unlock() }
        defaults.removeObject(forKey: key)
    }

    /// Check if a key exists in storage.
    ///
    /// - Parameter key: Storage key.
    /// - Returns: `true` if the key has a stored value.
    public func exists(forKey key: String) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return defaults.object(forKey: key) != nil
    }

    /// Remove all stored values for this suite.
    public func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        if let suiteName = defaults.volatileDomainNames.first {
            defaults.removePersistentDomain(forName: suiteName)
        }
        // Fallback: remove known keys
        for key in defaults.dictionaryRepresentation().keys {
            if key.hasPrefix("educationai.") {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
