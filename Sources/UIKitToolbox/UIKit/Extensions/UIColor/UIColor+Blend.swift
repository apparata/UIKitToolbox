//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIColor {
        
    func blend(with color: UIColor, percent: CGFloat) -> UIColor {
        let t = min(1, max(0, percent))
        let from = components
        let to = color.components
        
        let red = (1 - t) * from.red + t * to.red
        let green = (1 - t) * from.green + t * to.green
        let blue = (1 - t) * from.blue + t * to.blue
        let alpha = (1 - t) * from.alpha + t * to.alpha
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

#endif
