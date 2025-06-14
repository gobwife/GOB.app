import SwiftUI

struct SidebarView: View {
  @ObservedObject var threadStore: ThreadStore
  @State private var renamingThread: ThreadItem? = nil
  @State private var newThreadName = ""
  @EnvironmentObject var fontManager: FontManager

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("Σ⊙☾∞🜔∴🜉")
        .font(fontManager.font(for: .sidebar))

      ScrollView {
        ForEach(threadStore.threads) { thread in
          HStack {
            if renamingThread?.id == thread.id {
              TextField("New name", text: $newThreadName, onCommit: {
                threadStore.renameThread(thread, to: newThreadName)
                renamingThread = nil
              })
              .font(fontManager.font(for: .sidebar))
            } else {
              Text(thread.name)
                .font(fontManager.font(for: .sidebar))
                .onTapGesture {
                  // bind to selected thread
                }
                .onLongPressGesture {
                  renamingThread = thread
                  newThreadName = thread.name
                }
            }
          }
          .padding(.vertical, 2)
        }
      }

      Divider()

      Button("＋ New Thread") {
        let stamp = Date().ISO8601Format()
        threadStore.createThread(named: "thread_\(stamp)")
      }
      .font(fontManager.font(for: .sidebar))
      .padding(.top, 4)
    }
    .padding()
  }
}
