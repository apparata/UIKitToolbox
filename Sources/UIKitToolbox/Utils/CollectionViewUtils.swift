//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

@MainActor
public func indexPathsForElementsInRect(collectionView: UICollectionView, rect: CGRect) -> [NSIndexPath]? {
    guard let allLayoutAttributes = collectionView.collectionViewLayout.layoutAttributesForElements(in: rect) else {
        return nil
    }
    guard allLayoutAttributes.count > 0 else {
        return nil
    }
    
    var indexPaths = [NSIndexPath]()
    for layoutAttributes in allLayoutAttributes {
        let indexPath = layoutAttributes.indexPath
        indexPaths.append(indexPath as NSIndexPath)
    }
    return indexPaths
}

@MainActor
public func dequeueCell<T: UICollectionViewCell>(collectionView: UICollectionView, identifier: String, for indexPath: IndexPath) -> T {
    return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
}

@MainActor
public func dequeueCell<T: CellReuseIdentifier>(collectionView: UICollectionView, for indexPath: IndexPath) -> T {
    return collectionView.dequeueReusableCell(withReuseIdentifier: T.cellReuseIdentifier, for: indexPath) as! T
}

#endif
