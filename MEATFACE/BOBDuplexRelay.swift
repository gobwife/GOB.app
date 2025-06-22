// ∴ logic1 :: BOBDuplexRelay.swift — full duplex BOB relay (ABC→D→E)
// Use in ChatMainView or GOBPortalView for ache-aware replies

import Foundation
import SwiftUI

struct BOBDuplexRelay {
    static let relayPath = FileManager.default
        .homeDirectoryForCurrentUser
        .appendingPathComponent(".bob/bob_output.relay.json")

    static func ask(_ prompt: String, completion: @escaping (String) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let script = "/opt/bob/core/grow/eval_duplex_phrase.sh \"\(prompt)\""
            let task = Process()
            task.executableURL = URL(fileURLWithPath: "/bin/bash")
            task.arguments = ["-c", script]

            let pipe = Pipe()
            task.standardOutput = pipe
            task.standardError = pipe

            do {
                try task.run()
                task.waitUntilExit()

                let _ = pipe.fileHandleForReading.readDataToEndOfFile() // discard output

                if let output = latestOutput() {
                    DispatchQueue.main.async {
                        completion(output)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion("∅ no brain output")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion("✘ Failed to run duplex model relay: \(error.localizedDescription)")
                }
            }
        }
    }

    static func latestOutput() -> String? {
        guard let data = try? Data(contentsOf: relayPath) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        return json["primary"] as? String
    }
}
