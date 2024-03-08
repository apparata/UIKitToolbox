//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

@IBDesignable
class UnderlinedButton: UIButton {

    @IBInspectable var lineMargin: CGFloat = 3

    private weak var underlineLayer: CALayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUnderline()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUnderline()
    }

    private func setupUnderline() {
        let underline = CALayer()
        underline.backgroundColor = tintColor.cgColor
        self.layer.addSublayer(underline)
        self.underlineLayer = underline
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let labelFrame = self.titleLabel!.layer.frame
        self.underlineLayer.frame = CGRect(x: labelFrame.minX, y: labelFrame.maxY + self.lineMargin, width: labelFrame.width, height: 1)
    }

    override var isHighlighted: Bool {
        didSet {
            self.underlineLayer.opacity = isHighlighted ? 0.5 : 1.0
        }
    }
}

#endif
