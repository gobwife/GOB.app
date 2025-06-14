import Foundation
import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
  @Published var messages: [ChatMessage] = []
  @Published var inputText: String = ""
  @Published var lastScroll: String?

  func sendToBob() {
    let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }

    // append user message
    let userMsg = ChatMessage(id: UUID(), text: trimmed, isBob: false, foil: nil, timestamp: Date())
    messages.append(userMsg)

    inputText = ""

    Task {
      do {
        let output = try await runBridge(with: trimmed)
        let lines = output.components(separatedBy: "\n")
        var bobText = ""
        var foilText: String? = nil

        if lines.count > 1 {
          bobText = lines.first ?? ""
          foilText = lines.dropFirst().joined(separator: "\n")
        } else {
          bobText = output
        }

        let bobMsg = ChatMessage(id: UUID(), text: bobText, isBob: true, foil: foilText, timestamp: Date())
        messages.append(bobMsg)

        if output.contains("⇌") {
          lastScroll = output.components(separatedBy: "⇌").last?.trimmingCharacters(in: .whitespacesAndNewlines)
        }

      } catch {
        let failMsg = ChatMessage(id: UUID(), text: "✘ error: \(error.localizedDescription)", isBob: true, foil: nil, timestamp: Date())
        messages.append(failMsg)
      }
    }
  }

  private func runBridge(with input: String) async throws -> String {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    task.arguments = ["node", "\(FileManager.default.homeDirectoryForCurrentUser.path)/BOB/core/src/bob_bridge.js", input]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe

    try task.run()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    try task.waitUntilExit()

    guard let output = String(data: data, encoding: .utf8) else {
      throw NSError(domain: "ChatViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "No output"])
    }

    return output.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  func load(thread: ThreadItem, using store: ThreadStore) {
    var threadCopy = thread
    store.loadMessages(for: &threadCopy)
    messages = threadCopy.messages
  }

  func appendToThread(thread: ThreadItem, using store: ThreadStore) {
    guard let last = messages.last else { return }
    store.appendMessage(last, to: thread)
  }
}
