//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation

/// Text field format for Swedish personal numbers
/// TODO: Improve handling of the year 2020
/// TODO: Validate month, day and checksums.
public class PersonalNumberTextFieldFormat: TextFieldFormat {
    
    public init() { }
    
    public func shouldChangeText(text: String, newText: String, replacement: String, inRange: NSRange) -> Bool {
        let digits = replacement.compactMap { Int(String($0)) }
        if digits.count != replacement.count {
            return false
        }
        if newText.hasPrefix("19") || newText.hasPrefix("20") {
            return newText.count <= 13
        } else {
            return newText.count <= 11
        }
    }
    
    public func filtered(string: String, cursorPosition: Int) -> (String, Int) {
        
        var position = cursorPosition
        let cursorIndex = string.index(string.startIndex, offsetBy: cursorPosition)
        let chars = string
        
        var digits = ""
        for i in chars.indices {
            let char = String(chars[i])
            if let _ = Int(char) {
                digits += char
            } else {
                if i < cursorIndex {
                    position -= 1
                }
            }
        }
        
        return (digits, position)
    }
    
    public func formatted(string: String, cursorPosition: Int) -> (String, Int) {
        var position = cursorPosition
        var outputString = ""
        var i = 0
        let longForm = string.hasPrefix("19") || string.hasPrefix("20")
        for char in string {
            if i > 0 && i % (longForm ? 8 : 6) == 0 {
                outputString += "-"
                if i < cursorPosition {
                    position += 1
                }
            }
            outputString += String(char)
            i += 1
        }
        
        return (outputString, position)
    }
}
