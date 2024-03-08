//
//  Copyright © 2015 Apparata. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

/// Button with adjustable hit area using insets.
public class CustomHitAreaButton: UIButton {
    
    public var hitAreaInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if (hitAreaInsets == UIEdgeInsets.zero) || !isEnabled || isHidden {
            return super.point(inside: point, with:event)
        }
        
        let hitArea = bounds.inset(by: hitAreaInsets);
        return hitArea.contains(point);
    }
}

#endif
