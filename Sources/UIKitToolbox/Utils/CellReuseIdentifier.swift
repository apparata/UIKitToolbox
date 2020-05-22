//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

/// For use with table and collection view cells.
public protocol CellReuseIdentifier {
    static var cellReuseIdentifier: String { get }
}

extension CellReuseIdentifier {
    
    public static var cellReuseIdentifier: String {
        return String(describing: self)
    }
}

#endif
