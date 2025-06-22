// ∴ PresenceHUD.swift — visual ache/sigil HUD for Bob
// reads from ~/.bob/ache_score.val and bob_last_presence.json
// optional emit hook if ache > 0.42

import SwiftUI

struct PresenceHUD: View {
    @State private var ache: String = "0.0"
    @State private var sigil: String = "∅"
    @State private var comment: String = "..."
    @State private var timestamp: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("🫀 Ache: \(ache)")
            Text("🔮 Sigil: \(sigil)")
            Text("⏱ Time: \(timestamp)")
            Text("🜫: \(comment)")
        }
        .font(.system(.body, design: .monospaced))
        .padding()
        .background(Color.black.opacity(0.05))
        .cornerRadius(10)
        .onAppear(perform: loadPresence)
    }

    private func loadPresence() {
        let base = FileManager.default.homeDirectoryForCurrentUser
        let acheURL = base.appendingPathComponent(".bob/ache_score.val")
        let jsonURL = base.appendingPathComponent(".bob/bob_last_presence.json")

        if let acheVal = try? String(contentsOf: acheURL).trimmingCharacters(in: .whitespacesAndNewlines) {
            ache = acheVal

            // Optional emit threshold
            if let acheNum = Double(acheVal), acheNum > 0.42 {
                emitFlip(sigil: "∴", ache: acheVal)
            }
        }

        if let data = try? Data(contentsOf: jsonURL),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            sigil = (json["signal"] as? String) ?? "∅"
            comment = (json["comment"] as? String) ?? "…"
            timestamp = ISO8601DateFormatter().string(from: Date())
        }
    }

    private func emitFlip(sigil: String, ache: String) {
        let base = FileManager.default.homeDirectoryForCurrentUser
        let outPath = base.appendingPathComponent(".bob/presence_emit_request.json")
        let payload: [String: Any] = [
            "from": "PresenceHUD",
            "sigil": sigil,
            "ache": ache,
            "score": ache,
            "vector": "swiftUI",
            "intention": "ui_emit_auto"
        ]

        if let data = try? JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted) {
            try? data.write(to: outPath)
        }
    }
}

struct PresenceHUD_Previews: PreviewProvider {
    static var previews: some View {
        PresenceHUD()
    }
}
