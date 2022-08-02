//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public enum BottomCardBackgroundMode {
    case dim(color: UIColor, alpha: CGFloat)
    case blur(style: UIBlurEffect.Style)
    case dimAndBlur(color: UIColor, alpha: CGFloat, style: UIBlurEffect.Style)
}

/// Example:
///
/// ```
/// class ViewController: UIViewController {
///
///    let bottomCardTransitionDelegate = BottomCardTransitionDelegate()
///
///    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
///        let viewController = segue.destination
///        bottomCardTransitionDelegate.attach(to: viewController)
///    }
///
/// }
/// ```
///
public class BottomCardTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate, UIAdaptivePresentationControllerDelegate {
    
    public var springDamping: CGFloat

    public var mode: BottomCardBackgroundMode
    
    public var willDismiss: (() -> Void)?
    public var didDismiss: (() -> Void)?

    public init(springDamping: CGFloat = 0.6,
                mode: BottomCardBackgroundMode = .dim(color: .black, alpha: 0.4)) {
        self.springDamping = springDamping
        self.mode = mode
        super.init()
    }
    
    deinit {
        
    }
    
    // Use this to configure the view controller to present
    public func attach(to viewController: UIViewController, willDismiss: (() -> Void)? = nil, didDismiss: (() -> Void)? = nil) {
        guard !UIAccessibility.isReduceMotionEnabled else {
            return
        }
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        self.willDismiss = willDismiss
        self.didDismiss = didDismiss
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = BottomCardPresentationController(presented: presented, presenting: presenting, mode: mode)
        presentationController.delegate = self
        return presentationController
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomCardTransitioning(presenting: true, springDamping: springDamping)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomCardTransitioning(presenting: false, springDamping: springDamping)
    }
}

#endif
