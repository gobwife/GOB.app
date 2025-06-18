import AppKit

class GlowingTextView: NSTextView {
  var placeholder: String?
  var placeholderFont: NSFont?
  var isTyping: Bool = false {
    didSet { needsDisplay = true }
  }

  var keyDownHandler: ((NSEvent) -> NSEvent?)?

  override func keyDown(with event: NSEvent) {
    if event.keyCode == 36 && !event.modifierFlags.contains(.shift) {
      _ = keyDownHandler?(event)
      return
    }
    super.keyDown(with: event)
  }

  override var isFlipped: Bool { true }

  override func becomeFirstResponder() -> Bool {
    self.needsDisplay = true
    return super.becomeFirstResponder()
  }

  override func resignFirstResponder() -> Bool {
    self.needsDisplay = true
    return super.resignFirstResponder()
  }

  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)

    let t = CFAbsoluteTimeGetCurrent()
    let pulse = abs(sin(t * 1.8))
    let phase = CGFloat(t.truncatingRemainder(dividingBy: 10.0)) / 10.0

    let hue = phase < 0.5
      ? interpolate(from: 0.55, to: 0.67, progress: phase * 2)
      : interpolate(from: 0.67, to: 0.83, progress: (phase - 0.5) * 2)

    let glowColor = NSColor(hue: hue, saturation: 0.8, brightness: 1.0, alpha: 0.8)

      if string.isEmpty, let placeholder = placeholder {
          let paragraph = NSMutableParagraphStyle()
          paragraph.alignment = .left

          let shadow = NSShadow()
          shadow.shadowColor = glowColor
          shadow.shadowOffset = .zero
          shadow.shadowBlurRadius = 8 + 2 * pulse

          let attrs: [NSAttributedString.Key: Any] = [
              .foregroundColor: glowColor,
              .font: placeholderFont ?? NSFont.monospacedSystemFont(ofSize: 13, weight: .regular),
              .paragraphStyle: paragraph,
              .shadow: shadow
          ]

          placeholder.draw(in: bounds.insetBy(dx: 10, dy: 8), withAttributes: attrs)
      }

    if window?.firstResponder == self || isTyping {
      let path = NSBezierPath(roundedRect: bounds.insetBy(dx: 1.5, dy: 1.5), xRadius: 6, yRadius: 6)
      glowColor.setStroke()
      path.lineWidth = 1.0 + pulse
      path.stroke()
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
      self.needsDisplay = true
    }
  }

  private func interpolate(from: CGFloat, to: CGFloat, progress: CGFloat) -> CGFloat {
    from + (to - from) * progress
  }
}
