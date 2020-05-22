//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UICollectionView {
    
    func dequeueCell<T: UICollectionViewCell>(identifier: String, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
    
    func dequeueCell<T: CellReuseIdentifier>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.cellReuseIdentifier, for: indexPath) as! T
    }
    
}

#endif
