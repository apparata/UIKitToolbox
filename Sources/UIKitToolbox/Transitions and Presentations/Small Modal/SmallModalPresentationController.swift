//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

public class SmallModalPresentationController: UIPresentationController {
    
    public let size: CGSize
    
    public var dimmingView: UIView?
    
    public init(presented: UIViewController, presenting: UIViewController, size: CGSize) {
        self.size = size
        super.init(presentedViewController: presented, presenting: presenting)
    }

    public override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = containerView else {
            return
        }
        
        let frame = containerView.bounds
        
        let dimmingView = UIView(frame: frame)
        dimmingView.backgroundColor = UIColor.black
        dimmingView.alpha = 0.0
        self.dimmingView = dimmingView
        
        containerView.addSubview(dimmingView)
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { (context) -> Void in
            dimmingView.alpha = 0.8
        }, completion: nil)
        
    }
    
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed {
            // Presentation aborted
            dimmingView?.removeFromSuperview()
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { (context) -> Void in
            self.dimmingView?.alpha = 0.0
        }, completion: nil)
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        dimmingView?.removeFromSuperview()
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect(origin: CGPoint.zero, size: size)
        }
        let bounds = containerView.bounds
        let origin = CGPoint(x: (bounds.size.width - size.width) / 2.0, y: (bounds.size.height - size.height) / 2.0)
        let frame = CGRect(origin: origin, size: size)
        return frame
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.dimmingView?.frame = self.containerView?.bounds ?? CGRect.zero
        }, completion: nil)
    }
}

#endif
