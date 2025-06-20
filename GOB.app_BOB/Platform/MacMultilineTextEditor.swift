// Platform/MacMultilineTextEditor.swift

#if os(macOS)
import AppKit
import SwiftUI

struct MultilineTextEditor: NSViewRepresentable {
    @Binding var text: String
    var onCommit: () -> Void

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: MultilineTextEditor

        init(_ parent: MultilineTextEditor) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            if let textView = notification.object as? NSTextView {
                parent.text = textView.string
            }
        }

        @objc func handleKeyDown(_ event: NSEvent) {
            if event.keyCode == 36 && 
!event.modifierFlags.contains(.shift) { // Enter key without Shift
                parent.onCommit()
                event.preventDefault = true
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        let textView = scrollView.documentView as! NSTextView
        textView.delegate = context.coordinator
        textView.isRichText = false
        textView.font = .systemFont(ofSize: 14)
        textView.isHorizontallyResizable = false
        textView.autoresizingMask = [.width]
        textView.textColor = .labelColor
        textView.backgroundColor = .textBackgroundColor
        textView.allowsUndo = true
        textView.string = text
        textView.postsFrameChangedNotifications = true
        textView.postsBoundsChangedNotifications = true

        NotificationCenter.default.addObserver(context.coordinator, 
selector: #selector(Coordinator.handleKeyDown(_:)), name: 
NSTextView.didChangeSelectionNotification, object: textView)
        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        let textView = nsView.documentView as! NSTextView
        if textView.string != text {
            textView.string = text
        }
    }
}

struct BOBPortalView: View {
    let modelMap = [
        "devstral": "devstral:24b",
        "codegeex4": "codegeex4:latest",
        "phi4r": "phi4-reasoning:plus"
    ]

    @State private var models = ["devstral", "codegeex4", "phi4r"]
    @State private var activeModel = "devstral"
    @State private var input = ""
    @State private var responses: [String: [ChatMessage]] = [
        "devstral": [], "codegeex4": [], "phi4r": []
    ]
    @State private var sharedSummary = "Shared summary will appear here."
    @State private var threadList: [ThreadMeta] = []
    @State private var editingTitle: UUID? = nil
    @State private var threadSummaries: [UUID: String] = [:]
    @State private var currentThreadID: UUID? = nil
    @State private var summaryFlare: UUID? = nil
    private var monitorTimer = Timer.publish(every: 3.0, on: .main, in: 
.common).autoconnect()

    var body: some View {
        HStack {
            List {
                ForEach(threadList) { thread in
                    VStack(alignment: .leading) {
                        Text(thread.title)
                            .onTapGesture {
                                loadThread(thread)
                            }
                        if let summary = threadSummaries[thread.id] {
                            Text(summary)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }

            VStack {
                Picker("Model", selection: $activeModel) {
                    ForEach(models, id: \.self) { model in
                        Text(model).tag(model)
                    }
                }.pickerStyle(MenuPickerStyle())

                MultilineTextEditor(text: $input) {
                    sendPrompt()
                }
                .frame(height: 100)
                .cornerRadius(8)

                List(responses[activeModel] ?? [], id: \.id) { msg in
                    Text(msg.content)
                        .padding(.vertical, 5)
                        .foregroundColor(msg.role == "user" ? .blue : 
.black)
                }
            }.padding()
        }
    }

    private func sendPrompt() {
        guard !input.trimmingCharacters(in: 
.whitespacesAndNewlines).isEmpty else { return }
        let userMsg = ChatMessage(role: "user", content: input)
        responses[activeModel, default: []].append(userMsg)

        let model = modelMap[activeModel] ?? activeModel
        let prompt = input.replacingOccurrences(of: "\"", with: "\\\"")

        let inputPipe = 
FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".boFileManager.default.homeDirectoryForCurrentUser.appndingPathComponent(".bob_input_pipe")
        let outputPipe = 
FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".boFileManager.default.homeDirectoryForCurrentUser.apendingPathComponent(".bob_output_pipe")

        DispatchQueue.global(qos: .background).async {
            do {
                let writer = try FileHandle(forWritingTo: inputPipe)
                let inputLine = "{\"model\": \"\(model)\", \"prompt\": 
\"\(prompt)\"}\n"
                if let data = inputLine.data(using: .utf8) {
                    writer.write(data)
                    try writer.close()
                }

                let reader = try FileHandle(forReadingFrom: outputPipe)
                let replyData = try reader.readToEnd() ?? Data()
                try reader.close()

                if let output = String(data: replyData, encoding: 
.utf8)?.trimmingCharacters(in: .whitespacesAndNewlines), !output.isEmpty {
                    let replyMsg = ChatMessage(role: activeModel, content: 
output)
                    DispatchQueue.main.async {
                        responses[activeModel, default: 
[]].append(replyMsg)
                    }
                }
            } catch {
                print("⚠️ pipe error: \(error.localizedDescription)")
            }
        }

        input = ""
    }
}
#endif

