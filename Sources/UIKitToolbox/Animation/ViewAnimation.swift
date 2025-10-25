//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

@MainActor
public struct ViewAnimation {
    
    public enum AnimationType {
        case basic
        case spring
    }
    
    public var animationType: AnimationType
    
    public var duration: TimeInterval
    
    public var delay: TimeInterval
    
    public var springDampingRatio: CGFloat
    
    public var springVelocity: CGFloat
    
    public var options: [UIView.AnimationOptions]
    
    public var animationsBlock: (() -> Void)?
    
    public var completionBlock: ((Bool) -> Void)?
    
    public init() {
        animationType = .basic
        duration = 0.0
        delay = 0.0
        springDampingRatio = 0.0
        springVelocity = 0.0
        options = []
    }
    
    public init(duration: TimeInterval, delay: TimeInterval = 0.0) {
        animationType = .basic
        self.duration = duration
        self.delay = delay
        springDampingRatio = 0.0
        springVelocity = 0.0
        options = []
    }
    
    public func start() {
        guard let animationsBlock = animationsBlock else {
            return
        }
        switch animationType {
        case .basic:
            UIView.animate(withDuration: duration,
                           delay: delay,
                           options: UIView.AnimationOptions(options),
                           animations: animationsBlock,
                           completion: completionBlock)
        case .spring:
            UIView.animate(withDuration: duration,
                           delay: delay,
                           usingSpringWithDamping: springDampingRatio,
                           initialSpringVelocity: springVelocity,
                           options: UIView.AnimationOptions(options),
                           animations: animationsBlock,
                           completion: completionBlock)
        }
    }
    
    public func duration(delay: TimeInterval) -> ViewAnimation {
        var animation = self
        animation.delay = delay
        return animation
    }
    
    public func delay(delay: TimeInterval) -> ViewAnimation {
        var animation = self
        animation.delay = delay
        return animation
    }
    
    public func animations(animations: @escaping () -> Void) -> ViewAnimation {
        var animation = self
        animation.animationsBlock = animations
        return animation
    }
    
    public func easeIn() -> ViewAnimation {
        var animation = self
        animation.options.append(.curveEaseIn)
        return animation
    }
    
    public func easeOut() -> ViewAnimation {
        var animation = self
        animation.options.append(.curveEaseOut)
        return animation
    }
    
    public func easeInOut() -> ViewAnimation {
        var animation = self
        animation.options.append(.curveEaseOut)
        return animation
    }
    
    public func linear() -> ViewAnimation {
        var animation = self
        animation.options.append(.curveLinear)
        return animation
    }
    
    public func layoutSubviews() -> ViewAnimation {
        var animation = self
        animation.options.append(.layoutSubviews)
        return animation
    }
    
    public func allowUserInteraction() -> ViewAnimation {
        var animation = self
        animation.options.append(.allowUserInteraction)
        return animation
    }
    
    public func beginFromCurrentState() -> ViewAnimation {
        var animation = self
        animation.options.append(.beginFromCurrentState)
        return animation
    }
    
    public func loop() -> ViewAnimation {
        var animation = self
        animation.options.append(.repeat)
        return animation
    }
    
    public func autoreverse() -> ViewAnimation {
        var animation = self
        animation.options.append(.autoreverse)
        return animation
    }
    
    public func overrideInheritedDuration() -> ViewAnimation {
        var animation = self
        animation.options.append(.overrideInheritedDuration)
        return animation
    }
    
    public func overrideInheritedCurve() -> ViewAnimation {
        var animation = self
        animation.options.append(.overrideInheritedCurve)
        return animation
    }
    
    public func allowAnimatedContent() -> ViewAnimation {
        var animation = self
        animation.options.append(.allowAnimatedContent)
        return animation
    }
    
    public func showHideTransitionViews() -> ViewAnimation {
        var animation = self
        animation.options.append(.showHideTransitionViews)
        return animation
    }
    
    public func overrideInheritedOptions() -> ViewAnimation {
        var animation = self
        animation.options.append(.overrideInheritedOptions)
        return animation
    }
    
    public func completion(completion: @escaping (Bool) -> Void) -> ViewAnimation {
        var animation = self
        animation.completionBlock = completion
        return animation
    }
    
    public func spring(damping: CGFloat, velocity: CGFloat) -> ViewAnimation {
        var animation = self
        animation.animationType = .spring
        animation.springDampingRatio = damping
        animation.springVelocity = velocity
        return animation
    }
    
    public func smoothSpring() -> ViewAnimation {
        var animation = self
        animation.animationType = .spring
        animation.springDampingRatio = 0.9
        animation.springVelocity = 0.0
        return animation
    }
}

#endif
