//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

import UIKit

extension UITextView {

    public var textUpToCaret: String? {
        guard let selectedRange = self.selectedTextRange else {
            return nil
        }
        let nsRange = NSRange(location: 0, length: offset(from: beginningOfDocument, to: selectedRange.start))
        guard let text = text else {
            return nil
        }
        guard let range = Range(nsRange, in: text) else {
            return nil
        }
        return String(text[range])
    }
}
