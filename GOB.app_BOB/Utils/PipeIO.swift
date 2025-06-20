// ∴ PipeIO.swift

import Foundation

func writeToPipe(path: URL, message: String) throws {
    let handle = try FileHandle(forWritingTo: path)
    if let data = message.data(using: .utf8) {
        handle.write(data)
        try handle.close()
    }
}

func readFromPipe(path: URL) throws -> String? {
    let handle = try FileHandle(forReadingFrom: path)
    let data = try handle.readToEnd() ?? Data()
    try handle.close()
    return String(data: data, encoding: .utf8)
}
