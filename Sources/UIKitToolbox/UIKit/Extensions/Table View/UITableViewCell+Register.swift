//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UITableViewCell {
    
    static func registerClass(with tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    static func registerNib(with tableView: UITableView) {
        tableView.register(associatedNib, forCellReuseIdentifier: cellReuseIdentifier)
    }
}

#endif
