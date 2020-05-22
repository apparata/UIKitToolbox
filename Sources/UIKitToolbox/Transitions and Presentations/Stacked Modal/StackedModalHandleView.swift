//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class StackedModalHandleView: UIView {
    
    public var isDragging: Bool = false {
        didSet {
            guard isDragging != oldValue else {
                return
            }
            let animation = CABasicAnimation(keyPath: "path")
            let fromPath = !isDragging ? straightLine : chevronLine
            animation.fromValue = fromPath
            let toPath = isDragging ? straightLine : chevronLine
            animation.toValue = toPath
            animation.duration = 0.2
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            handleLayer.add(animation, forKey: animation.keyPath)
            handleLayer.path = toPath
        }
    }
    
    public var didTap: (() -> Void)?
    
    private var handleLayer: CAShapeLayer!
    
    private let handleWidth: CGFloat = 35
    private let handleHeight: CGFloat = 11
    
    private var straightLine: CGPath?
    private var chevronLine: CGPath?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    private func setUp() {
        backgroundColor = .clear
        
        isUserInteractionEnabled = true
        
        setUpHandleLayer()
        setUpTapRecognizer()
    }
    
    private func setUpTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(recognizer:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func didTapView(recognizer: UITapGestureRecognizer) {
        if !isDragging {
            didTap?()
        }
    }
    
    private func setUpHandleLayer() {
        let straightLinePath = UIBezierPath()
        straightLinePath.move(to: CGPoint(x: 3.0, y: 3.0))
        straightLinePath.addLine(to: CGPoint(x: handleWidth / 2.0, y: 3.0))
        straightLinePath.addLine(to: CGPoint(x: handleWidth - 3.0, y: 3.0))
        straightLine = straightLinePath.cgPath
        
        let chevronLinePath = UIBezierPath()
        chevronLinePath.move(to: CGPoint(x: 3.0, y: 3.0))
        chevronLinePath.addLine(to: CGPoint(x: handleWidth / 2.0, y: handleHeight - 3.0))
        chevronLinePath.addLine(to: CGPoint(x: handleWidth - 3.0, y: 3.0))
        chevronLine = chevronLinePath.cgPath
        
        handleLayer = CAShapeLayer()
        handleLayer.frame = bounds
        handleLayer.path = chevronLine
        handleLayer.lineWidth = 5.0
        handleLayer.lineCap = CAShapeLayerLineCap.round
        handleLayer.lineJoin = CAShapeLayerLineJoin.bevel
        switch UITraitCollection.current.userInterfaceStyle {
        case .dark: handleLayer.strokeColor = UIColor(white: 0.24, alpha: 1.0).cgColor
        default: handleLayer.strokeColor = UIColor(white: 0.84, alpha: 1.0).cgColor
        }
        
        handleLayer.fillColor = nil
        layer.addSublayer(handleLayer)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        handleLayer.frame = CGRect(x: (bounds.size.width - handleWidth) / 2.0, y: 16.0, width: handleWidth, height: handleHeight)
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switch UITraitCollection.current.userInterfaceStyle {
        case .dark: handleLayer.strokeColor = UIColor(white: 0.24, alpha: 1.0).resolvedColor(with: UITraitCollection.current).cgColor
        default: handleLayer.strokeColor = UIColor(white: 0.84, alpha: 1.0).resolvedColor(with: UITraitCollection.current).cgColor
        }
    }
}

#endif
