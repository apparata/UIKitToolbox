//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

public extension UIBarButtonItem {
    
    static func backButtonWithoutTitle() -> UIBarButtonItem {
        return UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
}

#endif
