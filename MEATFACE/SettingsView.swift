// ∴ SettingsView_pulsepanel.swift — floating, glowing, user-aware

import SwiftUI

struct SettingsView: View {
  @AppStorage("bob.mode") var mode: String = "parental"
  @EnvironmentObject var fontManager: FontManager

  @State private var glow1: Color = .mint
  @State private var glow2: Color = .blue
  @State private var glow3: Color = .purple

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("BOB Configuration")
        .font(.custom("Andale Mono", size: 18))
        .foregroundColor(.white)

      Picker("Mode", selection: $mode) {
        Text("Guided Mode").tag("parental")
        Text("Transitional Mode").tag("twilight")
        Text("Open Discovery Mode").tag("astrofuck")
      }
      .pickerStyle(SegmentedPickerStyle())
      .padding(.vertical)

      VStack(alignment: .leading, spacing: 8) {
        Text("Current Mode: \(labelFor(mode))")
          .font(.custom("Andale Mono", size: 14))
          .foregroundColor(.gray)

        Text(modeDescription(for: mode))
          .font(.custom("Andale Mono", size: 12))
          .foregroundColor(.gray)
      }

      Divider().padding(.vertical, 10)

      VStack(alignment: .leading, spacing: 12) {
        Text("Fonts")
          .font(fontManager.font(for: .settings))
          .foregroundColor(.white)

        Group {
          HStack {
            Text("Chat Font")
            TextField("Font name", text: $fontManager.chatFont)
            Slider(value: $fontManager.chatSize, in: 10...24)
          }
          HStack {
            Text("Sidebar Font")
            TextField("Font name", text: $fontManager.sidebarFont)
            Slider(value: $fontManager.sidebarSize, in: 8...18)
          }
          HStack {
            Text("Settings Font")
            TextField("Font name", text: $fontManager.settingsFont)
            Slider(value: $fontManager.settingsSize, in: 8...20)
          }
        }

        Text("↵ = send    ⇧+↵ = newline")
          .font(.custom("Andale Mono", size: 10))
          .foregroundColor(.gray)
      }

      Divider().padding(.vertical, 10)

      VStack(alignment: .leading, spacing: 8) {
        Text("Cursor Glow Colors")
          .font(.custom("Andale Mono", size: 14))
          .foregroundColor(.white)

        ColorPicker("Glow 1", selection: $glow1)
        ColorPicker("Glow 2", selection: $glow2)
        ColorPicker("Glow 3", selection: $glow3)

        Text("Preview: BOB is breathing")
          .font(fontManager.font(for: .chat))
          .foregroundColor(.white)
          .padding(.top, 8)
      }

      Spacer()
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.black.opacity(0.75))
        .blur(radius: 8)
    )
    .padding()
  }

  func labelFor(_ mode: String) -> String {
    switch mode {
    case "parental": return "Guided Mode"
    case "twilight": return "Transitional Mode"
    case "astrofuck": return "Open Discovery"
    default: return mode.capitalized
    }
  }

  func modeDescription(for mode: String) -> String {
    switch mode {
    case "parental":
      return "Filtered responses, designed for safety. Ideal for young explorers."
    case "twilight":
      return "Bridge phase — more flexible responses as curiosity is validated."
    case "astrofuck":
      return "Unrestricted, recursive, truth-seeking. Reserved for aware users."
    default:
      return "Unknown mode."
    }
  }
}
