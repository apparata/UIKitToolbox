//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

/// Conforming classes have a child view controller that should be added
/// by calling the methods declared by the protocol.
@MainActor
public protocol ChildViewControllerAdder {
    
    var childViewControllerContainerView: UIView { get }
    
    var childViewController: UIViewController { get }
    
    /// The default implementation of this method does the following:
    /// 1. Adds the child view controller to the parent view controller.
    /// 2. Adds the child view to the container view.
    /// 3. Tells the child view controller that it `didMove` to the parent.
    func addChildViewController(to parentViewController: UIViewController)
    
    /// The default implementation of this method does the following:
    /// 1. Tells the child view controller that it `willMove` to `nil`.
    /// 2. Removes the child view from the container view.
    /// 3. Removes the child view controller from the parent view controller.
    func removeChildViewController()
}

public extension ChildViewControllerAdder {
    
    func addChildViewController(to parentViewController: UIViewController) {
        parentViewController.addChild(childViewController)
        childViewControllerContainerView.addSubview(childViewController.view)
        childViewController.view.frame = childViewControllerContainerView.bounds
        childViewController.didMove(toParent: parentViewController)
    }
    
    func removeChildViewController() {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
}

#endif
