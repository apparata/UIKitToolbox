//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

import Foundation

/// Text field format for YYYY-MM-DD dates
public class DateTextFieldFormat: TextFieldFormat {
    
    public enum TimePeriod {
        case inThePast
        case anytime
        case inTheFuture
    }
    
    private enum CharType {
        case digit
        case dash
    }
    
    private let dateFormatter = DateFormatter()
    
    private let regex = Regex("^[\\d-]*$")
    
    private var isErasing: Bool = false
    
    private var timePeriod: TimePeriod
    
    private var charTypes: [CharType] = [.digit, .digit, .digit, .digit, .dash,
                                         .digit, .digit, .dash, .digit, .digit]
    
    public init(timePeriod: TimePeriod = .anytime) {
        self.timePeriod = timePeriod
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "sv_SE")
    }
    
    public func shouldChangeText(text: String, newText: String, replacement: String, inRange: NSRange) -> Bool {
        
        isErasing = text.count > newText.count
        
        // Make sure this is only digits or dashes
        guard regex.isMatch(newText) else {
            return false
        }
        
        // Make sure string is not too long.
        guard newText.count <= "YYYY-MM-DD".count else {
            return false
        }
        
        // Make sure the digits and the dashes are in the right place.
        var i = 0
        for char in newText {
            let charType = charTypes[i]
            switch charType {
            case .digit:
                if char == "-" {
                    return false
                }
            case .dash:
                if char != "-" {
                    return false
                }
            }
            i += 1
        }
        
        // Make sure that the year is 19-- or 20--
        if newText.count == 1 {
            guard newText.hasPrefix("1") || newText.hasPrefix("2") else {
                return false
            }
        }
        if newText.count >= 2 {
            guard newText.hasPrefix("19") || newText.hasPrefix("20") else {
                return false
            }
        }
        
        let sixth = character(from: newText, at: 5)
        let seventh = character(from: newText, at: 6)
        let ninth = character(from: newText, at: 8)
        let tenth = character(from: newText, at: 9)
        
        if newText.count == 6 {
            guard sixth == "0" || sixth == "1" else {
                return false
            }
        }
        
        if newText.count > 6 {
            if sixth == "0" {
                guard seventh != "0" else {
                    return false
                }
            } else if sixth == "1" {
                guard seventh == "0" || seventh == "1" || seventh == "2" else {
                    return false
                }
            }
        }
        
        if newText.count == 9 {
            guard ninth == "0" || ninth == "1" || ninth == "2" || (ninth == "3" && !(sixth == "0" && seventh == "2")) else {
                return false
            }
        }
        
        if newText.count > 9 {
            if ninth == "0" {
                guard tenth != "0" else {
                    return false
                }
            } else if ninth == "3" {
                guard tenth == "0" || tenth == "1" else {
                    return false
                }
            }
        }
        
        // If the whole string is present, we can check if the date is
        // valid using a date formatter.
        if newText.count == "YYYY-MM-DD".count {
            guard let date = dateFormatter.date(from: newText) else {
                return false
            }
            if timePeriod == .inThePast {
                // Make sure the date is not newer than today
                guard date.timeIntervalSinceNow < 0 else {
                    return false
                }
            } else if timePeriod == .inTheFuture {
                
            }
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentDay = calendar.component(.day, from: currentDate)
        
        // If we have at least the year, we can check the year.
        if newText.count >= "YYYY".count {
            guard let year = Int(newText[newText.startIndex..<newText.index(newText.startIndex, offsetBy: 4)]) else {
                return false
            }
            if timePeriod == .inThePast, year > currentYear {
                return false
            } else if timePeriod == .inTheFuture, year < currentYear {
                return false
            }
            
            // If we have at least the year and the month and one digit
            // of the day, we can check the partial day.
            if newText.count >= "YYYY-M".count {
                guard let monthDigit = Int(newText[newText.index(newText.startIndex, offsetBy: 5)..<newText.index(newText.startIndex, offsetBy: 6)]) else {
                    return false
                }
                let partialMonth = monthDigit * 10
                
                if timePeriod == .inThePast {
                    if year == currentYear, partialMonth > currentMonth {
                        return false
                    }
                }
            }
            
            // If we have at least the year and the month, we can check the month.
            if newText.count >= "YYYY-MM".count {
                guard let month = Int(newText[newText.index(newText.startIndex, offsetBy: 5)..<newText.index(newText.startIndex, offsetBy: 7)]) else {
                    return false
                }
                
                if timePeriod == .inThePast {
                    if year == currentYear, month > currentMonth {
                        return false
                    }
                    
                } else if timePeriod == .inTheFuture {
                    if year == currentYear, month < currentMonth {
                        return false
                    }
                    
                }
                
                // If we have at least the year and the month and one digit
                // of the day, we can check the partial day.
                if newText.count >= "YYYY-MM-D".count {
                    guard let dayDigit = Int(newText[newText.index(newText.startIndex, offsetBy: 8)..<newText.index(newText.startIndex, offsetBy: 9)]) else {
                        return false
                    }
                    let partialDay = dayDigit * 10
                    
                    if timePeriod == .inThePast {
                        if year == currentYear, month == currentMonth, partialDay > currentDay {
                            return false
                        }
                    }
                }
            }
        }
        
        
        return true
    }
    
    private func character(from string: String, at index: Int) -> String {
        if index < string.count {
            return String(string[string.index(string.startIndex, offsetBy: index)])
        }
        return ""
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
            } else if char == "-" {
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
        let position = cursorPosition
        
        let isCursorAtEndOfString = position == string.count
        
        if isErasing, isCursorAtEndOfString, string.count == 4, position == 4 {
            let i = string.startIndex
            let j = string.index(i, offsetBy: 3)
            return (String(string[i..<j]), 4)
        }
        
        if isErasing, isCursorAtEndOfString, string.count == 7, position == 7 {
            let i = string.startIndex
            let j = string.index(i, offsetBy: 6)
            return (String(string[i..<j]), 7)
        }
        
        if !isErasing, string.count == 4 {
            return (string + "-", 5)
        }
        
        if !isErasing, string.count == 7 {
            return (string + "-", 8)
        }
        
        return (string, position)
    }
}

