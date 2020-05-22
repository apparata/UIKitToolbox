//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class GradientView: UIView {
    
    public var gradient: Gradient? {
        didSet {
            guard let gradient = gradient else {
                return
            }
            let gradientLayer = layer as! CAGradientLayer
            gradientLayer.colors = gradient.points.map {
                return $0.0.cgColor
            }
            gradientLayer.startPoint = CGPoint(x: 0.5, y: gradient.points.first!.1)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: gradient.points.last!.1)
        }
    }
    
    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    public override func awakeFromNib() {
        gradient = createGradient(from: 0xFFC371, to: 0xFF5F6D)
    }
    
    private func createGradient(from: Int, to: Int) -> Gradient {
        return Gradient(points: (color: UIColor(rgb: from), 0.0), (color: UIColor(rgb: to), 1.0))
    }
    
    public func setGradientAnimated(toGradient: Gradient, duration: TimeInterval) {
        
        let fromColors = (layer as! CAGradientLayer).colors
        
        let toColors = toGradient.points.map {
            return $0.0.cgColor
        }
        (layer as! CAGradientLayer).colors = toColors
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        layer.add(animation, forKey:"animateGradient")
    }
    
    public func setGradientColors(from: UIColor, to: UIColor) {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [from.cgColor, to.cgColor]
    }
}

#endif
