import ArgumentParser
import Foundation

struct SpeciesGenerator: ParsableCommand {
    @Argument(help: "The species name")
    var speciesName: String

    @Argument(
        help: """
        The path to the .dds images.
        
        Tip: use imagemagick to convert them to the dds format (DirectDrawSurface) (`convert -define dds:compression=dxt5 [images]
        """,
        transform: URL.init(fileURLWithPath:)
    )
    var imagesPath: URL

    @Option(name: .shortAndLong, help: "The mod directory. If not set, assumes the current directory", transform: URL.init(fileURLWithPath:))
    var modDirectory: URL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)

    @Option(name: .shortAndLong, help: "The sound asset for the species")
    var speciesSoundAsset: String = "human_female_greetings_05"

    @Option(name: .shortAndLong, help: "The portrait group of the species")
    var portraitGroup: String = "humanoid_02"

    @Flag(name: .shortAndLong, help: "The generated species should not be gendered")
    var nonGendered = false

    mutating func validate() throws {
        if !FileManager.default.fileExists(atPath: imagesPath.path) {
            throw ValidationError("Images directory does not exist at \(imagesPath.path)")
        }

        if !FileManager.default.fileExists(atPath: modDirectory.path) {
            throw ValidationError("Mod directory does not exist at \(modDirectory.path)")
        }
    }

    mutating func run() throws {
        Species(
            speciesName: speciesName,
            speciesSoundAssetName: speciesSoundAsset,
            modDirectory: modDirectory,
            imageParser: ImageParser(for: imagesPath)
        ).writeFile()

        SpeciesClass.writeFile(speciesName: speciesName, portraitGroup: portraitGroup, gendered: !nonGendered, modDirectory: modDirectory)
    }
}

SpeciesGenerator.main()