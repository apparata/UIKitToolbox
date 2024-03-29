//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

public class BottomCardPresentationController: UIPresentationController {
    
    private let mode: BottomCardBackgroundMode
    
    // Dimming
    private weak var dimmingView: UIView?
    
    // Blurring
    private weak var blurView: UIVisualEffectView?
    private weak var vibrancyView: UIVisualEffectView?

    public init(presented: UIViewController,
                presenting: UIViewController?,
                mode: BottomCardBackgroundMode = .dim(color: .black, alpha: 0.4)) {
        self.mode = mode
        super.init(presentedViewController: presented, presenting: presenting)
    }
    
    deinit {
        cleanUp()
    }
    
    private func cleanUp() {
        dimmingView?.removeFromSuperview()
        blurView?.removeFromSuperview()
    }
    
    public override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerView = containerView else {
            return
        }
        
        switch mode {
            
        case .dim(let dimColor, let dimAlpha):
            animateInDimView(in: containerView, dimColor: dimColor, dimAlpha: dimAlpha)
            
        case .blur(let blurStyle):
            animateInBlurView(in: containerView, blurStyle: blurStyle)
            
        case .dimAndBlur(let dimColor, let dimAlpha, let blurStyle):
            animateInBlurView(in: containerView, blurStyle: blurStyle)
            animateInDimView(in: containerView, dimColor: dimColor, dimAlpha: dimAlpha)
        }
    }
    
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed {
            cleanUp()
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        switch mode {
        case .dim:
            animateOutDimView()
            
        case .blur:
            animateOutBlurView()

        case .dimAndBlur:
            animateOutDimView()
            animateOutBlurView()
        }
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            cleanUp()
        }
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let frame = CGRect(origin: .zero, size: size)
        coordinator.animate(alongsideTransition: { [dimmingView, blurView] context in
            dimmingView?.frame = frame
            blurView?.frame = frame
        }, completion: nil)
    }
    
    // MARK: - Helper methods
    
    private func animateInDimView(in containerView: UIView, dimColor: UIColor, dimAlpha: CGFloat) {
        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = dimColor
        dimmingView.alpha = 0.0
        containerView.addSubview(dimmingView, constrainedTo: .superview)
        self.dimmingView = dimmingView
        
        animate(alongsideTransition: { context in
            dimmingView.alpha = dimAlpha
        })
    }
    
    private func animateOutDimView() {
        animate(alongsideTransition: { [dimmingView] context in
            dimmingView?.alpha = 0.0
        }, completion: nil)
    }
    
    private func animateInBlurView(in containerView: UIView, blurStyle: UIBlurEffect.Style) {
        let blurView = UIVisualEffectView(effect: nil)
        blurView.frame = containerView.bounds
        containerView.addSubview(blurView, constrainedTo: .superview)
        self.blurView = blurView
        
        let vibrancyView = UIVisualEffectView(effect: nil)
        vibrancyView.frame = containerView.bounds
        self.blurView?.contentView.addSubview(vibrancyView, constrainedTo: .superview)
        
        animate(alongsideTransition: { context in
            let blurEffect = UIBlurEffect(style: blurStyle)
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            blurView.effect = blurEffect
            vibrancyView.effect = vibrancyEffect
        }, completion: nil)
    }
    
    private func animateOutBlurView() {
        animate(alongsideTransition: { [blurView] context in
            blurView?.effect = nil
        }, completion: nil)
    }
    
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
