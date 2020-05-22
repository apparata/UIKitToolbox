//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UITableViewController {
    
    func registerCellNibs(cellTypes: [UITableViewCell.Type]) {
        for cellType in cellTypes {
            cellType.registerNib(with: tableView)
        }
    }

    func registerCellNibs(cellTypes: UITableViewCell.Type...) {
        registerCellNibs(cellTypes: cellTypes)
    }
    
    func registerHeaderFooterNibs(types: [UIView.Type]) {
        for type in types {
            tableView.register(type, forHeaderFooterViewReuseIdentifier: String(describing: type))
        }
    }
    
    func registerHeaderFooterNibs(types: UIView.Type...) {
        registerHeaderFooterNibs(types: types)
    }
}

#endif
