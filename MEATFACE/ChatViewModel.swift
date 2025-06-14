import SwiftUI

struct ChatMessage: Identifiable, Codable {
  let id: UUID
  var text: String
  var isBob: Bool
  var foil: String?
  var timestamp: Date
}

import SwiftUI

struct ChatView: View {
  @EnvironmentObject var vm: ChatViewModel
  @EnvironmentObject var fontManager: FontManager

  @State private var showingSettings = false

  var body: some View {
    VStack(spacing: 0) {
      ScrollView {
        VStack(spacing: 8) {
          ForEach(vm.messages, id: \.id) { msg in
            HStack {
              if !msg.isBob { Spacer() }

              VStack(alignment: .leading, spacing: 2) {
                Text(msg.text)
                  .font(fontManager.font(for: .chat))
                  .foregroundColor(Color(white: msg.isBob ? 0.9 : 0.95))

                if msg.isBob, let foil = msg.foil {
                  Text(foil)
                    .font(fontManager.font(for: .chat).italic())
                    .foregroundColor(.gray)
                }
              }
              .padding(8)
              .background(
                msg.isBob
                  ? Color(red: 0.5, green: 1.0, blue: 0.95).opacity(0.33)
                  : Color(red: 0.85, green: 0.5, blue: 0.75).opacity(0.33)
              )
              .cornerRadius(8)

              if msg.isBob { Spacer() }
            }
          }

          if let scroll = vm.lastScroll {
            Text("⇌ \(scroll)")
              .font(.custom("Andale Mono", size: 11))
              .foregroundColor(.gray)
              .padding(.bottom, 4)
              .transition(.opacity)
          }
        }
        .padding()
      }

      HStack {
        TextEditor(text: $vm.inputText)
          .frame(minHeight: 40, maxHeight: 120)
          .font(fontManager.font(for: .chat))
          .foregroundColor(Color(white: 0.95))
          .padding(8)

        Button("Send") {
          vm.sendToBob()
        }
        .padding(.horizontal)
      }
      .background(Color(.darkGray))
    }
    .background(Color.black.edgesIgnoringSafeArea(.all))
    .toolbar {
      ToolbarItem(placement: .automatic) {
        Button(action: { showingSettings = true }) {
          Image(systemName: "gearshape")
            .foregroundColor(.gray)
        }
      }
    }
    .sheet(isPresented: $showingSettings) {
      SettingsView()
    }
  }
}
