//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public protocol AssociatedNib {
    
    static var associatedNib: UINib { get }
}

public extension AssociatedNib {

    static var associatedNib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}

#endif
