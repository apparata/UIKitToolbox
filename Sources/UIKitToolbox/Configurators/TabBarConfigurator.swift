//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

@MainActor
public class TabBarConfigurator {
    
    private let tabBar: UITabBar?
    
    public init(_ tabBar: UITabBar?) {
        self.tabBar = tabBar
    }
    
    @discardableResult
    public func solidBar(color: UIColor, shadowColor: UIColor) -> TabBarConfigurator  {
        return solidBar(colorImage: UIImage(color: color), shadowImage: UIImage(color: shadowColor))
    }
    
    @discardableResult
    public func solidBar(color: UIColor, shadowImage: UIImage?) -> TabBarConfigurator  {
        return solidBar(colorImage: UIImage(color: color), shadowImage: shadowImage)
    }
    
    @discardableResult
    public func solidBar(colorImage: UIImage?, shadowImage: UIImage?) -> TabBarConfigurator  {
        tabBar?.backgroundImage = colorImage
        tabBar?.shadowImage = shadowImage
        return self
    }
}

#endif
