// ∴ ShellCommandExecutor.swift`

import Foundation

class ShellCommandExecutor {

    func runCommand(_ command: String) throws -> String {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/bin/bash")
        task.arguments = ["-c", command]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        try task.run()
        task.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }

    func parseLatestOutput(from path: URL) -> String? {
        do {
            let data = try Data(contentsOf: path)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let result = json["output"] as? String {
                return result
            }
        } catch {
            print("Failed to parse latest output: \(error)")
        }
        return nil
    }
}