import Foundation

class ImageParser {
    private let imagesPath: URL

    init(for imagesPath: URL) {
        self.imagesPath = imagesPath
    }

    func ddsFileNames() -> [String] {
        ddsFiles().map { $0.lastPathComponent }
    }

    func ddsFileNamesWithoutExtension() -> [String] {
        ddsFiles().map { $0.deletingPathExtension() }
                  .map { $0.lastPathComponent }
    }

    // Supports multiple path components, e.g gfx/models/portraits
    private func ddsFiles() -> [URL] {
        try! FileManager.default.contentsOfDirectory(at: imagesPath, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
                                .filter { $0.pathExtension == ".dds" }
    }

    private func removeExtension(from ddsFileNames: [URL]) -> [URL] {
        ddsFileNames
    }
}