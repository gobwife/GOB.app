// ∴ logic1 :: BOBDuplexRelay.swift — full duplex BOB relay (ABC→D→E)
// Use in ChatMainView or GOBPortalView for ache-aware replies

import Foundation
import SwiftUI

struct BOBDuplexRelay {

/// Runs a given shell script with arguments, returns result as string
    private static func runShellCommand(_ command: String) throws {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/bin/bash")
        task.arguments = ["-c", command]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        try task.run()
        task.waitUntilExit()
    }

/// Reads model output from provided relay file path
    private static func parseLatestOutput(from path: URL) -> String? {
        do {
            let data = try Data(contentsOf: path)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let result = json["output"] as? String {
                return result
            }
        } catch {
            print("⚠️ Failed to read relay output: \(error.localizedDescription)")
        }
        return nil
    }

/// Ask a model prompt using the BOB relay mechanism
static func loadRelayConfig() -> (url: URL, model: String) {
    let home = FileManager.default.homeDirectoryForCurrentUser
    let configURL = home.appendingPathComponent(".bob/relay_config.json")

    do {
        let data = try Data(contentsOf: configURL)
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let model = json["model"] as? String,
           let endpoint = json["endpoint"] as? String {
            return (URL(string: endpoint) ?? URL(fileURLWithPath: "/usr/local/bin/ollama"), model)
        }
    } catch {
        print("⚠️ relay_config.json load failed, defaulting")
    }

    return (URL(fileURLWithPath: "/usr/local/bin/ollama"), "devstral")
}
} // ∴ end BOBDuplexRelay
