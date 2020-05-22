//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class FontLister {
    
    public static func listFonts() {
        for family: String in UIFont.familyNames {
            print("Font Family: \(family)")
            for name: String in UIFont.fontNames(forFamilyName: family) {
                print("- \(name)")
            }
        }
    }
}

#endif
