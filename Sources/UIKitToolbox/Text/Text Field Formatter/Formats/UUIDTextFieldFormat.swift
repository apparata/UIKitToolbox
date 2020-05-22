//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation

/// Text field format for 8-4-4-4-12 UUIDs.
public class UUIDTextFieldFormat: TextFieldFormat {
    
    public init() { }
    
    public func shouldChangeText(text: String, newText: String, replacement: String, inRange: NSRange) -> Bool {
        return newText.count <= 36
    }
    
    public func filtered(string: String, cursorPosition: Int) -> (String, Int) {
        
        var position = cursorPosition
        let cursorIndex = string.index(string.startIndex, offsetBy: cursorPosition)
        let chars = string
        
        var digits = ""
        for i in chars.indices {
            let c = chars[i]
            let char = String(c).uppercased()
            if Int(char) != nil || "ABCDEF".contains(char) {
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
        for char in string {
            if i == 8 || i == 12 || i == 16 || i == 20 {
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
