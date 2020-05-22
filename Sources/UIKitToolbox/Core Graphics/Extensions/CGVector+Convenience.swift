//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGVector {
        
    var normalized: CGVector {
        let k = sqrt(dx * dx + dy * dy)
        return CGVector(dx: dx / k, dy: dy / k)
    }
    
    init(both: CGFloat) {
        self.init()
        dx = both
        dy = both
    }
    
    init(size: CGSize) {
        self.init(dx: size.width, dy: size.height)
    }

    // MARK: Substitute value

    func with(dx: CGFloat) -> CGVector {
        return CGVector(dx: dx, dy: dy)
    }

    func with(dy: CGFloat) -> CGVector {
        return CGVector(dx: dx, dy: dy)
    }

    // MARK: Vector Math

    /// Dot product
    func dot(_ vector: CGVector) -> CGFloat {
        return dx * vector.dx + dy * vector.dy
    }
    
    /// Cross product
    func cross(_ vector: CGVector) -> CGFloat {
        return dx * vector.dy - dy * vector.dx
    }

}

