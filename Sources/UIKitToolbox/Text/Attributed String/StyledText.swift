//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct StyledString {
    
    public let attributedString: NSAttributedString
}

extension StyledString: ExpressibleByStringLiteral {
    
    public init(stringLiteral: String) {
        self.attributedString = NSAttributedString(string: stringLiteral)
    }
}

extension StyledString: CustomStringConvertible {
    
    public var description: String {
        return String(describing: self.attributedString)
    }
}

extension StyledString: ExpressibleByStringInterpolation {
    
    public init(stringInterpolation: StringInterpolation) {
        attributedString = NSAttributedString(attributedString: stringInterpolation.attributedString)
    }
    
    public struct StringInterpolation: StringInterpolationProtocol {
        
        var attributedString: NSMutableAttributedString
        
        public init(literalCapacity: Int, interpolationCount: Int) {
            attributedString = NSMutableAttributedString()
        }
        
        public func appendLiteral(_ literal: String) {
            attributedString.append(NSAttributedString(string: literal))
        }
        
        public func appendInterpolation(_ string: String, _ attributes: [NSAttributedString.Key: Any]) {
            attributedString.append(NSAttributedString(string: string, attributes: attributes))
        }
    }
}
