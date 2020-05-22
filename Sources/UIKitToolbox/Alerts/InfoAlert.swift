//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class InfoAlert {
    
    let alertController: UIAlertController
    
    public init(title: String? = nil,
                message: String?,
                ok: String? = nil,
                completion: (() -> Void)? = nil) {
        
        alertController = UIAlertController(title: title ?? "Alert",
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
        
        let action = UIAlertAction(title: okString, style: .default) { action in
            completion?()
        }
        
        alertController.addAction(action)
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
