//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

public class CircularRevealTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var isPresenting: Bool = false
    
    public var duration: TimeInterval
    
    public var startFrame: CGRect
    
    public var endFrame: CGRect
    
    public var circleColor: UIColor?
    
    public var fadeCircleDuringAnimation: Bool = false
    
    public init(startFrame: CGRect, endFrame: CGRect, circleColor: UIColor? = nil, presenting: Bool, duration: TimeInterval = 0.3, fadeCircleDuringAnimation: Bool = false) {
        isPresenting = presenting
        self.duration = duration
        self.startFrame = startFrame
        self.endFrame = endFrame
        self.circleColor = circleColor
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentationWithContext(context: transitionContext)
        } else {
            animateDismissalWithContext(context: transitionContext)
        }
    }
    
    private func animatePresentationWithContext(context: UIViewControllerContextTransitioning) {
        guard let presentedView = context.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
    
        let containerView = context.containerView
        
        containerView.addSubview(presentedView)
        
        
        let startPath = UIBezierPath(ovalIn: startFrame).cgPath
        let endPath = UIBezierPath(ovalIn: frameOfCircleEncompassingFrame(rectangle: endFrame)).cgPath
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = presentedView.frame
        maskLayer.path = startPath
        presentedView.layer.mask = maskLayer
        
        let coverLayer = CALayer()
        if let circleColor = circleColor {
            coverLayer.backgroundColor = circleColor.cgColor
            coverLayer.frame = maskLayer.bounds
            presentedView.layer.addSublayer(coverLayer)
        }
        
        let color = circleColor
        let fade = fadeCircleDuringAnimation
        let duration = transitionDuration(using: context)
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            if color != nil && !fade {
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    coverLayer.removeFromSuperlayer()
                    context.completeTransition(true)
                })
                let coverAnimation = CABasicAnimation(keyPath: "opacity")
                coverAnimation.fromValue = 1.0
                coverAnimation.toValue = 0.0
                coverAnimation.duration = duration * 0.5
                coverLayer.opacity = 0.0
                coverLayer.add(coverAnimation, forKey: "coverAnimation")
                CATransaction.commit()
            } else {
                coverLayer.removeFromSuperlayer()
                context.completeTransition(true)
            }
        }
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = startPath
        pathAnimation.toValue = endPath
        pathAnimation.duration = transitionDuration(using: context)
        maskLayer.path = endPath
        maskLayer.add(pathAnimation, forKey: "circularRevealAnimation")
        
        if color != nil && fade {
            let coverAnimation = CABasicAnimation(keyPath: "opacity")
            coverAnimation.fromValue = 1.0
            coverAnimation.toValue = 0.0
            coverAnimation.duration = duration
            coverLayer.opacity = 0.0
            coverLayer.add(coverAnimation, forKey: "coverAnimation")
        }
        
        CATransaction.commit()
    }
    
    private func animateDismissalWithContext(context: UIViewControllerContextTransitioning) {
        
        guard let presentedView = context.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        
        guard let presentingView = context.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        let containerView = context.containerView
        
        containerView.insertSubview(presentingView, at: 0)
        
        let startPath = UIBezierPath(ovalIn: frameOfCircleEncompassingFrame(rectangle: startFrame)).cgPath
        let endPath = UIBezierPath(ovalIn: endFrame).cgPath
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = presentedView.frame
        maskLayer.path = startPath
        presentedView.layer.mask = maskLayer
        
        let coverLayer = CALayer()
        if let circleColor = circleColor {
            coverLayer.backgroundColor = circleColor.cgColor
            coverLayer.frame = maskLayer.bounds
            presentedView.layer.addSublayer(coverLayer)
        }
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            coverLayer.removeFromSuperlayer()
            context.completeTransition(true)
        }
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = startPath
        pathAnimation.toValue = endPath
        pathAnimation.duration = transitionDuration(using: context)
        pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        maskLayer.path = endPath
        maskLayer.add(pathAnimation, forKey: "circularRevealAnimation")
        
        if circleColor != nil {
            let coverAnimation = CABasicAnimation(keyPath: "opacity")
            coverAnimation.fromValue = 0.0
            coverAnimation.toValue = 1.0
            coverAnimation.duration = transitionDuration(using: context)
            coverAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            coverLayer.add(coverAnimation, forKey: "coverAnimation")
        }
        
        CATransaction.commit()
    }
    
    private func frameOfCircleEncompassingFrame(rectangle: CGRect) -> CGRect {
        let x = rectangle.origin.x
        let y = rectangle.origin.y
        let w = rectangle.size.width
        let h = rectangle.size.height
        let diameter = CGFloat(sqrtf(Float(h * h + w * w)) + 8.0) // A little bit of margin
        return CGRect(x: x + (w - diameter) / 2.0, y: y + (h - diameter) / 2.0, width: diameter, height: diameter)
    }
    
}

#endif
