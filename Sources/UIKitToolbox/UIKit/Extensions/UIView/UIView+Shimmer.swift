//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIView {
    
    func startShimmer() {
        let light = UIColor.black.withAlphaComponent(0.0).cgColor
        let dark = UIColor.black.cgColor
        
        let gradientLayer: CAGradientLayer = {
            $0.colors = [dark, light, dark]
            $0.frame = CGRect(x: -bounds.width, y: 0.0, width: 3 * bounds.width, height: bounds.height)
            $0.startPoint = CGPoint(x: 0, y: 0.5)
            $0.endPoint = CGPoint(x: 1.0, y: 0.525)
            $0.locations = [0.4, 0.5, 0.6]
            return $0
        }(CAGradientLayer())
        
        layer.mask = gradientLayer
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        
        animation.duration = 1.5
        animation.repeatCount = .greatestFiniteMagnitude
        
        gradientLayer.add(animation, forKey: "shimmer")
    }
    
    func stopShimmer() {
        layer.mask = nil
    }
    
}

#endif
