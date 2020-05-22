//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class CannedMotionEffects {
    
    public static func tilt(amplitude: NSInteger = 15) -> UIMotionEffect {
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -amplitude
        horizontalMotionEffect.maximumRelativeValue = amplitude
        
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -amplitude
        verticalMotionEffect.maximumRelativeValue = amplitude
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizontalMotionEffect, verticalMotionEffect];
        
        return motionEffectGroup
    }
}

#endif
