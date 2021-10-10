import Foundation

class FM {
    static func createFile(named fileName: String, at path: URL, with content: Data) {
        do {
            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)

            let newFile = path.appendingPathComponent(fileName).path
            FileManager.default.createFile(atPath: newFile, contents: content)
        } catch {
            fatalError("Failed to create file named `\(fileName)` at \(path.path)")
        }
    }
}