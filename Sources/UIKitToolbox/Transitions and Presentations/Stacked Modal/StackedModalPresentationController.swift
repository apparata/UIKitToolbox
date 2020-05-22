//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class StackedModalPresentationController: UIPresentationController {
    
    public var willBeginPresentation: (() -> Void)?
    public var didBeginPresentation: (() -> Void)?
    public var willEndPresentation: (() -> Void)?
    public var didEndPresentation: (() -> Void)?
    
    public override var shouldPresentInFullscreen: Bool {
        return false
    }
    
    public override var shouldRemovePresentersView: Bool {
        return false
    }
    
    private var dimmingView: DimmingView?
    private var snapshotContainerView: UIView?
    private var snapshotBackgroundView = UIView()
    private var snapshotView: UIView?
    
    // MARK: - Cleanup
    
    deinit {
        cleanUp()
    }
    
    private func cleanUp() {
        dimmingView?.removeFromSuperview()
        dimmingView = nil
        
        snapshotView?.removeFromSuperview()
        snapshotView = nil
        
        snapshotContainerView?.removeFromSuperview()
        snapshotContainerView = nil
        
        didEndPresentation?()
    }
    
    // MARK: - Overridden methods
    
    public override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerView = containerView else {
            return
        }
        
        let dimmingView = DimmingView(frame: containerView.bounds)
        dimmingView.alpha = 0.0
        containerView.addSubview(dimmingView)
        self.dimmingView = dimmingView
        
        let snapshotContainerView = UIView(frame: containerView.bounds)
        snapshotContainerView.backgroundColor = .black
        self.snapshotContainerView = snapshotContainerView
        containerView.insertSubview(snapshotContainerView, at: 0)
        
        if let snapshotView = presentingViewController.view.snapshotView(afterScreenUpdates: false) {
            snapshotView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            snapshotView.layer.masksToBounds = true
            snapshotContainerView.addSubview(snapshotView)
            self.snapshotView = snapshotView

            snapshotBackgroundView.backgroundColor = UIColor { traits in
                if traits.userInterfaceStyle == .dark {
                    return UIColor(r: 28, g: 28, b: 30, a: 1)
                } else {
                    return .systemBackground
                }
            }
            snapshotContainerView.insertSubview(snapshotBackgroundView, at: 0)
            snapshotBackgroundView.frame = snapshotView.frame
        }
        
        let safeAreaHeight = presentingViewController.view.safeAreaInsets.top
        
        let isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
        
        animate(alongsideTransition: { [weak self] context in
            self?.dimmingView?.alpha = 1.0
            
            self?.snapshotView?.layer.transform = CATransform3DTranslate(CATransform3DMakeScale(0.94, 0.94, 1.0), 0.0, safeAreaHeight - 14.0, 0.0)
            self?.snapshotView?.layer.cornerRadius = 8.0
            if isDarkMode {
                self?.snapshotView?.alpha = 0.0
            }
            
            self?.snapshotBackgroundView.layer.transform = CATransform3DTranslate(CATransform3DMakeScale(0.94, 0.94, 1.0), 0.0, safeAreaHeight - 14.0, 0.0)
            self?.snapshotBackgroundView.layer.cornerRadius = 8.0
        })
        
        willBeginPresentation?()
    }
    
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
        if !completed {
            cleanUp()
        } else {
            didBeginPresentation?()
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        animate(alongsideTransition: { [weak self] context in
            self?.dimmingView?.alpha = 0.0
            self?.snapshotView?.layer.transform = CATransform3DIdentity
            self?.snapshotView?.layer.cornerRadius = 8.0
            self?.snapshotView?.alpha = 1.0
            self?.snapshotBackgroundView.layer.transform = CATransform3DIdentity
            self?.snapshotBackgroundView.layer.cornerRadius = 8.0
        })
        
        willEndPresentation?()
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        if completed {
            cleanUp()
        }
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else {
            return CGRect.zero
        }
        return bounds
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.dimmingView?.frame = self.containerView?.bounds ?? CGRect.zero
        }, completion: nil)
    }
    
    // MARK: - Helper methods
    
    @discardableResult
    private func animate(alongsideTransition animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?,
                         completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil) -> Bool {
        
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else {
            return false
        }
        
        return transitionCoordinator.animate(alongsideTransition: animation, completion: completion)
    }
}

#endif
