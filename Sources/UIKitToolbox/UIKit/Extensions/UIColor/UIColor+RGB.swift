//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIColor {
        
    var rgb: Int {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return 0
        }
        let r = Int(min(max(red * 255, 0), 255))
        let g = Int(min(max(green * 255, 0), 255))
        let b = Int(min(max(blue * 255, 0), 255))
        
        return r << 16 + g << 8 + b
    }
    
    /// Convenience init function for initializing a color with RGB hex value.
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

#endif
