//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UITableView {
    
    func dequeueCell<T: UITableViewCell>(identifier: String, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }

    func dequeueCell<T: CellReuseIdentifier>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.cellReuseIdentifier, for: indexPath) as! T
    }

    func dequeueHeaderFooter<T: UIView>(identifier: String) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: identifier) as! T
    }
    
    func dequeueHeaderFooter<T: CellReuseIdentifier>() -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.cellReuseIdentifier)) as! T
    }

}

#endif
