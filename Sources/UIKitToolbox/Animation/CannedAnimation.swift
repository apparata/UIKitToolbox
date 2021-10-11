//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class CannedAnimation {

    public static func shakeHorizontally(view: UIView) {
        shakeHorizontally(layer: view.layer)
    }
    
    public static func shakeHorizontally(layer: CALayer) {
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        shake.duration = 0.5
        shake.beginTime = CACurrentMediaTime()
        shake.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        layer.add(shake, forKey: "shake")
    }

    public static func crossFade(button: UIButton, newTitle: String, duration: TimeInterval = 0.4) {
        UIView.transition(with: button, duration: duration, options: .transitionCrossDissolve, animations: { () -> Void in
            button.setTitle(newTitle, for: .normal)
        }, completion: nil)
    }

    public static func crossFade(label: UILabel, newText: String, duration: TimeInterval = 0.4) {
        UIView.transition(with: label, duration: duration, options: .transitionCrossDissolve, animations: { () -> Void in
            label.text = newText
        }, completion: nil)
    }
    
    public static func crossFade(label: UILabel, newAttributedText: NSAttributedString?, duration: TimeInterval = 0.4) {
        UIView.transition(with: label, duration: duration, options: .transitionCrossDissolve, animations: { () -> Void in
            label.attributedText = newAttributedText
        }, completion: nil)
    }
    
    public static func crossFade(textField: UITextField, newText: String, duration: TimeInterval = 0.4) {
        UIView.transition(with: textField, duration: duration, options: .transitionCrossDissolve, animations: { () -> Void in
            textField.text = newText
        }, completion: nil)
    }
    
    public static func crossFade(imageView: UIImageView, newImage: UIImage, duration: TimeInterval = 0.4) {
        UIView.transition(with: imageView, duration: duration, options: .transitionCrossDissolve, animations: { () -> Void in
            imageView.image = newImage
        }, completion: nil)
    }
    
    public static func pushTransition(view: UIView, duration: CFTimeInterval = 0.4, direction: CATransitionSubtype) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = .push
        animation.subtype = direction
        animation.duration = duration
        view.layer.add(animation, forKey: "PushTransition")
    }
    
    public static func revealTransition(view: UIView, duration: CFTimeInterval = 0.4, direction: CATransitionSubtype) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = .reveal
        animation.subtype = direction
        animation.duration = duration
        view.layer.add(animation, forKey: "RevealTransition")
    }
    
    public static func fade(view: UIView, duration: TimeInterval = 0.5, fromAlpha: CGFloat? = nil, toAlpha: CGFloat, completion: (() -> Void)? = nil) {
        if let fromAlpha = fromAlpha {
            view.alpha = fromAlpha
        }
        ViewAnimation(duration: duration).easeInOut().animations {
            view.alpha = toAlpha
        }.completion { _ in
            completion?()
        }.start()
    }
    
    public static func fadeOut(view: UIView, duration: TimeInterval = 0.5, completion: (() -> Void)? = nil) {
        ViewAnimation(duration: duration).easeInOut().animations {
            view.alpha = 0.0
        }.completion { _ in
            completion?()
        }.start()
    }

    public static func fadeIn(view: UIView, duration: TimeInterval = 0.5, toAlpha: CGFloat = 1.0, completion: (() -> Void)? = nil) {
        ViewAnimation(duration: duration).easeInOut().animations {
            view.alpha = toAlpha
        }.completion { _ in
            completion?()
        }.start()
    }

    public static func fadeOutUpdateFadeIn(view: UIView, duration: TimeInterval = 0.5, updateBlock: @escaping () -> Void) {
        ViewAnimation(duration: duration).easeInOut().animations {
            view.alpha = 0.0
        }.completion { _ in
                updateBlock()
                ViewAnimation(duration: duration).easeInOut().animations {
                    view.alpha = 1.0
                }.start()
        }.start()
    }
    
    public static func fadeOutAndRemove(view: UIView, duration: TimeInterval = 0.5, completion: (() -> Void)? = nil) {
        ViewAnimation(duration: duration).easeInOut().animations {
            view.alpha = 0.0
            }.completion { _ in
                view.removeFromSuperview()
                completion?()
            }.start()
    }
    
    public static func fadeTextColor(label: UILabel, color: UIColor, duration: TimeInterval = 0.5) {
        ViewAnimation(duration: duration).easeInOut().animations {
            label.textColor = color
        }.start()
    }
}

#endif
