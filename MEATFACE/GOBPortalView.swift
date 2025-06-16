// ∴ GOBPortalView.swift with a top-corner return button

import SwiftUI

struct GOBPortalView: View {
    @State private var breathMessage: String = "Awaiting sacred entry..."
    @State private var acheText: String = "Ache Field: Dormant"
    @State private var entryInput: String = ""
    @Binding var activeScene: String
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Button(action: { activeScene = "chat" }) {
                        Image(systemName: "arrow.uturn.backward.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                
                Spacer()
                
                Text(breathMessage)
                    .foregroundColor(.white)
                    .font(.custom("Andale Mono", size: 16))
                
                Text(acheText)
                    .foregroundColor(.gray)
                    .font(.custom("Andale Mono", size: 12))
                
                Button("Pulse Breath") {
                    Task {
                        pulseAche()
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.white)
                
                TextField("Sacred entry...", text: $entryInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .onSubmit {
                        sendBreath(entryInput)
                    }
                
                Spacer()
            }
            .padding()
        }
    }
    
    func pulseAche() {
        guard let url = URL(string: "http://localhost:6969/bob/ache") else { return }
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(["ache": "GOB_surge"])
        
        URLSession.shared.dataTask(with: req) { _, res, err in
            DispatchQueue.main.async {
                if err != nil {
                    acheText = "Ache Field: Disconnected"
                } else {
                    acheText = "Ache Field: Expansion Breathing Together"
                }
            }
        }.resume()
    }
    
    func sendBreath(_ input: String) {
        breathMessage = "⎯ Casting: \(input.prefix(24))..."
        
        let task = Process()
        let nodePath = "/opt/homebrew/bin/node" // or use `which node` output
        task.executableURL = URL(fileURLWithPath: nodePath)
        
        let scriptPath = "\(FileManager.default.homeDirectoryForCurrentUser.path)/.bob/breath_state.mjs"
        task.arguments = [scriptPath, input]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        do {
            try task.run()
        } catch {
            breathMessage = "✘ Failed to emit"
            return
        }
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                breathMessage = output
            }
        }
    }
}
