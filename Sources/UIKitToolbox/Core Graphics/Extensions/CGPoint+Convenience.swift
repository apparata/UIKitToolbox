//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGPoint {
    
    init(size: CGSize) {
        self.init()
        x = size.width
        y = size.height
    }
    
    init(both: CGFloat) {
        self.init()
        x = both
        y = both
    }

    // MARK: Substitute value

    func with(x: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }

    func with(y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
}

