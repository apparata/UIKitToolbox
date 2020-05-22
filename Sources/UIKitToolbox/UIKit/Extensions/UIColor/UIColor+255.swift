//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIColor {
                
    /// Convenience init function for initializing a color with RGB hex value.
    convenience init(r: Int8, g: Int8, b: Int8, a: CGFloat = 1.0) {
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: a)
    }
}

#endif
