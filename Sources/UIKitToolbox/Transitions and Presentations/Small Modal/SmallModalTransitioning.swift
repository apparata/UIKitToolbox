//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

/// An animated transitioning for modals that don't cover the entire screen.
///
/// Example:
/// ```
/// override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
///    if segue.identifier == "<theModalSegueGoesHere>" {
///        segue.destinationViewController.modalPresentationStyle = .Custom
///        segue.destinationViewController.transitioningDelegate = self
///    }
/// }
///
/// func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
///     return SmallModalPresentationController(presented: presented, presenting: presenting, size: CGSize(300, 360))
/// }
///
/// func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
///    return SmallModalTransitioning(presenting: true)
/// }
///
/// func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
///    return SmallModalTransitioning(presenting: false)
/// }
/// ```
public class SmallModalTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var isPresenting: Bool = false
    
    public var duration: TimeInterval
    
    public init(presenting: Bool, duration: TimeInterval = 0.5) {
        isPresenting = presenting
        self.duration = duration
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
        
        // Position the presented view off the top of the container view.
        presentedControllerView.frame = context.finalFrame(for: presentedController)
        
        containerView.addSubview(presentedControllerView)
        
        let transform = CGAffineTransform(translationX: 0.0, y: -presentedControllerView.bounds.size.height)
        presentedControllerView.transform = transform.rotated(by: -8.0 * .pi / 180.0)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            presentedControllerView.transform = CGAffineTransform.identity
        }, completion: { (finished) in
            context.completeTransition(finished)
        })
    }
    
    private func animateDismissal(context: UIViewControllerContextTransitioning) {
        guard let presentedView = context.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        let containerView = context.containerView
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
            let transform = CGAffineTransform(translationX: 0.0, y: containerView.bounds.size.height / 2.0 + presentedView.bounds.size.height + 20.0)
            presentedView.transform = transform.rotated(by: 20.0 * .pi / 180.0)
        }, completion: { (finished) in
            context.completeTransition(finished)
        })
    }
}

#endif
