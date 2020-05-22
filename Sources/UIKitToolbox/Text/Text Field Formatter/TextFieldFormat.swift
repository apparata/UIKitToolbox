//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation

/// Adopt the format protocol to create a format that TextFieldFormatter
/// can use to format a text field on the fly.
///
/// NOTE: The filteredString method will be called before the formattedString
///       method.
public protocol TextFieldFormat {
    /// Return false if the new text is too long, etc.
    func shouldChangeText(text: String, newText: String, replacement: String, inRange: NSRange) -> Bool
    
    /// Filter out characters that should not be in the string and move the
    /// cursor to the correct position in the filtered string.
    func filtered(string: String, cursorPosition: Int) -> (String, Int)
    
    /// Format the string after it has been filtered and move the cursor
    /// to the correct position in the formatted string.
    func formatted(string: String, cursorPosition: Int) -> (String, Int)
}
