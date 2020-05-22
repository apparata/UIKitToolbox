//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

///
/// ```
/// override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
///     stackedModalTransitionDelegate?.attach(to: segue.destination)
/// }
/// ```
public class StackedModalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    // Use this to configure the view controller to present
    public func attach(to viewController: UIViewController) {
        guard !UIAccessibility.isReduceMotionEnabled else {
            return
        }

        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return StackedModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

#endif
