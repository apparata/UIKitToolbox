//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

///
/// Create a view controller with a clear colored background.
///
/// ```
/// override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
///     blurDelegate.attach(to: segue.destination)
/// }
/// ```
public class BlurTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private var frame: CGRect = CGRect.zero
    private var style: UIBlurEffect.Style = .dark
    
    // Use this to configure the view controller to present
    public func attach(to viewController: UIViewController, frame: CGRect, style: UIBlurEffect.Style) {
        self.frame = frame
        self.style = style
        guard !UIAccessibility.isReduceMotionEnabled else {
            return
        }
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = BlurPresentationController(presentedViewController: presented, presenting: presenting, frame: frame, style: style)
        return presentationController
    }
}

#endif
