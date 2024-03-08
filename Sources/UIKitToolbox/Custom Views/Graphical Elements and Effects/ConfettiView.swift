//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

public class ConfettiView: UIView {
    
    private let emitterLayer = CAEmitterLayer()
    
    private let particleImage = ConfettiParticleImage.make()
    
    public var colors = [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
                         UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
                         UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
                         UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
                         UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)] {
        didSet {
            if isEnabled {
                end()
                start()
            }
        }
    }
    
    public var intensity: Float = 0.5
    
    /// Set to CACurrentMediaTime() to start right now.
    public var beginTime: CFTimeInterval?
    
    public var isEnabled: Bool = false {
        didSet {
            if isEnabled {
                start()
            } else {
                end()
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override public func layoutSubviews() {
        let width = bounds.size.width
        emitterLayer.emitterPosition = CGPoint(x: width / 2.0, y: 0)
        emitterLayer.emitterSize = CGSize(width: width, height: 1.0)
    }
    
    private func start() {
        let cells: [CAEmitterCell] = colors.compactMap { [weak self] in
            self?.createCell(color: $0)
        }
        
        emitterLayer.beginTime = beginTime ?? 0.0
        emitterLayer.emitterCells = cells
        emitterLayer.birthRate = 1.0
    }
    
    private func end() {
        emitterLayer.birthRate = 0.0
    }
    
    private func setUp() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
        emitterLayer.emitterShape = .line
        layer.addSublayer(emitterLayer)
    }
    
    private func createCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 6.0 * intensity
        cell.lifetime = 7.0
        cell.lifetimeRange = 0
        cell.color = color.cgColor
        cell.velocity = 175.0
        cell.velocityRange = 40.0
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4.0
        cell.spin = 3.5 * 0.5
        cell.spinRange = 2.0
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.1 * 0.5
        cell.contents = particleImage.cgImage
        return cell
    }
}

public final class ConfettiParticleImage {
    
    private static let imageBase64 = "iVBORw0KGgoAAAANSUhEUgAAAA8AAAAOCAYAAADwikbvAAAABGdBTUEAALGPC/xhBQAAAMpJREFUKBVjYCAA/v//rwLED4C4HYh1CShHlYZqAlJwcAnIqgBiOVSVaDygAn4gfgvE2MABNOWoXKCOadh0QcXiUFUj8YAKAoD4Hw7NL4DiHEjKEUygRCoQ/8ahESRchlANZQEFDYD4IEgWDwAFGBtcM5BjCsTrgRiXM4FSYAByjTGyRnWoBDFUBVwjjAHUtYMInUUw9Sg0UKMtHs1fgHLxKBrQOUAFh7AYsBooJoOuFoMPVOSOpPk4kO2CoQifAFDDFCB2wqcGWQ4Agnusxq4Bk5wAAAAASUVORK5CYII="
    
    public static func make() -> UIImage {
        guard let data = Data(base64Encoded: imageBase64, options: .ignoreUnknownCharacters) else {
            return UIImage()
        }
        guard let image = UIImage(data: data) else {
            return UIImage()
        }
        return image
    }    
}

#endif
