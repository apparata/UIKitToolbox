//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class DestructiveConfirmAlert {
    
    let alertController: UIAlertController
    
    public init(title: String? = "Confirm", message: String?, confirm: String? = "OK", cancel: String? = "Cancel", completion: ((Bool) -> Void)? = nil) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: confirm, style: .destructive) { _ in
            completion?(true)
        }
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: cancel, style: .cancel) { _ in
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
    
    public func tintColor(_ color: UIColor) -> Self {
        alertController.view.tintColor = color
        return self
    }
}

#endif
