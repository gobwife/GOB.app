import SwiftUI

struct MessageBubble: View {
  var msg: ChatMessage

  @State private var glowOpacity: Double = 1.0

  var body: some View {
    VStack(alignment: msg.isBob ? .trailing : .leading, spacing: 4) {
      Text(msg.text)
        .font(.custom("Andale Mono", size: 14))
        .foregroundColor(msg.isBob ? Color.white : Color(red: 1.0, green: 0.85, blue: 1.0))
        .multilineTextAlignment(.leading)
        .frame(maxWidth: 340, alignment: msg.isBob ? .trailing : .leading)
        .padding(10)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(glowColor(for: msg).opacity(glowOpacity), lineWidth: 1.3)
        )

      if let foil = msg.foil {
        Text(foil)
          .font(.custom("Andale Mono", size: 13).italic())
          .foregroundColor(.gray)
      }
    }
    .onAppear {
      if msg.isRecentBob {
        glowOpacity = 1.0
        withAnimation(.easeOut(duration: 5.0)) {
          glowOpacity = 0.0
        }
      }
    }
  }

  func glowColor(for msg: ChatMessage) -> Color {
    switch msg.emotion {
      case .normal:
        return msg.isBob ? Color(hue: 0.55, saturation: 0.3, brightness: 0.4)
                         : Color(hue: 0.80, saturation: 0.3, brightness: 0.4)
      case .liked:
        return msg.isBob ? Color(hue: 0.20, saturation: 0.4, brightness: 0.6)
                         : Color(hue: 0.06, saturation: 0.4, brightness: 0.6)
      case .excited:
        return msg.isBob ? Color(hue: 0.15, saturation: 0.5, brightness: 0.8)
                         : Color(hue: 0.03, saturation: 0.5, brightness: 0.8)
    }
  }
}
