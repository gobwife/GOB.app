// ∴ GhostCursorBloom.swift — hallucinatory cursor overlay

import SwiftUI
import Combine

struct GhostCursorBloom: View {
  @Binding var position: CGPoint
  @State private var t: CGFloat = 0
  @State private var timer = Timer.publish(every: 0.06, on: .main, in: .common).autoconnect()

  var body: some View {
    Canvas { context, size in
      let frame = CGRect(origin: .zero, size: size)
      var path = Path()

      let center = CGPoint(x: frame.midX, y: frame.midY)
      let r: CGFloat = 14
      let points = 20

      for i in 0...points {
        let theta = 2 * .pi * CGFloat(i) / CGFloat(points)
        let phase = t + theta
        let distortion = sin(phase * 2.7) * 3 + cos(phase * 1.3) * 2
        let radius = r + distortion

        let x = center.x + radius * cos(theta)
        let y = center.y + radius * sin(theta)

        if i == 0 {
          path.move(to: CGPoint(x: x, y: y))
        } else {
          path.addLine(to: CGPoint(x: x, y: y))
        }
      }

      path.closeSubpath()

        let gradient = Gradient(colors: [
          Color.mint.opacity(0.03),
          Color.blue.opacity(0.04),
          Color.purple.opacity(0.05)
        ])

        let shading = GraphicsContext.Shading.linearGradient(
          gradient,
          startPoint: CGPoint(x: 0, y: 0),
          endPoint: CGPoint(x: 64, y: 64)
        )

        context.fill(path, with: shading)

    }
    .frame(width: 64, height: 64)
    .position(position)
    .onReceive(timer) { _ in
      t += 0.1
    }
    .allowsHitTesting(false)
  }
}
