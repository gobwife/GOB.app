// ∴ Models.swift

import Foundation

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
