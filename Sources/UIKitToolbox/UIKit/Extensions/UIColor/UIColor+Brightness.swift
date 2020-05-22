//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIColor {
        
    func brightness(multiplier: CGFloat) -> UIColor {
        if let hsba = hsba {
            return UIColor(hue: hsba.h, saturation: hsba.s, brightness: hsba.b * multiplier, alpha: hsba.a)
        } else {
            // Well, let's see if it helps to create a new color in sRGB.
            let color = UIColor(rgb: self.rgb, alpha: 1)
            if let hsba = color.hsba {
                return UIColor(hue: hsba.h, saturation: hsba.s, brightness: hsba.b * multiplier, alpha: hsba.a)
            } else {
                return self
            }
        }
    }
}

#endif
