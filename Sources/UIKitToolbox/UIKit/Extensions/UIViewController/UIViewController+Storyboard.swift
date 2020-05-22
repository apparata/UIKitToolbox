//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIViewController {
    
    private static func privateInstantiateFromStoryboard<T: UIViewController>(name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        guard let viewController = storyboard.instantiateInitialViewController() as? T else {
            fatalError("No such view controller '\(String(describing: self))'")
        }
        
        return viewController
    }
    
    static func instantiateFromStoryboard(name: String) -> Self {
        return privateInstantiateFromStoryboard(name: name)
    }
}

#endif
