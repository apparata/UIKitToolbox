//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

extension UICollectionViewCell: CellReuseIdentifier, AssociatedNib {
    
    public static func instantiateFromNib<T: UICollectionViewCell>(owner: Any? = nil) -> T? {
        let topLevelObjects = associatedNib.instantiate(withOwner: owner, options: nil)
        return topLevelObjects[0] as? T
    }
    
    public static func register(on collectionView: UICollectionView) {
        collectionView.register(associatedNib, forCellWithReuseIdentifier: cellReuseIdentifier)
    }
}

#endif
