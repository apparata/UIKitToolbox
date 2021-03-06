//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UITableViewController {
        
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

#endif
