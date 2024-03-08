//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

public final class KeyboardObserver {
    
    public var keyboardWillShow: ((_ keyboardSize: CGSize) -> ())?
    
    public var keyboardWillHide: (() -> ())?
    
    public init() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(KeyboardObserver.keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(KeyboardObserver.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let size = frame?.cgRectValue.size ?? CGSize(width: 0, height: 0)
        keyboardWillShow?(size)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        keyboardWillHide?()
    }
}

#endif
