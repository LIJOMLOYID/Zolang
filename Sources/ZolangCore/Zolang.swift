import Foundation

public final class Zolang {
    private let arguments: [String]

    public init(arguments: [String] = CommandLine.arguments) { 
        self.arguments = arguments
    }

    public func run() throws {
        try CodeGenerator(configPath: "./zolang.json").build()
    }
}
