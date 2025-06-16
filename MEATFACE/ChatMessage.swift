import Foundation

enum BubbleEmotion: String, Codable {
  case normal
  case liked
  case excited
}

struct ChatMessage: Identifiable, Codable {
    let id: UUID
    var text: String
    var isBob: Bool
    var foil: String?
    var timestamp: Date
    var isRecentUser: Bool = false
    var isRecentBob: Bool = false
    var isLikedByOther: Bool = false
    var emotion: BubbleEmotion = .normal
    
    static func from(raw: String) -> ChatMessage {
        ChatMessage(
            id: UUID(),
            text: raw,
            isBob: raw.hasPrefix("BOB:"),
            foil: nil,
            timestamp: Date(),
            isRecentUser: !raw.hasPrefix("BOB:"),
            isRecentBob: raw.hasPrefix("BOB:"),
            isLikedByOther: false,
            emotion: .normal
        )
    }
}
