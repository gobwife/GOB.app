//
//  OLine.swift
//  ø
//
//  Created by bob gob solar on 6/20/25.
//  handles ollamacommunication

import Foundation

class OLine: ObservableObject {
    @Published var response: String = ""
    @Published var isLoading: Bool = false

    func sendMessage(_ message: String, completion: @escaping (String?) ->
Void) {
        guard !message.isEmpty else {
            completion(nil)
            return
        }

        self.isLoading = true

        // Assuming Ollama runs a local HTTP server on port 5001
        let url = URL(string: "http://localhost:5555/api/v1/chat")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
"Content-Type")

        let body: [String: Any] = [
            "model": "local-model",
            "messages": [["role": "user", "content": message]]
        ]

        request.httpBody = try! JSONSerialization.data(withJSONObject:
body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data,
response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    completion("Error: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    completion("No data received")
                    return
                }

                do {
                    if let jsonResponse = try
JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let choices = jsonResponse["choices"] as? [[String:
Any]],
                       let firstChoice = choices.first,
                       let message = firstChoice["message"] as? [String:
Any],
                       let content = message["content"] as? String {
                        completion(content)
                    } else {
                        completion("Invalid response format")
                    }
                } catch {
                    completion("Error parsing response: 
\(error.localizedDescription)")
                }
            }
        }

        task.resume()
    }
}
