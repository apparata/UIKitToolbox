//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIColor {
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red: red, green: green, blue: blue, alpha: alpha)
    }
    
    var whiteComponent: (white: CGFloat, alpha: CGFloat) {
        var white: CGFloat = 0
        var alpha: CGFloat = 0
        getWhite(&white, alpha: &alpha)
        return (white: white, alpha: alpha)
    }
}

#endif
