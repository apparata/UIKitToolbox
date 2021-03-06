//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UITableView {
    
    func deselectSelectedRow() {
        if let indexPath = indexPathForSelectedRow {
            deselectRow(at: indexPath, animated: true)
        }
    }
}

#endif
