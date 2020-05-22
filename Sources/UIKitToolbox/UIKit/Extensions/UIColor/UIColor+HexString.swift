//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIColor {
            
    convenience init(hexString: String) {
        func hexCharacterToInt(_ character: Character) -> Int {
            let digits = "0123456789ABCDEF"
            guard let firstIndex = digits.firstIndex(of: character) else {
                return 0
            }
            return digits.distance(from: digits.startIndex, to: firstIndex)
        }
        var string = hexString
        if string.first == "#" {
            string = String(string.dropFirst())
        }
        if string.count == 3 {
            // Expecting an "RGB" type format.
            let r = CGFloat(hexCharacterToInt(string.removeFirst()) << 8) / 255.0
            let g = CGFloat(hexCharacterToInt(string.removeFirst()) << 8) / 255.0
            let b = CGFloat(hexCharacterToInt(string.removeFirst()) << 8) / 255.0
            self.init(red: r, green: g, blue: b, alpha: 1)
        } else if string.count == 4 {
            // Expecting an "RGBA" type format.
            let r = CGFloat(hexCharacterToInt(string.removeFirst()) << 8) / 255.0
            let g = CGFloat(hexCharacterToInt(string.removeFirst()) << 8) / 255.0
            let b = CGFloat(hexCharacterToInt(string.removeFirst()) << 8) / 255.0
            let a = CGFloat(hexCharacterToInt(string.removeFirst()) << 8) / 255.0
            self.init(red: r, green: g, blue: b, alpha: a)
        } else if string.count == 6 {
            // Expecting an "RRGGBB" type format.
            let r0 = hexCharacterToInt(string.removeFirst()) << 8
            let r1 = hexCharacterToInt(string.removeFirst())
            let r = CGFloat(r0 + r1) / 255.0
            let g0 = hexCharacterToInt(string.removeFirst()) << 8
            let g1 = hexCharacterToInt(string.removeFirst())
            let g = CGFloat(g0 + g1) / 255.0
            let b0 = hexCharacterToInt(string.removeFirst()) << 8
            let b1 = hexCharacterToInt(string.removeFirst())
            let b = CGFloat(b0 + b1) / 255.0
            self.init(red: r, green: g, blue: b, alpha: 1)
        } else if string.count == 8 {
            // Expecting an "RRGGBBAA" type format.
            let r0 = hexCharacterToInt(string.removeFirst()) << 8
            let r1 = hexCharacterToInt(string.removeFirst())
            let r = CGFloat(r0 + r1) / 255.0
            let g0 = hexCharacterToInt(string.removeFirst()) << 8
            let g1 = hexCharacterToInt(string.removeFirst())
            let g = CGFloat(g0 + g1) / 255.0
            let b0 = hexCharacterToInt(string.removeFirst()) << 8
            let b1 = hexCharacterToInt(string.removeFirst())
            let b = CGFloat(b0 + b1) / 255.0
            let a0 = hexCharacterToInt(string.removeFirst()) << 8
            let a1 = hexCharacterToInt(string.removeFirst())
            let a = CGFloat(a0 + a1) / 255.0
            self.init(red: r, green: g, blue: b, alpha: a)
        } else {
            // Default to black.
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
}

#endif
