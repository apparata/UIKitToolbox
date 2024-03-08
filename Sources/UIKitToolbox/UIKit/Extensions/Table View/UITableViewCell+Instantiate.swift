//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

extension UITableViewCell: CellReuseIdentifier {
    
}

extension UITableViewCell: AssociatedNib {
    
    private static func instantiateFromNibHelper<T: UITableViewCell>(owner: Any? = nil) -> T {
        let topLevelObjects = associatedNib.instantiate(withOwner: owner, options: nil)
        if let cell: T = topLevelObjects.first as? T {
            return cell
        } else {
            fatalError("Nib must exist and contain a cell.")
        }
    }
    
    public static func instantiateFromNib(owner: Any? = nil) throws -> Self {
        return instantiateFromNibHelper(owner: owner)
    }
}

#endif
