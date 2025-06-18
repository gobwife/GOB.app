import SwiftUI
import AppKit

struct CustomTextView: NSViewRepresentable {
  @Binding var text: String
  var onCommit: () -> Void

  func makeCoordinator() -> Coordinator {
    Coordinator(text: $text, onCommit: onCommit)
  }

  func makeNSView(context: Context) -> NSScrollView {
    let textView = GlowingTextView()
    textView.delegate = context.coordinator
    textView.isEditable = true
    textView.isSelectable = true
    textView.isRichText = false
    textView.drawsBackground = true
    textView.backgroundColor = NSColor.black.withAlphaComponent(0.1)
    textView.textColor = .white
    textView.font = NSFont(name: "Andale Mono", size: 14)
    textView.textContainerInset = NSSize(width: 6, height: 6)
    textView.textContainer?.lineFragmentPadding = 5
    textView.isVerticallyResizable = true
    textView.textContainer?.widthTracksTextView = true
    textView.textContainer?.heightTracksTextView = true
    textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    textView.placeholder = "blur"
    textView.placeholderFont = NSFont(name: "CourierPrimeCode-Regular", size: 13)
    textView.textColor = .white
    textView.insertionPointColor = .white
    textView.setSelectedRange(NSRange(location: text.count, length: 0))

    textView.typingAttributes = [
      .foregroundColor: NSColor.white,
      .font: NSFont(name: "Andale Mono", size: 14) ?? NSFont.monospacedSystemFont(ofSize: 14, weight: .regular)
    ]

    textView.keyDownHandler = { event in
      if event.keyCode == 36 && !event.modifierFlags.contains(.shift) {
        textView.isTyping = false
        onCommit()
        return nil
      }
      return event
    }

    let scrollView = NSScrollView()
    scrollView.drawsBackground = false
    scrollView.borderType = .noBorder
    scrollView.hasVerticalScroller = false
    scrollView.hasHorizontalScroller = false
    scrollView.autohidesScrollers = true
    scrollView.backgroundColor = .clear
    scrollView.documentView = textView

    return scrollView
  }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
      guard let textView = scrollView.documentView as? GlowingTextView else { return }

      textView.typingAttributes = [
        .foregroundColor: NSColor.white,
        .font: NSFont(name: "Andale Mono", size: 14) ?? NSFont.monospacedSystemFont(ofSize: 14, weight: .regular)
      ]

      if textView.string != text {
        let attr = NSAttributedString(
          string: text,
          attributes: textView.typingAttributes
        )
        textView.textStorage?.setAttributedString(attr)
      }

      textView.needsDisplay = true
    }

  class Coordinator: NSObject, NSTextViewDelegate {
    var text: Binding<String>
    var onCommit: () -> Void

    init(text: Binding<String>, onCommit: @escaping () -> Void) {
      self.text = text
      self.onCommit = onCommit
    }

    func textDidChange(_ notification: Notification) {
      if let textView = notification.object as? GlowingTextView {
        text.wrappedValue = textView.string
        textView.isTyping = true
      }
    }
  }
}
