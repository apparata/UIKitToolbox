//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UICollectionViewController {
    
    func registerCellNibs(cellTypes: [UICollectionViewCell.Type]) {
        for cellType in cellTypes {
            collectionView?.register(cellType.associatedNib, forCellWithReuseIdentifier: cellType.cellReuseIdentifier)
        }
    }
    
    func registerCellNibs(cellTypes: UICollectionViewCell.Type...) {
        for cellType in cellTypes {
            collectionView?.register(cellType.associatedNib, forCellWithReuseIdentifier: cellType.cellReuseIdentifier)
        }
    }
}

#endif
