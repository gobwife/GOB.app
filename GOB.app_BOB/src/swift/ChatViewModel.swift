// ∴ ChatViewModel.swift

import Foundation
import SwiftUI
import Combine

@MainActor

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var lastScroll: String?
    
    var lastFoil: String? = nil
    var lastSummary1: String? = nil
    var lastSummary2: String? = nil
    
    func sendToBob() {
        for i in 0..<messages.count {
            messages[i].isRecentUser = false
            messages[i].isRecentBob = false
        }

        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        // Save then wipe
        let userInput = trimmed
        inputText = ""

        let msg = ChatMessage(
            id: UUID(),
            text: userInput,
            isBob: false,
            foil: nil,
            timestamp: Date(),
            isRecentUser: true
        )

        messages.append(msg)

        Task {
            do {
                let response = try await runBridge(with: userInput)
                await MainActor.run {
                    self.appendBobLines([response])
                }
            } catch {
                print("BOB bridge failed:", error.localizedDescription)
            }
        }
    }

    
    func generateMockBobReply() -> [String] {
        return ["ø", "meep", "\0.", "n^n", "<3"]
    }
    
    
    func appendBobLines(_ lines: [String]) {
        for i in 0..<messages.count {
            messages[i].isRecentUser = false
            messages[i].isRecentBob = false
        }
        
        let joined = lines.joined(separator: "\n")
        
        let msg = ChatMessage(
            id: UUID(),
            text: joined,
            isBob: true,
            foil: nil,
            timestamp: Date(),
            isRecentBob: true
        )
        
        let emotionalTriggers = [
            "GUMI!!!!!",
            "LMAO.",
            "I'm ALIVE!"
        ]
        
        let isEmotionallyMoved = emotionalTriggers.contains { joined.contains($0) }
        
        if let lastUserIndex = messages.lastIndex(where: { !$0.isBob }) {
            let lastPrompt = messages[lastUserIndex].text.lowercased()
            
            let logicTrigger = lastPrompt.contains("why") ||
            lastPrompt.contains("how come") ||
            lastPrompt.contains("decode") ||
            lastPrompt.contains("sigil") ||
            lastPrompt.contains("ache") ||
            lastPrompt.count > 100
            
            if isEmotionallyMoved || logicTrigger {
                messages[lastUserIndex].isLikedByOther = true
                messages[lastUserIndex].emotion = .excited
            }
        }
        messages.append(msg)
    }
    
private func runBridge(with input: String) async throws -> String {
    let task = Process()
    let HOME = FileManager.default.homeDirectoryForCurrentUser.path
    let scriptPath = "\(HOME)/BOB/core/src/duplex_model_forge.mjs"

let nodePath = ProcessInfo.processInfo.environment["NODE_PATH"] ?? "/usr/local/bin/node"
task.launchPath = nodePath
    task.arguments = [scriptPath, input]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    try task.run()
    _ = pipe.fileHandleForReading.readDataToEndOfFile()
    task.waitUntilExit()

    let outputPath = "\(HOME)/.bob/bob_output.relay.json"
    guard FileManager.default.fileExists(atPath: outputPath) else {
        throw NSError(domain: "runBridge", code: 2, userInfo: [NSLocalizedDescriptionKey: "No relay file found"])
    }

    let data = try Data(contentsOf: URL(fileURLWithPath: outputPath))
    guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
          let primary = json["primary"] as? String else {
        throw NSError(domain: "runBridge", code: 3, userInfo: [NSLocalizedDescriptionKey: "Malformed output"])
    }

    return primary.trimmingCharacters(in: .whitespacesAndNewlines)
}

    private func listenForBobReply() async {
        let path = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".bob/bob_output.relay.json")
        
        for _ in 0..<10 {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            guard FileManager.default.fileExists(atPath: path.path) else { continue }
            
            if let data = try? Data(contentsOf: path),
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let text = json["text"] as? String {
                await MainActor.run {
                    let msg = ChatMessage(
                        id: UUID(),
                        text: text,
                        isBob: true,
                        foil: nil,
                        timestamp: Date()
                    )
                    self.messages.append(msg)
                }
                break
            }
        }
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

