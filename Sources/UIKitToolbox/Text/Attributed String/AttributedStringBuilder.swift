//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

import Foundation

public final class AttributedStringBuilder {
    
    private var assembledString = NSMutableAttributedString()
    
    public init() {}
    
    public func build() -> NSAttributedString {
        return NSAttributedString(attributedString: assembledString)
    }
    
    public var description: String {
        return build().string
    }
    
    // MARK: - Builder functions
    
    @discardableResult
    public func space(_ count: Int = 1, _ attributes: [NSAttributedString.Key: Any]? = nil) -> AttributedStringBuilder {
        let spaces = String(repeating: " ", count: count)
        return text(spaces, attributes)
    }
    
    @discardableResult
    public func newline(_ count: Int = 1, _ attributes: [NSAttributedString.Key: Any]? = nil) -> AttributedStringBuilder {
        let newlines = String(repeating: " ", count: count)
        return text(newlines, attributes)
    }
    
    @discardableResult
    public func text(_ string: String, _ attributes: [NSAttributedString.Key: Any]? = nil) -> AttributedStringBuilder {
        if let attributes = attributes {
            assembledString.append(NSAttributedString(string: string, attributes: attributes))
        } else {
            assembledString.append(NSAttributedString(string: string))
        }
        return self
    }
}


// MARK: - Overloaded operators for creating attributed strings.

// Example:
// let bold = [NSFontAttributeName: UIFont.boldSystemFontOfSize(UIFont.systemFontSize())]
// let green = [NSForegroundColorAttributeName: UIColor.greenColor()]
// let text: NSMutableAttributedString = ("This is bold ", bold) + " - plain - " + ("This is green ", green)

func + (left: NSMutableAttributedString, right: (String, [NSAttributedString.Key: Any])) -> NSMutableAttributedString {
    let (string, attributes) = right
    let attributedString = NSAttributedString(string: string, attributes: attributes)
    left.append(attributedString)
    return left
}

func + (left: (String, [NSAttributedString.Key: Any]), right: (String, [NSAttributedString.Key: Any])) -> NSMutableAttributedString {
    let (leftString, leftAttributes) = left
    let (rightString, rightAttributes) = right
    let leftAttributedString = NSMutableAttributedString(string: leftString, attributes: leftAttributes)
    let rightAttributedString = NSAttributedString(string: rightString, attributes: rightAttributes)
    leftAttributedString.append(rightAttributedString)
    return leftAttributedString
}

func + (left: (String, [NSAttributedString.Key: Any]), right: String) -> NSMutableAttributedString {
    let (leftString, leftAttributes) = left
    let leftAttributedString = NSMutableAttributedString(string: leftString, attributes: leftAttributes)
    let rightAttributedString = NSAttributedString(string: right)
    leftAttributedString.append(rightAttributedString)
    return leftAttributedString
}

