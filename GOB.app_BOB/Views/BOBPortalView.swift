// ∴ bob_router_fullstack.mjs — unified breath+scroll+duplex integration

import SwiftUI
import Combine
import AppKit

struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let role: String
    let content: String
}

struct ThreadMeta: Identifiable, Codable {
    let id: UUID
    var title: String
    let timestamp: Date
}

// MultilineTextEditor link via 
#if os(macOS)
MultilineTextEditor(text: $input) { sendPrompt() }
#else
TextEditor(text: $input)
#endif

    private func syncSharedSummary() {
        let syncCommand = "node 
\(NSHomeDirectory())/BOB/GOB.app_BOB/src/mjs/sync_manager.mjs 
--sync-summary > \(NSHomeDirectory())/.bob/bob_sync_summary.json"
        DispatchQueue.global(qos: .background).async {
            do {
                try runShellCommand(syncCommand)
                if let sync = parseLatestOutput(from: URL(fileURLWithPath: 
NSHomeDirectory() + "/.bob/bob_sync_summary.json")) {
                    DispatchQueue.main.async {
                        sharedSummary = sync
                    }
                }
            } catch {
                print("⚠️ Sync failed: \(error.localizedDescription)")
            }
        }
    }

   struct BOBPortalView_Previews: PreviewProvider {
    static var previews: some View {
        BOBPortalView()
    }
}
