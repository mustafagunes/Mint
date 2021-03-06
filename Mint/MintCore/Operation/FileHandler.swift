//
//  FileHandler.swift
//  Mint
//
//  Created by Mustafa GUNES on 30.11.2019.
//  Copyright © 2019 Mustafa GUNES. All rights reserved.
//

import Foundation

struct FileData {
    let input: String
    let output: String?
}

class FileHandler {
    
    /// Mint: The file is read from the given path.
    /// - Parameter arguments: Commandline Arguments.
    /// - Return: FileData. Optional.
    static func readFile(from arguments: Commandline) -> FileData? {
        let outputFileData = try? String(contentsOf: arguments.outputURL)
        guard let inputFileData = try? String(contentsOf: arguments.inputURL) else { return nil }
        return FileData(input: inputFileData, output: outputFileData)
    }
    
    /// Mint:
    /// - Parameters:
    ///   - outputString: The value of the String to write.
    ///   - arguments: Commandline Arguments
    static func writeOutput(outputString: String, to arguments: Commandline) throws {
        let doWrite = {
            try outputString.write(to: arguments.outputURL, atomically: true, encoding: .utf8)
        }

        if let fileData = readFile(from: arguments), let existingSwift = fileData.output {
            if existingSwift != outputString {
                try doWrite()
            }
        } else {
            try doWrite()
        }
        fputs(ANSIColors.green.rawValue + "Language keys generated.", stderr)
    }
}
