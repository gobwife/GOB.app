// ∴ ResponseSummaryPopup.swift
// Displays foil and summaries in a floating panel inside MEATFACE
// 6.15.25

import SwiftUI

struct ResponseSummaryPopup: View {
  @Binding var isVisible: Bool
  let foil: String?
  let summary1: String?
  let summary2: String?

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      if let foil = foil {
        Text("Foil:")
          .font(.headline)
        Text(foil)
      }
      if let summary1 = summary1 {
        Text("Summary 1:")
          .font(.headline)
        Text(summary1)
      }
      if let summary2 = summary2 {
        Text("Summary 2:")
          .font(.headline)
        Text(summary2)
      }
    }
    .padding()
    .background(Color.black.opacity(0.8))
    .cornerRadius(10)
    .frame(maxWidth: 360, alignment: .leading)
    .foregroundColor(.white)
  }
}
