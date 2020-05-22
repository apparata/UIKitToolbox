//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

/// Example:
/// class ViewController: UIViewController {
///
///    @IBOutlet weak var circularButton: UIButton!
///
///    let circularRevealTransitioningDelegate = CircularRevealTransitionDelegate()
///
///    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
///        let destinationViewController = segue.destinationViewController
///        circularRevealTransitioningDelegate.startFrame = circularButton.frame
///        circularRevealTransitioningDelegate.endFrame = UIScreen.mainScreen().bounds
///        circularRevealTransitioningDelegate.circleColor = circularButton.backgroundColor
///        circularRevealTransitioningDelegate.attach(to: destinationViewController)
///    }
///
/// }
public final class CircularRevealTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    public var duration: TimeInterval = 0.3
    
    public var startFrame: CGRect = CGRect.zero
    
    public var endFrame: CGRect = UIScreen.main.bounds
    
    public var circleColor: UIColor?
    
    public var fadeCircleDuringAnimation: Bool = false
    
    public override init() {
        super.init()
    }
    
    public init(startFrame: CGRect, endFrame: CGRect, circleColor: UIColor? = nil, duration: TimeInterval = 0.5, fadeCircleDuringAnimation: Bool = false) {
        super.init()
        self.duration = duration
        self.startFrame = startFrame
        self.endFrame = endFrame
        self.circleColor = circleColor
        self.fadeCircleDuringAnimation = fadeCircleDuringAnimation
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircularRevealTransitioning(startFrame: startFrame, endFrame: endFrame, circleColor: circleColor, presenting: true, duration: duration, fadeCircleDuringAnimation: fadeCircleDuringAnimation)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircularRevealTransitioning(startFrame: endFrame, endFrame: startFrame, circleColor: circleColor, presenting: false, duration: duration, fadeCircleDuringAnimation: fadeCircleDuringAnimation)
    }
        
}

#endif
