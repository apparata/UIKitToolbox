//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

public class BottomModalPresentationController: UIPresentationController {
    
    private let mode: BottomModalBackgroundMode

    private let height: CGFloat = 250

    // Dimming
    private weak var dimmingView: UIView?
    
    // Blurring
    private weak var blurView: UIVisualEffectView?
    private weak var vibrancyView: UIVisualEffectView?
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        let safeAreaMargin = containerView?.safeAreaInsets.bottom ?? 0
        var frame = super.frameOfPresentedViewInContainerView
        frame.origin.y = frame.size.height - height - safeAreaMargin
        frame.size.height = height + safeAreaMargin
        return frame
    }
    
    public init(presented: UIViewController,
                presenting: UIViewController?,
                mode: BottomModalBackgroundMode = .dim(alpha: 0.4)) {
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
        
        case .dim(alpha: let dimAlpha):
            let dimmingView = UIView(frame: containerView.bounds)
            dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            dimmingView.backgroundColor = UIColor.black
            dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
            self.dimmingView = dimmingView

            animate(alongsideTransition: { context in
                dimmingView.alpha = dimAlpha
            })
            
        case .blur(style: let blurStyle):
            let blurView = UIVisualEffectView(effect: nil)
            blurView.frame = containerView.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.addSubview(blurView)
            self.blurView = blurView
            
            let vibrancyView = UIVisualEffectView(effect: nil)
            vibrancyView.frame = containerView.bounds
            vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.blurView?.contentView.addSubview(vibrancyView)
            
            animate(alongsideTransition: { context in
                let blurEffect = UIBlurEffect(style: blurStyle)
                let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
                blurView.effect = blurEffect
                vibrancyView.effect = vibrancyEffect
            }, completion: nil)
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
        case .dim(alpha: _):
            animate(alongsideTransition: { [dimmingView] context in
                dimmingView?.alpha = 0.0
            }, completion: nil)

        case .blur(style: _):
            animate(alongsideTransition: { [blurView] context in
                blurView?.effect = nil
            }, completion: nil)
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
