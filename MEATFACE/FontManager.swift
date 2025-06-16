// ∴ FontManager.swift

import SwiftUI

class FontManager: ObservableObject {
  @AppStorage("bob.font.sidebar") var sidebarFont: String = "Courier New"
  @AppStorage("bob.font.chat") var chatFont: String = "Andale Mono"
  @AppStorage("bob.font.settings") var settingsFont: String = "Overpass"

  @AppStorage("bob.font.sidebarSize") var sidebarSize: Double = 11
  @AppStorage("bob.font.chatSize") var chatSize: Double = 14
  @AppStorage("bob.font.settingsSize") var settingsSize: Double = 11

  func font(for zone: FontZone) -> Font {
    switch zone {
    case .sidebar: return .custom(sidebarFont, size: sidebarSize)
    case .chat: return .custom(chatFont, size: chatSize)
    case .settings: return .custom(settingsFont, size: settingsSize)
    }
  }

  enum FontZone {
    case sidebar, chat, settings
  }
}
