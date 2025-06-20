// ∴ ThreadStore.swift
import Foundation
import Combine

struct ChatMessage: Codable {
    var content: String
    var timestamp: Date
    // Add other properties as needed
}

struct ThreadMeta: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var path: URL
}

struct ThreadItem: Identifiable {
    var id: UUID
    var name: String
    var path: URL
    var messages: [ChatMessage] = []
}

class ThreadStore: ObservableObject {
    @Published var threads: [ThreadItem] = []
    @Published var error: String?

    private let basePath: URL

init() {
    self.basePath = FileManager.default
        .homeDirectoryForCurrentUser
        .appendingPathComponent("BOB/threads", isDirectory: true)
    createDirectoryIfNeeded()
    loadThreads()
}

    private func createDirectoryIfNeeded() {
        do {
            try FileManager.default.createDirectory(at: basePath, 
withIntermediateDirectories: true)
        } catch {
            self.error = "Failed to create directory: 
\(error.localizedDescription)"
        }
    }

    func loadMessages(for thread: inout ThreadItem) {
        let chatPath = thread.path.appendingPathComponent("chat.jsonl")
        do {
            let raw = try String(contentsOf: chatPath, encoding: .utf8)
            let lines = raw.split(separator: "\n")
            let decoder = JSONDecoder()
            thread.messages = lines.compactMap { line in
                try? decoder.decode(ChatMessage.self, from: 
Data(line.utf8))
            }
        } catch {
            self.error = "Failed to load messages: 
\(error.localizedDescription)"
        }
    }

    func appendMessage(_ message: ChatMessage, to thread: ThreadItem) {
        let chatPath = thread.path.appendingPathComponent("chat.jsonl")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes

        do {
            if let data = try? encoder.encode(message),
               let line = String(data: data, encoding: .utf8) {
                if FileManager.default.fileExists(atPath: chatPath.path) {
                    try FileHandle(forWritingTo: 
chatPath).seekToEndAndWrite("\(line)\n")
                } else {
                    try line.appending("\n").write(to: chatPath, 
atomically: true, encoding: .utf8)
                }
            }
        } catch {
            self.error = "Failed to append message: 
\(error.localizedDescription)"
        }
    }

    func loadThreads() {
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: 
basePath, includingPropertiesForKeys: nil)
            threads = contents.filter { $0.hasDirectoryPath }.map {
                ThreadItem(id: UUID(), name: $0.lastPathComponent, path: 
$0)
            }
        } catch {
            self.error = "Failed to load threads: 
\(error.localizedDescription)"
        }
    }

    func createThread(named title: String) {
        let threadMeta = ThreadMeta(title: title, path: 
basePath.appendingPathComponent(title))
        saveThreadList([threadMeta])

        let folder = threadMeta.path
        do {
            try FileManager.default.createDirectory(at: folder, 
withIntermediateDirectories: true)
            loadThreads() // Reload threads to update the UI
        } catch {
            self.error = "Failed to create thread: 
\(error.localizedDescription)"
        }
    }

    func renameThread(_ thread: ThreadItem, to newName: String) {
        let newURL = basePath.appendingPathComponent(newName)
        do {
            try FileManager.default.moveItem(at: thread.path, to: newURL)
            var threadsCopy = loadThreadList()
            if let index = threadsCopy.firstIndex(where: { $0.id == 
thread.id }) {
                threadsCopy[index].title = newName
            }
            saveThreadList(threadsCopy)
            loadThreads() // Reload threads to update the UI
        } catch {
            self.error = "Failed to rename thread: 
\(error.localizedDescription)"
        }
    }

    func deleteThread(_ thread: ThreadItem) {
        do {
            try FileManager.default.removeItem(at: thread.path)
            var threadsCopy = loadThreadList()
            if let index = threadsCopy.firstIndex(where: { $0.id == 
thread.id }) {
                threadsCopy.remove(at: index)
            }
            saveThreadList(threadsCopy)
            loadThreads() // Reload threads to update the UI
        } catch {
            self.error = "Failed to delete thread: 
\(error.localizedDescription)"
        }
    }

    private func loadThreadList() -> [ThreadMeta] {
        let threadListPath = 
basePath.appendingPathComponent("thread_list.json")
        do {
            let data = try Data(contentsOf: threadListPath)
            return try JSONDecoder().decode([ThreadMeta].self, from: data)
        } catch {
            self.error = "Failed to load thread list: 
\(error.localizedDescription)"
            return []
        }
    }

    private func saveThreadList(_ list: [ThreadMeta]) {
        let threadListPath = 
basePath.appendingPathComponent("thread_list.json")
        do {
            let data = try JSONEncoder().encode(list)
            try data.write(to: threadListPath)
        } catch {
            self.error = "Failed to save thread list: 
\(error.localizedDescription)"
        }
    }
}

func hydrateMeta(_ meta: ThreadMeta) -> ThreadItem {
    let chatPath = meta.path.appendingPathComponent("chat.jsonl")
    var messages: [ChatMessage] = []

    do {
        let raw = try String(contentsOf: chatPath, encoding: .utf8)
        let lines = raw.split(separator: "\n")
        let decoder = JSONDecoder()
        messages = lines.compactMap { line in
            try? decoder.decode(ChatMessage.self, from: Data(line.utf8))
        }
    } catch {
        print("Failed to load messages for \(meta.title): \(error)")
    }

    return ThreadItem(
        id: meta.id,
        name: meta.title,
        path: meta.path,
        messages: messages
    )
}

func reduceItem(_ item: ThreadItem) -> ThreadMeta {
    return ThreadMeta(
        id: item.id,
        title: item.name,
        path: item.path
    )
}

private extension FileHandle {
    func seekToEndAndWrite(_ text: String) {
        seekToEndOfFile()
        if let data = text.data(using: .utf8) {
            write(data)
        }
        closeFile()
    }
}