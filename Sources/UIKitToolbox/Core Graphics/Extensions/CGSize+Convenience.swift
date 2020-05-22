//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGSize {
    
    var halfSize: CGSize {
        return CGSize(width: self.width / 2.0, height: self.height / 2.0)
    }
    
    init(point: CGPoint) {
        self.init()
        width = point.x
        height = point.y
    }
    
    init(both: CGFloat) {
        self.init()
        width = both
        height = both
    }

    // MARK: Substitute value

    func with(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: height)
    }

    func with(height: CGFloat) -> CGSize {
        return CGSize(width: width, height: height)
    }
}
