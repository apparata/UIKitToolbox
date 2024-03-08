//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class HorizontalLineView: UIView {

    @objc public var color: UIColor?

    @objc public var dash: CGFloat = 0.0

    @objc public var space: CGFloat = 0.0
    
    public init(color: UIColor, dash: CGFloat = 0.0, space: CGFloat = 0.0) {
        self.color = color
        self.dash = dash
        self.space = space
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        if let context = UIGraphicsGetCurrentContext() {
            draw1PixelStroke(context: context, startPoint: rect.origin, endPoint: CGPoint(x: rect.maxX, y: rect.maxY), color: color?.cgColor ?? UIColor.black.cgColor)
        }
    }

    private func draw1PixelStroke(context: CGContext, startPoint: CGPoint, endPoint: CGPoint, color: CGColor) {
        #if os(iOS)
        let lineWidth = 1.0 / UIScreen.main.scale
        #else
        let lineWidth = 0.5
        #endif
        context.saveGState()

        if dash > 0.0 || space > 0.0 {
            let phase = CGFloat(0.0)
            let lengths: [CGFloat] = [dash, space]
            context.setLineDash(phase: phase, lengths: lengths)
        }

        context.setLineCap(.square)
        context.setStrokeColor(color)
        context.setLineWidth(lineWidth)
        context.move(to: CGPoint(x: startPoint.x + lineWidth, y: lineWidth))
        context.addLine(to: CGPoint(x: endPoint.x + lineWidth, y: lineWidth))
        context.strokePath()
        context.restoreGState()
    }
}

#endif
