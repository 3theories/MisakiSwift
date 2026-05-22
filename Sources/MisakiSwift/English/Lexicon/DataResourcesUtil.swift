import Foundation

final class DataResourcesUtil {
    private init() {}
    
    /// Resolve a bundled JSON file by name. Aria's vendored
    /// Package.swift flattens resources to the bundle root (see
    /// the kokoro-ios sibling for why); the subdirectory variant
    /// is the upstream layout, the root variant is ours. Try both
    /// so this code works either way. Local-only patch.
    private static func resourceURL(_ filename: String, ext: String) -> URL? {
        Bundle.module.url(forResource: filename, withExtension: ext, subdirectory: "Resources")
            ?? Bundle.module.url(forResource: filename, withExtension: ext)
    }

    static func loadGold(british: Bool) -> [String: Any] {
        let filename = british ? "gb_gold" : "us_gold"

        guard let url = Self.resourceURL(filename, ext: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return [:]
        }
        return json
    }

    static func loadSilver(british: Bool) -> [String: Any] {
        let filename = british ? "gb_silver" : "us_silver"

        guard let url = Self.resourceURL(filename, ext: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return [:]
        }
        return json
    }
}
