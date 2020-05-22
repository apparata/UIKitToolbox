//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIColor {
        
    var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat)? {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return (h: hue, s: saturation, b: brightness, a: alpha)
        } else {
            return nil
        }
    }
}

#endif
