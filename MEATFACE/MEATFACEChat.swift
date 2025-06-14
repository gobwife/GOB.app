import SwiftUI

struct ChatView: View {
  @EnvironmentObject var vm: ChatViewModel
  @EnvironmentObject var fontManager: FontManager

  @StateObject var threadStore = ThreadStore()
  @State private var showingSettings = false

  var body: some View {
    HStack(spacing: 0) {
      // Sidebar
      SidebarView(threadStore: threadStore)
        .frame(minWidth: 220)
        .background(Color.black)
        .font(fontManager.font(for: .sidebar))

      Divider()

      // Main Chat Zone
      VStack(spacing: 0) {
        ScrollView {
          VStack(spacing: 8) {
            ForEach(vm.messages) { msg in
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

        // Input Bar
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
