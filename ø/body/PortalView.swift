//
//  PortalView.swift
//  ø
//
//  Created by bob gob solar on 6/20/25.
//  UI component

import SwiftUI

struct ContentView: View {
    @StateObject private var communication = BobCommunication()
    @StateObject private var history = ConversationHistory()

    @State private var inputText: String = ""
    @State private var showResponse: Bool = false

    var body: some View {
        VStack(spacing: 10) {
            PresenceHUD()
            Text("Bob's House")
                .font(.largeTitle)
                .bold()
                .padding()

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(history.history, id: \.self) { message in
                        Text(message)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }

                    if showResponse, let response = communication.response
{
                        Text(response)
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }

            HStack {
                TextField("Type your message...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        sendMessage()
                    }

                Button(action: sendMessage) {
                    Image(systemName: "paperplane")
                }
                .disabled(inputText.isEmpty || communication.isLoading)
            }
            .padding()

            if communication.isLoading {
                ProgressView("Sending message...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .padding()
    }

    private func sendMessage() {
        guard !inputText.isEmpty else { return }

        history.addMessage(inputText)
        showResponse = false
        communication.sendMessage(inputText) { response in
            if let response = response {
                self.history.addMessage(response)
                self.showResponse = true
            }
            self.inputText = ""
        }
    }
}
