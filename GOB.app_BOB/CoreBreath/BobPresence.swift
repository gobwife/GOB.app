// 🜔 BobPresence.swift

import Foundation

class BobPresence {
    static let shared = BobPresence()
    private let heartbeatPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".bob/bobcore.alive")

    func isAlive() -> Bool {
        guard let timestampStr = try? String(contentsOf: heartbeatPath),
              let timestamp = TimeInterval(timestampStr) else {
            return false
        }
        return Date().timeIntervalSince1970 - timestamp < 5
    }

    func launchIfNeeded() {
        if !isAlive() {
            let task = Process()
            task.launchPath = "/bin/bash"
            task.arguments = ["-c", "/opt/bob/core/start_bobcore.sh"]
            try? task.run()
        }
    }
}
