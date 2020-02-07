//
//  OutputGenerator.swift
//  Mint
//
//  Created by Mustafa GUNES on 6.02.2020.
//  Copyright © 2020 Mustafa GUNES. All rights reserved.
//

import Foundation

public class OutputGenerator {
    
    var lines: [String] = []
        
        init() {
            append("""
    //
    // Autogenerated by Mint
    // Do not change this file manually!
    //

    import Foundation

    // MARK: - Localizations
    """)
    }
        
    var content: String {
        return lines.joined()
    }
    
    /// Mint: Sets the carriage return and down row settings.
    /// - Parameters:
    ///   - string: The value of the text to write.
    ///   - depth: Carriage return value.
    ///   - newLineCount: newLine value.
    public func append(_ string: String, depth: Int = 0, newLineCount: Int = 1) {
        let depthString = String(repeating: "\t", count: depth)
        let newLineString = String(repeating: "\n", count: newLineCount)
        lines.append(depthString + string + newLineString)
    }
    
    /// Mint: Converts the received value to the struct structure.
    /// - Parameters:
    ///   - screenName: Needs screen name.
    ///   - translates: Needs translations.
    public func append(_ screenName: String, _ translates: [Translate]) {
        append("// MARK: - \(screenName) Keys", depth: 1)
        append("public struct \(screenName) {", depth: 1, newLineCount: 2)
        for translate in translates {
            append(translate)
        }
        append("}", depth: 1, newLineCount: 2)
    }
    
    /// Mint: Creates the keys.
    /// - Parameter translate: Needs translation.
    public func append(_ translate: Translate) {
        append("/// Base translation: " + translate.value, depth: 2)
        
        let localized = "NSLocalizedString(\"\(translate.key)\", comment: \"\")"
        if translate.hasParameters() {
            let parameters = translate.getParameters().map({ return $0 + ": String"}).joined(separator: ", ")
            append("public static func \(translate.getAttributeName())(\(parameters)) -> String {", depth: 2)
            append("var keyValue = \(localized)", depth: 3)
            for parameter in translate.getParameters() {
                append("keyValue = keyValue.replacingOccurrences(of: \"{\(parameter)}\", with: \(parameter))", depth: 3)
            }
            append("return keyValue", depth: 3)
            append("}", depth: 2, newLineCount: 2)
        } else {
            append("public static var \(translate.getAttributeName()): String = \(localized)", depth: 2, newLineCount: 2)
        }
    }
}
