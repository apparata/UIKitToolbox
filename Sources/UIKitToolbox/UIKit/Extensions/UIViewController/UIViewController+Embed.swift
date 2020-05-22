//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIViewController {
    
    func embed(_ child: UIViewController, in containerView: UIView) {
        addChild(child)
        containerView.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = true
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.view.frame = containerView.bounds
        child.didMove(toParent: self)
    }
}

#endif

