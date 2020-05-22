//
//  Copyright © 2016 Apparata. All rights reserved.
//

import Foundation

public class IntTextFieldFormat: TextFieldFormat {
    
    private let digitsRegex = Regex("^\\d+$")
    
    private let range: CountableClosedRange<Int>?
    
    public init() {
        range = nil
    }
    
    public init(range: CountableClosedRange<Int>) {
        self.range = range
    }
    
    public func shouldChangeText(text: String, newText: String, replacement: String, inRange: NSRange) -> Bool {
        if newText == "" {
            return true
        }
        if newText == "0" {
            return true
        }
        if newText.hasPrefix("0") {
            return false
        }
        if digitsRegex.isMatch(newText) {
            if let value = Int(newText) {
                if let valueRange = range {
                    let minValue = valueRange.min() ?? 0
                    let maxValue = valueRange.max() ?? 0
                    if ((minValue >= 0) && (maxValue >= 0)) || ((minValue < 0) && (maxValue < 0)) {
                        if maxValue > 0 {
                            return value < maxValue
                        } else {
                            return value > minValue
                        }
                    } else {
                        if case valueRange = value {
                            return true
                        } else {
                            return false
                        }
                    }
                } else {
                    return true
                }
            } else {
                return false
            }
        } else {
            return false
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
        return (string, cursorPosition)
    }
}
