// ∴ ThreadViewModel.swift

import Foundation

class ThreadViewModel {

    private let threadStorage: ThreadStorage
    private let shellCommandExecutor: ShellCommandExecutor

    init(threadStorage: ThreadStorage = ThreadStorage(), shellCommandExecutor: ShellCommandExecutor = ShellCommandExecutor()) {
        self.threadStorage = threadStorage
        self.shellCommandExecutor = shellCommandExecutor
    }

    func loadThreadList() -> [ThreadMeta] {
        return threadStorage.loadThreadList()
    }

    func saveThreadList(_ list: [ThreadMeta]) {
        threadStorage.saveThreadList(list)
    }

    func loadThread(_ thread: ThreadMeta) -> ([ChatMessage], String?) {
        return threadStorage.loadThread(thread)
    }

    func runShellCommand(_ command: String) throws -> String {
        return try shellCommandExecutor.runCommand(command)
    }

    func parseLatestOutput(from path: URL) -> String? {
        return shellCommandExecutor.parseLatestOutput(from: path)
    }
}

