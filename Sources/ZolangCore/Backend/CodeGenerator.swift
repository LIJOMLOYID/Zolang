//
//  CodeGenerator.swift
//  ZolangCore
//
//  Created by Þorvaldur Rúnarsson on 17/09/2018.
//

import Foundation

public struct CodeGenerator {

    let config: Config
    
    private let fileManager = FileManager.default

    public init(configPath: String) throws {
        self.config = try Config(filePath: configPath)
    }
    
    func build() throws {
        let parsed = try self.config.buildSettings
            .map { setting -> (setting: Config.BuildSetting, syntaxTrees: [CodeBlock]) in
                let syntaxTrees = try fileManager
                    .listFiles(path: setting.sourcePath)
                    .map(Parser.init)
                    .map { try $0.parse() }
                return (setting, syntaxTrees)
            }
            
        parsed.forEach { arg in
            let (setting, syntaxTrees) = arg
            
            var errors: [Error] = []
            syntaxTrees.forEach { ast in
                do {
                    let generated = try ast.compile(buildSetting: setting, fileManager: self.fileManager)

                    print("---$$$---GEN:")
                    print(generated)
                    print("---$$$---END")
                } catch {
                    errors.append(error)
                }
            }
            
            if errors.isEmpty == false {
                let error = errors
                    .map {
                        "Error: \($0.localizedDescription)"
                    }
                    .joined(separator: "\n--------------------------------------\n")
                print(error)
                exit(1)
            }
            
        }
    }
}
