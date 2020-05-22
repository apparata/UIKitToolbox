//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public enum BottomModalBackgroundMode {
    case dim(alpha: CGFloat)
    case blur(style: UIBlurEffect.Style)
}

public class BottomModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
        
    public var mode: BottomModalBackgroundMode
    
    public init(mode: BottomModalBackgroundMode = .dim(alpha: 0.4)) {
        self.mode = mode
        super.init()
    }
    
    /// Configure the view controller to present
    public func attach(to viewController: UIViewController) {
        guard !UIAccessibility.isReduceMotionEnabled else {
            return
        }

        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomModalPresentationController(presented: presented, presenting: presenting, mode: mode)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

#endif
