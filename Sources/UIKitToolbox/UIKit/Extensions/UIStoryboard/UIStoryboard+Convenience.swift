//
// Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIStoryboard {
    
    static func instantiateViewController<T>(
        from storyboardName: String,
        ofType type: T.Type) -> T where T: UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(ofType: type)
    }
    
    func instantiateViewController<T>(ofType type: T.Type) -> T where T: UIViewController {
        // We will crash on purpose if the view controller is not
        // of the correct type, as this is a programmer error.
        return instantiateInitialViewController() as! T
    }
    
    static func instantiateNavigationController<Child>(
        from storyboardName: String,
        childOfType type: Child.Type) -> (UINavigationController, Child)
        where Child : UIViewController {
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            return storyboard.instantiateNavigationController(childOfType: type)
    }
    
    func instantiateNavigationController<Child>(childOfType type: Child.Type) -> (UINavigationController, Child)
        where Child : UIViewController {
            let navigationController = instantiateViewController(ofType: UINavigationController.self)
            // We will crash on purpose if the view controller is not
            // of the correct type, as this is a programmer error.
            let childViewController = navigationController.children[0] as! Child
            return (navigationController, childViewController)
    }
}

#endif
