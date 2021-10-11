import Foundation

extension String {
    public static func species(speciesName: String, speciesSoundAssetName: String, ddsImageFiles: [URL]) -> String {
        let ddsImageMap = ddsImageFiles.map { filePath in 
            (name: filePath.deletingPathExtension().lastPathComponent, fileName: filePath.lastPathComponent)
        }

        let portraits = ddsImageMap.enumerated().map { index, imageMap in
            "\(imageMap.name) = { greeting_sound = \"\(speciesSoundAssetName)\" texturefile = \"gfx/models/portraits/\(imageMap.fileName)\" }"
        }

        let portraitNames = ddsImageMap.map { $0.name }

        let defaultPortrait = portraitNames.first(where: { $0.starts(with: "portrait") }) ?? portraitNames.first ?? ""

        return """
        ### Generated by SpeciesGenerator cli tool

        portraits = {
            \(portraits.joined(separator: "\n    "))
        }

        portrait_groups = {
            \(speciesName) = {
                default = \(defaultPortrait)
                game_setup = { #will run with a limited country scope. species and government is set but the country does not actually exist
                    add = {
                        portraits = {
                            \(portraitNames.joined(separator: "\n                    "))
                        }
                    }
                }

                #species scope
                species = { #generic portrait for a species
                    add = {
                        portraits = {
                            \(portraitNames.joined(separator: "\n                    "))
                        }
                    }
                }

                #pop scope
                pop = { #for a specific pop
                    add = {
                        portraits = {
                            \(portraitNames.joined(separator: "\n                    "))
                        }
                    }
                }

                #leader scope
                leader = { #scientists, generals, admirals, governor
                    add = {
                        portraits = {
                            \(portraitNames.joined(separator: "\n                    "))
                        }
                    }
                }


                #leader scope
                ruler = {
                    add = {
                        portraits = {
                            \(portraitNames.joined(separator: "\n                    "))
                        }
                    }
                }
            }
        }

        """
    }
}