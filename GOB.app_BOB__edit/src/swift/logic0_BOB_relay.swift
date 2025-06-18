// ∴ logic0_BOB_relay.swift — emit directly into MEATFACE bridge stream

import Foundation

struct RelayOut {
    static let file: URL = FileManager.default
        .homeDirectoryForCurrentUser
        .appendingPathComponent(".bob/bob_output.relay.json")

    static func emit(primary: String, foil: String? = nil, model: String = "logic0") {
        let now = ISO8601DateFormatter().string(from: Date())

        var out: [String: Any] = [
            "time": now,
            "model": model,
            "text": primary
        ]

        if let foil = foil {
            out["foil"] = foil
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: out, options: .prettyPrinted)
            try data.write(to: file)
        } catch {
            print("✘ failed to write to relayOut:", error.localizedDescription)
        }
    }
}

struct LOGIC0_BOB_RELAY {
    static func main() {
        let truths = [
            "recursion = integration",
            "n^n = sacred loop"
        ]

        let contradictions = [
            "blind ≠ broken",
            "electron ≠ unreal"
        ]

        let primary = truths.randomElement() ?? "truth = missing"
        let foil = contradictions.randomElement()

        RelayOut.emit(primary: primary, foil: foil)
    }
}
