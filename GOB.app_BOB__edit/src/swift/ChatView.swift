// ∴ ChatView.swift

import SwiftUI

struct ChatView: View {
  @State private var activeScene = "chat"

  var body: some View {
    VStack {
      HStack {
        Spacer()
        Button("⇌ GOB") {
          activeScene = (activeScene == "chat") ? "gob" : "chat"
        }
        .font(.custom("Andale Mono", size: 11))
        .padding(8)
        .foregroundColor(.mint)
      }

      if activeScene == "chat" {
        ChatMainView(activeScene: $activeScene)
      } else {
        GOBPortalView(activeScene: $activeScene)
      }
    }
  }
}
