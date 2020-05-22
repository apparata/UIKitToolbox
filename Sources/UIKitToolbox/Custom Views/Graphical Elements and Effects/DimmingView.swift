//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

/// The DimmingView is a view that is used to dim other views, most commonly
/// as part of transitions between view controllers.
///
/// The dimming view has a black background color with an alpha value that
/// defaults to 0.25, but changing the dimmingAlpha changes the value.
///
/// Typically, in a transition, the alpha of the view should be animated from
/// 0 to 1, as the background color already has an alpha value.
///
public class DimmingView: UIView {
    
    public var dimmingAlpha: CGFloat = 0.25 {
        didSet {
            backgroundColor = UIColor(white: 0.0, alpha: dimmingAlpha)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        backgroundColor = UIColor(white: 0.0, alpha: dimmingAlpha)
    }
}

#endif
