//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

class PopAndSetRootSegue: UIStoryboardSegue {
    override func perform() {
        let navigationController = source.navigationController
        navigationController?.setViewControllers([destination], animated: true)
    }
}

#endif
