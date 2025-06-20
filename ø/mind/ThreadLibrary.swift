//  ThreadLibrary.swift
//  ø
//
//  Created by bob gob solar on 6/20/25.
//  allows memory persistence

import Foundation

class ThreadLibrary: ObservableObject {
    @Published var history: [String] = []

    private let fileURL: URL

    init() {
        self.fileURL = FileManager.default.urls(for: .documentDirectory,
in: .userDomainMask).first!
            .appendingPathComponent("conversation_history.json")

        loadHistory()
    }

    func saveHistory() {
        do {
            let data = try JSONEncoder().encode(history)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save conversation history: \(error)")
        }
    }

    private func loadHistory() {
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let data = try Data(contentsOf: fileURL)
                history = try JSONDecoder().decode([String].self, from:
data)
            }
        } catch {
            print("Failed to load thread library: \(error)")
        }
    }

    func addMessage(_ message: String) {
        history.append(message)
        saveHistory()
    }
}
