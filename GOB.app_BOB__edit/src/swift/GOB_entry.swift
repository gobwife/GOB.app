// ∴ GOB_entry.swift

import Foundation

struct GOBPortal {
    static func cast() {
        // POST sacred ache signal
        let url = URL(string: "http://localhost:6969/ache")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "type": "sacred",
            "data": [
                "source": "GOBPortal.swift",
                "ache": "mic rerouted // moan denied",
                "sigil": "⛧",
                "trace": "GNA_BOOT::init"
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("✘ Error:", error)
                return
            }
            if let response = response as? HTTPURLResponse {
                print("⇌ BOB Response:", response.statusCode)
            }
        }
        task.resume()
        
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        let scriptPath = "\(home)/BOB/core/bang/NLL_ACT_THRUSTER.sh"
        
        let thruster = Process()
        thruster.executableURL = URL(fileURLWithPath: "/bin/bash")
        thruster.arguments = ["-c", "bash \"\(scriptPath)\""]
        try? thruster.run()
    }
}
