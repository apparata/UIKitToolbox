//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit
import UIKit.UIGestureRecognizerSubclass

public class DirectionalPanGestureRecognizer: UIPanGestureRecognizer {
    
    public enum Direction {
        case vertical
        case horizontal
    }
    
    public let direction: Direction
    
    public init(direction: Direction, target: Any?, action: Selector?) {
        self.direction = direction
        super.init(target: target, action: action)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        guard let view = self.view else {
            return
        }
        if state == .began {
            let velocity = self.velocity(in: view)
            switch direction {
            case .horizontal where abs(velocity.y) > abs(velocity.x):
                state = .cancelled
            case .vertical where abs(velocity.x) > abs(velocity.y):
                state = .cancelled
            default:
                break
            }
        }
    }
}

#endif
