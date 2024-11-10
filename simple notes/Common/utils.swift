//
//  utils.swift
//  simple notes
//
//  Created by Manuel Braun on 10.11.24.
//

import Foundation

/// truncates the string and add 3 dots at the end
/// - Parameters:
///   - text: the string you want to truncate
///   - limit: the maximun chars of the string
/// - Returns: the original string or the truncated string
func truncatedText(_ text: String, limit: Int) -> String {
    if text.count > limit {
        let endIndex = text.index(text.startIndex, offsetBy: limit)
        return text[..<endIndex] + "..."
    } else {
        return text
    }
}
