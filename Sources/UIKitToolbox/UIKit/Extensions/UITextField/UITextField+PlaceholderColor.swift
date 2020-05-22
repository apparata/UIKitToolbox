//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UITextField {
    
    func setPlaceholderColor(color: UIColor?) {
        guard let placeholder = self.placeholder else {
            return
        }
        
        if let color = color {
            let color = [NSAttributedString.Key.foregroundColor: color]
            self.attributedPlaceholder = AttributedStringBuilder().text(placeholder, color).build()
        } else {
            self.placeholder = placeholder
        }
    }
}

#endif
