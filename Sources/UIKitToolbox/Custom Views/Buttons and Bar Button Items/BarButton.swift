//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

public typealias BarButtonAction = (BarButton) -> Void

public class BarButton: UIBarButtonItem {
    
    public var actionHandler: BarButtonAction?
    
    public init(title: String?, style: UIBarButtonItem.Style = .plain, action: @escaping BarButtonAction) {
        super.init()
        actionHandler = action
        super.title = title
        super.image = nil
        super.customView = nil
        super.style = style
        super.target = self
        super.action = #selector(handleAction)
    }

    public init(image: UIImage?, style: UIBarButtonItem.Style = .plain, action: @escaping BarButtonAction) {
        super.init()
        actionHandler = action
        super.title = nil
        super.image = image
        super.customView = nil
        super.style = style
        super.target = self
        super.action = #selector(handleAction)
    }
    
    public init(customView: UIView, style: UIBarButtonItem.Style = .plain, action: @escaping BarButtonAction) {
        super.init()
        actionHandler = action
        super.title = title
        super.image = nil
        super.customView = customView
        super.style = style
        super.target = self
        super.action = #selector(handleAction)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func handleAction() {
        actionHandler?(self)
    }
}

#endif
