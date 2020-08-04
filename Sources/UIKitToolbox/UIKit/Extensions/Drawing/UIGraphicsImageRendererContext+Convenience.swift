//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import UIKit

extension UIGraphicsImageRendererContext {
    
    final func clear(_ color: UIColor) {
        color.setFill()
        fill(format.bounds)
    }
    
    final func drawImage(_ image: UIImage, in rect: CGRect) {
        
        guard let cgImage = image.cgImage else {
            return
        }
        
        cgContext.saveGState()
        cgContext.translateBy(x: 0, y: rect.origin.y + rect.size.height)
        cgContext.scaleBy(x: 1.0, y: -1.0)
        cgContext.draw(cgImage, in: rect.with(y: 0))
        cgContext.restoreGState()
    }
    
    final func drawImage(_ image: UIImage, color: UIColor, in rect: CGRect) {

        guard let cgImage = image.cgImage else {
            return
        }
                
        cgContext.saveGState()
        cgContext.translateBy(x: 0, y: rect.origin.y + rect.size.height)
        cgContext.scaleBy(x: 1.0, y: -1.0)
        cgContext.clip(to: rect.with(y: 0), mask: cgImage)
        cgContext.setBlendMode(.normal)
        color.setFill()
        cgContext.fill(rect.with(y: 0))
        cgContext.restoreGState()
    }
}
