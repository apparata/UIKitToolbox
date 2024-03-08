//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

public class ConfirmAlert {
    
    let alertController: UIAlertController
    
    public init(title: String? = nil,
                message: String?,
                confirm: String? = nil,
                cancel: String? = nil,
                completion: ((Bool) -> Void)? = nil) {
        
        alertController = UIAlertController(title: title ?? "Confirm",
                                            message: message ?? "",
                                            preferredStyle: .alert)
        
        var confirmString: String
        if let confirm = confirm {
            confirmString = confirm
        } else {
            confirmString = NSLocalizedString("general_ok_button", comment: "")
            if confirmString == "general_ok_button" {
                confirmString = "OK"
            }
        }
        
        let confirmAction = UIAlertAction(title: confirmString, style: .default) { _ in
            completion?(true)
        }
        alertController.addAction(confirmAction)

        var cancelString: String
        if let cancel = cancel {
            cancelString = cancel
        } else {
            cancelString = NSLocalizedString("general_ok_button", comment: "")
            if cancelString == "general_cancel_button" {
                cancelString = "Cancel"
            }
        }

        let cancelAction = UIAlertAction(title: cancelString, style: .cancel) { _ in
            completion?(false)
        }
        alertController.addAction(cancelAction)
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
