//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation

public extension String {
    
    /// Returns an NSAttributedString, attributed based on markup in string
    /// and a dictionary where the tag is the key mapped to a dictionary
    /// of attributes.
    ///
    /// Tags can be nested. Attributes take precedence inside and out.
    ///
    /// Tags are writen with angular brackets `<tag>`. Closing tag names begin
    /// with a forward slash `</tag>`. Use `&lt;` and `&gt;` to escape angular
    /// brackets, as in HTML. `&amp;` escapes &.
    ///
    /// Example:
    /// ```
    /// let attributes: [String: [NSAttributedStringKey: AnyObject]] = [
    ///     "loud": [.font: UIFont.systemFont(ofSize: 40)],
    ///     "green": [.color: UIColor.green]
    /// ]
    ///
    /// let string = "Testing <loud>this <green>text</green></loud> thing.".attributed(with: attributes)
    /// ```
    ///
    /// - Parameter attributes: Dictionary where tag names are used as keys
    ///                         mapped to dictionaries of string attributes.
    /// - Returns: Returns attributed string or `nil` if tags were not used
    ///            correctly (e.g. no closing tag).
    ///
    func attributed(with attributes: TagString.Attributes) -> NSAttributedString? {
        return TagString(self).attributed(with: attributes)
    }
}

/// The `TagString` struct is a wrapper around strings that contain simple
/// markup for the purpose of easily creating `NSAttributedString`s.
///
/// Tags can be nested. Attributes take precedence inside and out.
///
/// Tags are writen with angular brackets `<tag>`. Closing tag names begin
/// with a forward slash `</tag>`. Use `&lt;` and `&gt;` to escape angular
/// brackets, as in HTML. `&amp;` escapes &.
///
/// Example:
/// ```
/// let attributes: [String: [NSAttributedStringKey: Any]] = [
///     "loud": [.font: UIFont.systemFont(ofSize: 40)],
///     "green": [.color: UIColor.green]
/// ]
///
/// let string: TagString = "Testing <loud>this <green>text</green></loud> thing."
/// string.attributed(with: attributes)
/// ```
///
public struct TagString {
    
    public typealias Attributes = [String: [NSAttributedString.Key: Any]]
    
    private enum TagStringToken {
        case text(String)
        case entity(String)
        case startTag(String)
        case endTag(String)
    }
    
    private let entities = ["lt": "<", "gt": ">", "amp": "&"]
    
    /// The raw string passed into the initializer.
    public let string: String
    
    public init(_ string: String) {
        self.string = string
    }
    
    /// Example:
    /// ```
    /// let attributes: [String: [NSAttributedStringKey: Any]] = [
    ///     "loud": [.font: UIFont.systemFont(ofSize: 40)],
    ///     "green": [.foregroundColor: UIColor.green]
    /// ]
    ///
    /// let string: TagString = "Testing <loud>this <green>text</green></loud> thing."
    /// string.attributed(with: attributes)
    /// ```
    ///
    /// - Parameter attributes: Dictionary where tag names are used as keys
    ///                         mapped to dictionaries of string attributes.
    /// - Returns: Returns attributed string or `nil` if tags were not used
    ///            correctly (e.g. no closing tag).
    ///
    public func attributed(with attributes: Attributes) -> NSAttributedString? {
        if let tokenizedText = tokenize(string: self.string) {
            return buildString(tokenizedText: tokenizedText, attributes: attributes)
        } else {
            return nil
        }
    }
    
    // MARK: - Tokenizer
    
    private func tokenize(string: String) -> [TagStringToken]? {
        
        var tokens = [TagStringToken]()
        
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = nil
        
        while !scanner.isAtEnd {
            if let textToken = scanText(scanner: scanner) {
                tokens.append(textToken)
            }
            
            if scanner.isAtEnd {
                break
            }
            
            if let tagToken = scanTag(scanner: scanner) {
                tokens.append(tagToken)
            } else if let entityToken = scanEntity(scanner: scanner) {
                tokens.append(entityToken)
            } else {
                return nil
            }
            
            
        }
        
        return tokens
    }
    
    private func scanTag(scanner: Scanner) -> TagStringToken? {
        guard scanner.scanString("<") != nil else {
            return nil
        }
        
        let isEndTag = scanner.scanString("/") != nil
        
        guard let tag = scanner.scanUpToString(">") else {
            return nil
        }
        
        let token: TagStringToken
        if let tag = tag as String? {
            token = isEndTag ? TagStringToken.endTag(tag) : TagStringToken.startTag(tag)
        } else {
            return nil
        }
        
        _ = scanner.scanString(">")
        
        return token
    }
    
    private func scanEntity(scanner: Scanner) -> TagStringToken? {
        guard scanner.scanString("&") != nil else {
            return nil
        }
        
        guard let entity = scanner.scanUpToString(";") else {
            return nil
        }
        
        let token: TagStringToken
        if let entity = entity as String? {
            token = TagStringToken.entity(entity)
        } else {
            return nil
        }
        
        _ = scanner.scanString(";")
        
        return token
        
    }
    
    private func scanText(scanner: Scanner) -> TagStringToken? {
        let tagOrEntityCharacters = CharacterSet(charactersIn: "<&")
        if let text = scanner.scanUpToCharacters(from: tagOrEntityCharacters) {
            return .text(text)
        }
        return nil
    }
    
    // MARK: - String builder
    
    private func buildString(tokenizedText: [TagStringToken], attributes: [String: [NSAttributedString.Key: Any]]) -> NSAttributedString? {
        
        var tagStack = [String]()
        
        let outputString = NSMutableAttributedString()
        
        for token in tokenizedText {
            switch token {
                
            case .text(let string):
                let currentAttributes = buildAttributes(tagStack: tagStack, attributes: attributes)
                let attributedString = NSAttributedString(string: string, attributes: currentAttributes)
                outputString.append(attributedString)
                
            case .startTag(let tag):
                tagStack.append(tag)
                
            case .endTag(let expectedTag):
                let tag = tagStack.removeLast()
                guard tag == expectedTag else {
                    return nil
                }
                
            case .entity(let entity):
                if let string = entities[entity] {
                    let currentAttributes = buildAttributes(tagStack: tagStack, attributes: attributes)
                    let attributedString = NSAttributedString(string: string, attributes: currentAttributes)
                    outputString.append(attributedString)
                }
            }
            
        }
        
        return NSAttributedString(attributedString: outputString)
    }
    
    private func buildAttributes(tagStack: [String], attributes: [String: [NSAttributedString.Key: Any]]) -> [NSAttributedString.Key: Any] {
        var compoundAttributes = [NSAttributedString.Key: Any]()
        for tag in tagStack {
            if let tagAttributes = attributes[tag] {
                for (key, value) in tagAttributes {
                    compoundAttributes.updateValue(value, forKey: key)
                }
            }
        }
        return compoundAttributes
    }
}

// This is what allows the TagString to be created from a literal string.
extension TagString: ExpressibleByStringLiteral {
    public typealias UnicodeScalarLiteralType = StringLiteralType
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        string = "\(value)"
    }
    
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        string = value
    }
    
    public init(stringLiteral value: StringLiteralType) {
        string = value
    }
}



