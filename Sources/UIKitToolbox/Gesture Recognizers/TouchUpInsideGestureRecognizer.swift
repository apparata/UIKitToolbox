//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit
import UIKit.UIGestureRecognizerSubclass

/// The normal tap gesture recognizer doesn't let you detect touch down.
/// If you need to e.g. highlight a button on touch down, you can do that
/// in the action method for the began state.
public class TouchUpInsideGestureRecognizer: UIGestureRecognizer {
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        if state == .possible {
            state = .began
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        guard let view = view else {
            return
        }
        for touch in touches {
            if !view.bounds.contains(touch.location(in: view)) {
                state = .failed
                return
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        guard let view = view else {
            return
        }
        for touch in touches {
            if !view.bounds.contains(touch.location(in: view)) {
                state = .failed
                return
            }
        }
        state = .recognized
    }
}

#endif
