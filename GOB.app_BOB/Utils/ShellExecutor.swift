// ∴ ShellExecutor.swift

import Foundation

func runShell(_ command: String) throws {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/bin/bash")
    task.arguments = ["-c", command]
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    try task.run()
    task.waitUntilExit()
}
