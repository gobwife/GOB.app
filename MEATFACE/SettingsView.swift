import SwiftUI

struct SettingsView: View {
  @AppStorage("bob.mode") var mode: String = "parental" // parental | twilight | astrofuck

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

      Spacer()
    }
    .padding()
    .background(Color.black.edgesIgnoringSafeArea(.all))
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

@EnvironmentObject var fontManager: FontManager

VStack {
  Text("Fonts")
    .font(fontManager.font(for: .settings))
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
