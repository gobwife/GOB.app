import SwiftUI

@main
struct MEATFACEApp: App {
  var body: some Scene {
    WindowGroup {
      ChatView()
        .environmentObject(ChatViewModel())
        .environmentObject(FontManager())
    }
  }
}
