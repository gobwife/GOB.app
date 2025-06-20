// ∴ ThreadListView.swift

import SwiftUI

struct ThreadListView: View {
    let threads: [ThreadMeta]
    let summaries: [UUID: String]
    let onSelect: (ThreadMeta) -> Void

    var body: some View {
        List {
            ForEach(threads) { thread in
                VStack(alignment: .leading) {
                    Text(thread.title)
                        .onTapGesture { onSelect(thread) }
                    if let summary = summaries[thread.id] {
                        Text(summary)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}
