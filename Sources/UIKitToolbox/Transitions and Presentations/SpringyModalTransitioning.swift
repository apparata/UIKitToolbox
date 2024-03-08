//
//  Copyright © 2015 Apparata. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

/// An animated transitioning of modals in a springy fashion.
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
/// func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
///    let animator = SpringyModalTransitioning()
///    animator.isPresenting = true
///    return animator
/// }
///
/// func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
///    let animator = SpringyModalTransitionAnimator()
///    animator.isPresenting = false
///    guard let navController = dismissed as? UINavigationController else { return animator }
///    guard let viewController = navController.viewControllers.first else { return animator }
///    guard let modalViewController = viewController as? CancellingViewController else { return animator }
///    animator.isCancelling = newViewController.cancelled
///    return animator
/// }
/// ```
public class SpringyModalTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var isPresenting: Bool = false
    
    public var isCancelling: Bool = false
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting ? 0.6 : 0.4
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let fromView = fromViewController.view!
        let toView = toViewController.view!
        let duration = transitionDuration(using: transitionContext)
        
        if isPresenting {
            transitionContext.containerView.addSubview(toView)
            
            toView.transform = CGAffineTransform(translationX: 0.0, y: toView.frame.size.height)
            
            let navController = toViewController as! UINavigationController
            let frame = navController.navigationBar.frame
            navController.navigationBar.frame = frame
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
                toView.transform = CGAffineTransform.identity
                fromView.alpha = 0.5
                fromView.layer.transform = CATransform3DMakeScale(0.97, 0.97, 1.0)
                }, completion: { _ in
                    transitionContext.completeTransition(true)
            })
        } else {
            toView.layer.transform = CATransform3DMakeScale(0.97, 0.97, 1.0)
            toView.alpha = 0.5
            
            transitionContext.containerView.addSubview(fromView)
            
            var targetTransform = CGAffineTransform(translationX: 0.0, y: fromView.frame.size.height + 64.0 /* Make sure it goes completely off screen */)
            if isCancelling {
                targetTransform = targetTransform.rotated(by: 0.8)
            }
            
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
                fromView.transform = targetTransform
                toView.alpha = 1.0
                toView.layer.transform = CATransform3DIdentity
                }, completion: { _ in
                    transitionContext.completeTransition(true)
            })
        }
    }
}

#endif
