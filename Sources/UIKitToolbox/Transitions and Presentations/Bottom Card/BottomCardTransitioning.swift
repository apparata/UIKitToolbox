//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class BottomCardTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var isPresenting: Bool = false
    
    public private(set) var duration: TimeInterval
    
    public private(set) var springDamping: CGFloat
    
    public init(presenting: Bool, duration: TimeInterval = 0.4, springDamping: CGFloat = 0.6) {
        isPresenting = presenting
        self.duration = duration
        self.springDamping = springDamping
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentation(context: transitionContext)
        } else {
            animateDismissal(context: transitionContext)
        }
    }
    
    private func animatePresentation(context: UIViewControllerContextTransitioning) {
        guard let presentedController = context.viewController(forKey: UITransitionContextViewControllerKey.to),
            let presentedControllerView = context.view(forKey: UITransitionContextViewKey.to) else { return }
        
        let containerView = context.containerView
        
        // Position the presented view off the bottom of the container view.
        presentedControllerView.frame = context.finalFrame(for: presentedController)
        
        containerView.addSubview(presentedControllerView)
        
        let transform = CGAffineTransform(translationX: 0.0, y: 200.0)
        presentedControllerView.transform = transform
        
        presentedControllerView.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: springDamping, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            presentedControllerView.transform = CGAffineTransform.identity
            presentedControllerView.alpha = 1.0
        }, completion:  { (finished) in
            context.completeTransition(finished)
        })
        
    }
    
    private func animateDismissal(context: UIViewControllerContextTransitioning) {
        guard let presentedView = context.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        let containerView = context.containerView
        let transform = CGAffineTransform(translationX: 0.0, y: containerView.bounds.size.height)
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
            presentedView.transform = transform
        }, completion: { (finished) in
            context.completeTransition(finished)
        })
    }
}

#endif
