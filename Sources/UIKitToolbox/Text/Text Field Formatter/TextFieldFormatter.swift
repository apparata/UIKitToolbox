//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

/// Formats the text in a text field on the fly, given a particular format.
/// The formatter can be attached to text field in delegate mode or
/// a separate text field delegate can forward the
/// `textField:shouldChangeCharactersInRange:range:replacementString:`
/// to the text field formatter object.
public class TextFieldFormatter: NSObject, UITextFieldDelegate {
    
    public var format: TextFieldFormat
    
    private let editingChangedSelector: Selector = #selector(TextFieldFormatter.editingChanged(textField:))
    
    private weak var textField: UITextField?
    
    private var isDelegate: Bool = false
    
    /// Called after text has been formatted.
    public var didFormat: ((_ text: String) -> Void)?
    
    /// Initialize the formatter with a format, but without attaching it to a
    /// text field.
    public init(format: TextFieldFormat) {
        self.format = format
        super.init()
    }
    
    /// Initialize the formatter with a format and attach it to a text field.
    public init(format: TextFieldFormat, textField: UITextField, asDelegate: Bool) {
        self.format = format
        super.init()
        attachTo(textField: textField, asDelegate: asDelegate)
    }
    
    isolated deinit {
        detach()
    }
    
    /// Formatter should be attached to text field as delegate, unless
    /// there is another delegate. In that case, forward the
    /// `textField:shouldChangeCharactersInRange:range:replacementString:`
    /// function call to this object from the other delegate.
    public func attachTo(textField: UITextField, asDelegate: Bool) {
        if self.textField != nil {
            detach()
        }
        textField.addTarget(self, action: editingChangedSelector, for: .editingChanged)
        isDelegate = asDelegate
        if isDelegate {
            textField.delegate = self
        }
        self.textField = textField
        formatTextInTextField()
    }
    
    /// Detach formatter from text field.
    public func detach() {
        guard let textField = textField else {
            return
        }
        textField.removeTarget(self, action: editingChangedSelector, for: .editingChanged)
        self.textField = nil
    }
    
    /// MARK: Event functions
    
    /// Do not call this method from outside this class.
    @objc public func editingChanged(textField: UITextField) {
        formatTextInTextField()
    }
    
    /// Only call this method from outside this class if the formatter is not
    /// in delegate mode.
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        return format.shouldChangeText(text: text, newText: newText, replacement: string, inRange: range)
    }
    
    // MARK: Private functions
    
    private func formatTextInTextField() {
        var resultText = ""
        defer {
            didFormat?(resultText)
        }
        
        guard let textField = textField else {
            return
        }
        guard let text = textField.text else {
            return
        }
        guard text.count > 0 else {
            return
        }
        
        let selectedRange = textField.selectedTextRange
        let targetOffset = (selectedRange == nil) ? 0 : textField.offset(from: textField.beginningOfDocument, to: selectedRange!.start)
        
        let (formattedText, formattedOffset) = formatted(string: text, targetOffset: targetOffset)
        
        textField.text = formattedText
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: formattedOffset) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
        
        resultText = formattedText
    }
    
    private func formatted(string: String, targetOffset: Int) -> (String, Int) {
        let (filteredString, filteredOffset) = format.filtered(string: string, cursorPosition: targetOffset)
        let (formattedString, formattedOffset) = format.formatted(string: filteredString, cursorPosition: filteredOffset)
        return (formattedString, formattedOffset)
    }
}

#endif
