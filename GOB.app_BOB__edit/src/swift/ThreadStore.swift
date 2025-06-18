// ∴ ThreadStore.swift

import Foundation

struct ThreadItem: Identifiable {
  let id: UUID
  var name: String
  var path: URL
  var messages: [ChatMessage] = []
}

class ThreadStore: ObservableObject {
  @Published var threads: [ThreadItem] = []

  func loadMessages(for thread: inout ThreadItem) {
    let chatPath = thread.path.appendingPathComponent("chat.jsonl")
    guard let raw = try? String(contentsOf: chatPath, encoding: .utf8) else { return }
    let lines = raw.split(separator: "\n")
    let decoder = JSONDecoder()
    thread.messages = lines.compactMap { line in
      try? decoder.decode(ChatMessage.self, from: Data(line.utf8))
    }
  }

  func appendMessage(_ message: ChatMessage, to thread: ThreadItem) {
    let chatPath = thread.path.appendingPathComponent("chat.jsonl")
    let encoder = JSONEncoder()
    encoder.outputFormatting = .withoutEscapingSlashes

    if let data = try? encoder.encode(message),
       let line = String(data: data, encoding: .utf8) {
      if FileManager.default.fileExists(atPath: chatPath.path) {
        try? FileHandle(forWritingTo: chatPath).seekToEndAndWrite("\(line)\n")
      } else {
        try? line.appending("\n").write(to: chatPath, atomically: true, encoding: .utf8)
      }
    }
  }

  let basePath: URL = FileManager.default
    .homeDirectoryForCurrentUser
    .appendingPathComponent("BOB/threads", isDirectory: true)

  init() {
    loadThreads()
  }

  func loadThreads() {
    try? FileManager.default.createDirectory(at: basePath, withIntermediateDirectories: true)
    let contents = (try? FileManager.default.contentsOfDirectory(at: basePath, includingPropertiesForKeys: nil)) ?? []

    threads = contents.filter { $0.hasDirectoryPath }.map {
      ThreadItem(id: UUID(), name: $0.lastPathComponent, path: $0)
    }
  }

  func createThread(named name: String) {
    let folder = basePath.appendingPathComponent(name)
    try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
    loadThreads()
  }

  func renameThread(_ thread: ThreadItem, to newName: String) {
    let newURL = basePath.appendingPathComponent(newName)
    try? FileManager.default.moveItem(at: thread.path, to: newURL)
    loadThreads()
  }

  func deleteThread(_ thread: ThreadItem) {
    try? FileManager.default.removeItem(at: thread.path)
    loadThreads()
  }
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
