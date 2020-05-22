//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public struct Gradient {
    
    /// Location is in the range [0, 1]
    public typealias Point = (UIColor, Double)
    
    public var points: [Point]
    
    public var reversed: Gradient {
        let reversedPoints = points.reversed().map {
            ($0.0, 1.0 - $0.1)
        }
        return Gradient(points: reversedPoints)
    }
    
    public init(points: Point...) {
        self.points = points
    }
    
    public init(points: [Point]) {
        self.points = points
    }
}

#endif
