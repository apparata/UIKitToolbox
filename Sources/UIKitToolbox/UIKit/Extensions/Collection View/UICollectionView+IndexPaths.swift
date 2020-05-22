//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UICollectionView {
    
    func indexPathsForElementsInRect(rect: CGRect) -> [NSIndexPath]? {
        guard let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect) else {
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
    
}

#endif
