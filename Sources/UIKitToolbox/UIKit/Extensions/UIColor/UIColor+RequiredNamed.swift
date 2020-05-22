//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIColor {
        
    convenience init(requiredNamed imageName: String) {
        // This is required to exist. Otherwise, we crash.
        self.init(named: imageName)!
    }    
}

#endif
