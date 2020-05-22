//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public final class TextFieldObserver {
    
    public var textDidChange: ((_ textField: UITextField) -> ())?
    public var didBeginEditing: ((_ textField: UITextField) -> ())?
    public var didEndEditing: ((_ textField: UITextField) -> ())?
    
    /// If a specific text field is set, only notifications concerning
    /// that text field will be observed. If not set, notifications
    /// concerning all text fields will be observed.
    public weak var onlyObserveTextField: UITextField?
    
    public init(onlyObserveTextField: UITextField? = nil) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(TextFieldObserver.textFieldTextDidChange(notification:)),
                                       name: UITextField.textDidChangeNotification, object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(TextFieldObserver.textFieldTextDidBeginEditing(notification:)),
                                       name: UITextField.textDidBeginEditingNotification, object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(TextFieldObserver.textFieldTextDidEndEditing(notification:)),
                                       name: UITextField.textDidEndEditingNotification, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func textField(from notification: NSNotification) -> UITextField? {
        guard let textField = notification.object as? UITextField else {
            return nil
        }
        if let onlyObserveTextField = onlyObserveTextField, textField != onlyObserveTextField {
            return nil
        }
        return textField
    }
    
    @objc private func textFieldTextDidChange(notification: NSNotification) {
        guard let textField = textField(from: notification) else {
            return
        }
        textDidChange?(textField)
    }
    
    @objc private func textFieldTextDidBeginEditing(notification: NSNotification) {
        guard let textField = textField(from: notification) else {
            return
        }
        didBeginEditing?(textField)
    }
    
    @objc private func textFieldTextDidEndEditing(notification: NSNotification) {
        guard let textField = textField(from: notification) else {
            return
        }
        didEndEditing?(textField)
    }
}

#endif
