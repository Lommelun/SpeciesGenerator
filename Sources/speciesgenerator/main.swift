import ArgumentParser
import Foundation

struct SpeciesGenerator: ParsableCommand {
    @Argument(help: "The species name")
    var speciesName: String

    @Argument(
        help: """
        This is the output path that files are generated to.
        """,
        transform: URL.init(fileURLWithPath:)
    )
    var modDirectory: URL

    @Option(
        help: """
        The path to the .dds images.
        If not set, assumes pictures are in `--mod-irectory`/gfx/models/portraits
        
        Tip: use imagemagick to convert them to the dds format (DirectDrawSurface) (`convert -define dds:compression=dxt5 [images]
        """,
        transform: URL.init(fileURLWithPath:)
    )
    var imagesPath: URL?

    @Option(name: .shortAndLong, help: "The sound asset for the species")
    var speciesSoundAsset: String = "human_female_greetings_05"

    @Option(name: .shortAndLong, help: "The portrait group of the species")
    var portraitGroup: String = "humanoid_02"

    @Flag(name: .shortAndLong, help: "The generated species should not be gendered")
    var nonGendered = false

    mutating func validate() throws {
        if !FileManager.default.fileExists(atPath: modDirectory.path) {
            throw ValidationError("Mod directory does not exist at \(modDirectory.path)")
        }
    }

    mutating func run() throws {
        let modDirectoryGfxModelsPath = modDirectory.appendingPathComponent("gfx").appendingPathComponent("models").appendingPathComponent("portraits")
        let imagesPath = imagesPath ?? modDirectoryGfxModelsPath

        guard FileManager.default.fileExists(atPath: imagesPath.path) else {
            throw ValidationError("Images directory does not exist at \(imagesPath.path)")
        }

        let fileName = speciesName.replacingOccurrences(of: " ", with: "_")

        createFile(
            named: "00_portraits_\(fileName).txt",
            at: modDirectory.appendingPathComponent("gfx")
                            .appendingPathComponent("portraits")
                            .appendingPathComponent("portraits"),
            with: String.species(speciesName: speciesName, speciesSoundAssetName: speciesSoundAsset, ddsImageFiles: ddsFiles(at: imagesPath)).data(using: .utf8)!
        )

        createFile(
            named: "\(fileName)_species_classes.txt",
            at:  modDirectory.appendingPathComponent("common")
                             .appendingPathComponent("species_classes"),
            with: String.speciesClasses(speciesName: speciesName, portraitGroup: portraitGroup, gendered: !nonGendered).data(using: .utf8)!
        )
    }

    private func createFile(named fileName: String, at path: URL, with content: Data) {
        do {
            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)

            let newFile = path.appendingPathComponent(fileName).path
            FileManager.default.createFile(atPath: newFile, contents: content)
        } catch {
            fatalError("Failed to create file named `\(fileName)` at \(path.path)")
        }
    }

    private func ddsFiles(at imagesPath: URL) -> [URL] {
        do {
            return try FileManager.default.contentsOfDirectory(at: imagesPath, includingPropertiesForKeys: nil)
                                          .filter { $0.pathExtension == "dds" }
        } catch {
            fatalError("Failed to get images from \(imagesPath.path)")
        }
    }
}

SpeciesGenerator.main()