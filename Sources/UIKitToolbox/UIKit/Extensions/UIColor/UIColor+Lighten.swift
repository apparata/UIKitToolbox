//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIColor {
    
    func lighten(by delta: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return self
        }
        return UIColor(hue: hue, saturation: max(saturation - delta, 0), brightness: min(brightness + delta, 1), alpha: alpha)
    }
}

#endif
