//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGRect {
    
    var center: CGPoint {
        get {
            return CGPoint(x: self.midX, y: self.midY)
        }
        set {
            origin = CGPoint(x: newValue.x - size.width / 2.0, y: newValue.y - size.height / 2.0)
        }
    }
    
    var min: CGPoint {
        get {
            return origin
        }
        set {
            origin = newValue
        }
    }
    
    var max: CGPoint {
        get {
            return CGPoint(x: self.maxX, y: self.maxY)
        }
        set {
            origin = CGPoint(x: newValue.x - size.width, y: newValue.y - size.height)
        }
    }
    
    /// Flip X and Y axes.
    var transposed: CGRect {
        return CGRect(x: origin.y, y: origin.x, width: size.height, height: size.width)
    }
    
    // MARK: Initializers
    
    init(center: CGPoint, size: CGSize) {
        self.init()
        self.size = size
        self.origin = CGPoint(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0)
    }
    
    // MARK: Substitute value
    
    func with(x: CGFloat) -> CGRect {
        return CGRect(x: x, y: origin.y, width: size.width, height: size.height)
    }

    func with(y: CGFloat) -> CGRect {
        return CGRect(x: origin.x, y: y, width: size.width, height: size.height)
    }

    func with(width: CGFloat) -> CGRect {
        return CGRect(x: origin.x, y: origin.y, width: width, height: size.height)
    }

    func with(height: CGFloat) -> CGRect {
        return CGRect(x: origin.x, y: origin.y, width: size.width, height: height)
    }
    
    func with(origin: CGPoint) -> CGRect {
        return CGRect(origin: origin, size: size)
    }

    func with(size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }

    func with(center: CGPoint) -> CGRect {
        return CGRect(center: center, size: size)
    }
    
    // MARK: Creating Rectangles
    
    /// Align center of this rectangle with center of other rectangle.
    func centerInRect(_ rect: CGRect) -> CGRect {
        return CGRect(center: rect.center, size: size)
    }

    /// Returns a rectangle with an origin that is offset from that of the
    /// source rectangle.
    func offset(_ point: CGPoint) -> CGRect {
        return self.offsetBy(dx: point.x, dy: point.y)
    }

    /// Returns a rectangle with an origin that is offset from that of the
    /// source rectangle.
    func offset(_ size: CGSize) -> CGRect {
        return self.offsetBy(dx: size.width, dy: size.height)
    }

    /// Returns a rectangle with an origin that is offset from that of the
    /// source rectangle.
    func offset(_ delta: CGVector) -> CGRect {
        return self.offsetBy(dx: delta.dx, dy: delta.dy)
    }
    
    /// Returns the largest rectangle with the specified aspect ratio that fits
    /// inside the source rectangle.
    ///
    /// - parameter aspectRatioSize: The size is only used for aspect ratio.
    func fitInsideWithAspectRatio(_ aspectRatioSize: CGSize) -> CGRect {
        let aspectRatio = size.width / size.height
        let targetAspectRatio = aspectRatioSize.width / aspectRatioSize.height
        if aspectRatio > targetAspectRatio {
            // Source rect is wider
            let targetWidth = targetAspectRatio * size.height
            return CGRect(center: center, size: CGSize(width: targetWidth, height: size.height))
        } else {
            // Source rect is taller
            let targetHeight = targetAspectRatio * size.width
            return CGRect(center: center, size: CGSize(width: targetHeight, height: size.width))
        }
    }    
}
