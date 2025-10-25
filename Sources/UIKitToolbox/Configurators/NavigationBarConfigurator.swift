//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

@MainActor
public class NavigationBarConfigurator {
    
    private weak var navigationBar: UINavigationBar?
    
    public init(_ navigationBar: UINavigationBar) {
        self.navigationBar = navigationBar
    }
    
    @discardableResult
    public func solidBar(color: UIColor, shadowColor: UIColor) -> NavigationBarConfigurator {
        return solidBar(colorImage: UIImage(color: color), shadowImage: UIImage(color: shadowColor))
    }
    
    @discardableResult
    public func solidBar(color: UIColor, shadowImage: UIImage?) -> NavigationBarConfigurator {
        return solidBar(colorImage: UIImage(color: color), shadowImage: shadowImage)
    }
    
    @discardableResult
    public func solidBar(colorImage: UIImage?, shadowImage: UIImage?) -> NavigationBarConfigurator {
        navigationBar?.setBackgroundImage(colorImage, for: .default)
        navigationBar?.setBackgroundImage(colorImage, for: .compact)
        navigationBar?.setBackgroundImage(colorImage, for: .defaultPrompt)
        navigationBar?.setBackgroundImage(colorImage, for: .compactPrompt)
        navigationBar?.shadowImage = shadowImage
        return self
    }

    @discardableResult
    public func transparentBar() -> NavigationBarConfigurator {
        navigationBar?.isTranslucent = true
        navigationBar?.backgroundColor = UIColor.clear
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.setBackgroundImage(UIImage(), for: .compact)
        navigationBar?.setBackgroundImage(UIImage(), for: .defaultPrompt)
        navigationBar?.setBackgroundImage(UIImage(), for: .compactPrompt)
        navigationBar?.shadowImage = UIImage()
        return self
    }
}

#endif
