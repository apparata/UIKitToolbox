//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class BlurPresentationController: UIPresentationController {
    
    private weak var blurView: UIVisualEffectView?
    private weak var vibrancyView: UIVisualEffectView?
    
    private let frame: CGRect
    private let style: UIBlurEffect.Style
    private let enableMotionEffect: Bool
    
    private let motionEffect = CannedMotionEffects.tilt()
    
    public override var shouldPresentInFullscreen: Bool {
        return false
    }
    
    public override var shouldRemovePresentersView: Bool {
        return false
    }
    
    public init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, frame: CGRect, style: UIBlurEffect.Style, enableMotionEffect: Bool = false) {
        self.frame = frame
        self.style = style
        self.enableMotionEffect = enableMotionEffect
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    deinit {
        cleanUp()
    }
    
    private func cleanUp() {
        presentedView?.removeMotionEffect(motionEffect)
        blurView?.removeFromSuperview()
    }
    
    public override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        guard let containerView = containerView,
            let presentedView = presentedView else {
            return
        }
        
        let blurView = UIVisualEffectView(effect: nil)
        blurView.frame = containerView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(blurView)
        self.blurView = blurView
        
        let vibrancyView = UIVisualEffectView(effect: nil)
        vibrancyView.frame = containerView.bounds
        vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurView?.contentView.addSubview(vibrancyView)
        
        if enableMotionEffect {
            presentedView.addMotionEffect(motionEffect)
        }

        animate(alongsideTransition: { [weak self] context in
            guard let strongSelf = self else {
                return
            }
            let blurEffect = UIBlurEffect(style: strongSelf.style)
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            strongSelf.blurView?.effect = blurEffect
            strongSelf.vibrancyView?.effect = vibrancyEffect
        }, completion: nil)
    }
    
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed {
            cleanUp()
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        animate(alongsideTransition: { [weak self] context in
            self?.blurView?.effect = nil
        }, completion: nil)
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            cleanUp()
        }
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {        
        return frame
    }
    
    // MARK: - Helper methods
    
    @discardableResult
    private func animate(alongsideTransition animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?,
                         completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil) -> Bool {
        
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else {
            return false
        }
        
        return transitionCoordinator.animate(alongsideTransition:animation, completion: completion)
    }
}

#endif
