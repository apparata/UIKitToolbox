//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

public class PromptAlert {
    
    let alertController: UIAlertController
    
    public init(title: String? = "Prompt",
                message: String?,
                placeHolder: String?,
                ok: String? = nil,
                cancel: String? = nil,
                completion: ((String?) -> Void)? = nil) {
        
        alertController = UIAlertController(title: title ?? "Prompt",
                                            message: message ?? "",
                                            preferredStyle: .alert)
        
        var okString: String
        if let ok = ok {
            okString = ok
        } else {
            okString = NSLocalizedString("general_ok_button", comment: "")
            if okString == "general_ok_button" {
                okString = "OK"
            }
        }
        
        let okAction = UIAlertAction(title: okString, style: .default) { [weak self] action in
            if let textField = self?.alertController.textFields?.first {
                completion?(textField.text)
            } else {
                completion?(nil)
            }
        }
        alertController.addAction(okAction)
        okAction.isEnabled = false
        
        var cancelString: String
        if let cancel = cancel {
            cancelString = cancel
        } else {
            cancelString = NSLocalizedString("general_cancel_button", comment: "")
            if cancelString == "general_cancel_button" {
                cancelString = "Cancel"
            }
        }
            
        let cancelAction = UIAlertAction(title: cancelString, style: .cancel) { action in
            completion?(nil)
        }
        alertController.addAction(cancelAction)
        
        alertController.addTextField { textField in
            textField.placeholder = placeHolder ?? ""
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification,
                                                   object: textField,
                                                   queue: .main) { notification in
                if let field = notification.object as? UITextField, let text = field.text, text.count > 0 {
                    okAction.isEnabled = true
                }
            }
        }
    }
    
    public func present(from viewController: UIViewController?) {
        guard let viewController = viewController else {
            return
        }
        
        if !Thread.isMainThread {
            DispatchQueue.main.async { [alertController] in
                viewController.present(alertController, animated: true, completion: nil)
            }
        } else {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}

#endif
