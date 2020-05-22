//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

/// Convenience class for building a text attributes dictionary.
public final class TextAttributesBuilder {

    private var attributes: [NSAttributedString.Key: Any] = [:]

    public init() {}
    
    /// Output the built dictionary of text attributes.
    ///
    /// - returns: The built dictionary of text attributes.
    public func build() -> [NSAttributedString.Key: Any] {
        return attributes
    }

    /// - parameter font: Font to use. Defaults to system font, 12pt.
    public func font(_ font: UIFont) -> TextAttributesBuilder {
        attributes[.font] = font
        return self
    }

    /// - parameter color: Foreground color, default black.
    public func color(_ color: UIColor) -> TextAttributesBuilder {
        attributes[.foregroundColor] = color
        return self
    }

    /// - parameter color: Background color, default nil: no background
    public func backgroundColor(_ color: UIColor) -> TextAttributesBuilder {
        attributes[.backgroundColor] = color
        return self
    }

    /// - parameter style: Paragraph style, default defaultParagraphStyle
    public func paragraphStyle(_ style: NSParagraphStyle) -> TextAttributesBuilder {
        attributes[.paragraphStyle] = style
        return self
    }

    /// - parameter ligature: Ligature, default 0: no ligatures
    public func ligature(_ ligature: Int) -> TextAttributesBuilder {
        attributes[.ligature] = ligature as NSNumber
        return self
    }

    /// - parameter kern: Amount to modify default kerning in points. 0 means kerning is disabled.
    public func kern(_ kern: Float) -> TextAttributesBuilder {
        attributes[.kern] = kern as NSNumber
        return self
    }

    /// - parameter style: Strikethrough style, default 0: no strikethrough
    public func strikethroughStyle(_ style: Int) -> TextAttributesBuilder {
        attributes[.strikethroughStyle] = style as NSNumber
        return self
    }

    /// - parameter color: Strikethrough color, defaults to foreground color
    public func strikethroughColor(_ color: UIColor) -> TextAttributesBuilder {
        attributes[.strikethroughColor] = color
        return self
    }

    /// - parameter style: Underline style, default 0: no underline
    public func underlineStyle(_ style: Int) -> TextAttributesBuilder {
        attributes[.strikethroughStyle] = style as NSNumber
        return self
    }

    /// - parameter color: Underline color, defaults to foreground color
    public func underlineColor(_ color: UIColor) -> TextAttributesBuilder {
        attributes[.underlineColor] = color
        return self
    }

    /// - parameter color: Stroke color, defaults to foreground color
    public func strokeColor(_ color: UIColor) -> TextAttributesBuilder {
        attributes[.strokeColor] = color
        return self
    }

    /// - parameter width: Stroke width, in percent of font point size. default 0: no stroke.
    ///                    Positive for stroke alone, negative for stroke and fill (a typical
    ///                    value for outlined text would be 3.0)
    public func strokeWidth(_ width: Float) -> TextAttributesBuilder {
        attributes[.strokeWidth] = width as NSNumber
        return self
    }

    /// - parameter shadow: Shadow, default: nil, no shadow
    public func shadow(_ shadow: NSShadow) -> TextAttributesBuilder {
        attributes[.shadow] = shadow
        return self
    }

    /// - parameter textEffect: Text effect, default nil: no text effect
    public func textEffect(_ textEffect: String) -> TextAttributesBuilder {
        attributes[.textEffect] = textEffect as NSString
        return self
    }

    /// - parameter attachment: Attachment, default nil: no attachment
    public func attachment(_ attachment: NSTextAttachment) -> TextAttributesBuilder {
        attributes[.attachment] = attachment
        return self
    }

    /// - parameter link: Link, default nil: no link
    public func link(_ link: NSURL) -> TextAttributesBuilder {
        attributes[.link] = link
        return self
    }

    /// - parameter offset: Baseline offset in points, default 0
    public func baselineOffset(_ offset: Float) -> TextAttributesBuilder {
        attributes[.baselineOffset] = offset as NSNumber
        return self
    }

    /// - parameter obliqueness: Skew to be applied to glyphs, default 0: no skew
    public func obliqueness(_ obliqueness: Float) -> TextAttributesBuilder {
        attributes[.obliqueness] = obliqueness as NSNumber
        return self
    }

    /// - parameter expansion: Log of expansion factor to be applied to glyphs, default 0: no expansion
    public func expansion(_ expansion: Float) -> TextAttributesBuilder {
        attributes[.expansion] = expansion as NSNumber
        return self
    }
}

#endif
