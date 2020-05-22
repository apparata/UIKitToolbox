
#if canImport(UIKit)

import UIKit

public extension CALayer {

    static func withoutAnimation(action: () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        action()
        CATransaction.commit()
    }

}

#endif
