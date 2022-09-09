//
//  OperationView.swift
//  PushBox
//
//  Created by Wuhuijuan on 2022/9/8.
//

import Foundation
import UIKit

class OperationView: UIView {
    private var directions: [Direction]
    private var minLength: CGFloat = 0
    private let interval: Double = 1
    public var didLongPress: (Direction, OperationView) -> Void
    
    /// 箭头大小
    private let imageWidth: CGFloat = 40
    /// 操作球大小
    private let rockerWidth: CGFloat = 40
    /// 触摸点
    private var touchPoint: CGPoint?
    /// 标识箭头大小
    private let outerArrowWidth: CGFloat = 15
    private lazy var timer = Timer.scheduledTimer(
        timeInterval: interval,
        target: self,
        selector: #selector(timerAction(_:)),
        userInfo: nil,
        repeats: true)
    
    private lazy var outerImageView = OuterImageView(image: UIImage(named: "ptz_direction_mask"), width: outerArrowWidth)
    
    init(directions: [Direction], didLongPress: @escaping(Direction, OperationView) -> Void) {
        self.directions = directions
        self.didLongPress = didLongPress
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
        addSubview(outerImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func isDirectionSelected(_ direction: Direction) -> Bool {
        guard let index = direction.bitIndexs().first else { return false }
        
        var selected = false
        var preIndex = index - 1
        if preIndex < 0 {
            preIndex = 7
        }
        var behindIndex = index + 1
        if behindIndex > 7 {
            behindIndex = 0
        }
        
        let preDirection = Direction(rawValue: 1 << preIndex)
        let behindDirection = Direction(rawValue: 1 << behindIndex)
        if let touchPoint = touchPoint {
            let vector = CGPoint(x: touchPoint.x - bounds.width / 2, y: touchPoint.y - bounds.height / 2)
            var pointAngle = atan2(vector.y, vector.x)
            if pointAngle < 0 {
                pointAngle += 2 * .pi
            }
            
            var prePointAngle = pointAngle - .pi / 8
            if prePointAngle < 0 {
                prePointAngle += 2 * .pi
            }
            
            var behindPointAngle = pointAngle + .pi / 8
            if behindPointAngle > 2 * .pi {
                behindPointAngle -= 2 * .pi
            }
            
            selected = direction.has(angle: pointAngle)
            if !selected && !directions.contains(preDirection) {
                selected = preDirection.has(angle: prePointAngle)
            }
            if !selected && !directions.contains(behindDirection) {
                selected = behindDirection.has(angle: behindPointAngle)
            }
        }
        return selected
    }
    
    private var selectedDirection: Direction? {
        for i in 0..<8 {
            let direction = Direction(rawValue: 1 << i)

            if directions.contains(direction) {
                if isDirectionSelected(direction) {
                    return direction
                }
            }
        }
        return nil
    }
}

// MARK: - Draw View
extension OperationView {
    override func draw(_ rect: CGRect) {
        minLength = min(rect.height, rect.width)
        outerImageView.width = outerArrowWidth
        drawBackground(rect)
        drawCircle(rect)
        drawRocker()
        drawOuterArrow()
        drawSupportArrow()
    }
    
    private func drawBackground(_ rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        UIColor.clear.set()
        path.fill()
    }
    
    private func drawCircle(_ rect: CGRect) {
        let radius = minLength * 0.5
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        path.addClip()
        UIColor.black.withAlphaComponent(0.5).set()
        path.fill()
    }
    
    private func drawOuterArrow() {
        outerImageView.isHidden = true
        for i in 0..<8 {
            let direction = Direction(rawValue: 1 << i)
            if directions.contains(direction) {
                let selected = isDirectionSelected(direction)
                guard selected, let index = direction.bitIndexs().first else { continue }
                outerImageView.isHidden = false
                let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
                outerImageView.bounds = CGRect(x: 0, y: 0, width: minLength, height: minLength)
                outerImageView.center = center
                outerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(index) * .pi / 4 + .pi / 2)
            }
        }
    }

    private func drawSupportArrow() {
        for i in 0..<8 {
            let direction = Direction(rawValue: 1 << i)
            if directions.contains(direction) {
                let selected = isDirectionSelected(direction)
                let angle = CGFloat(i) * .pi / 4
                drawArrow(angle: angle, selected: selected)
            }
        }
    }
    
    private func drawArrow(angle: CGFloat, selected: Bool) {
        let center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        let radius = minLength * 0.5 - imageWidth * 0.5 - 15
        let realImageCenter = CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle) * radius)
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.saveGState()
        ctx.translateBy(x: realImageCenter.x, y: realImageCenter.y)
        ctx.rotate(by: angle)
        
        let arrowImage = selected ? UIImage(named: "ptz_arrow_right") : UIImage(named: "ptz_arrow_right")
        arrowImage?.draw(in: CGRect(x: 0 - imageWidth * 0.5, y: 0 - imageWidth * 0.5, width: imageWidth, height: imageWidth))
        ctx.restoreGState()
    }
    
    private func drawRocker() {
        var rect: CGRect = .zero
        if touchPoint == nil {
            rect = CGRect(
                x: bounds.width / 2 - rockerWidth / 2,
                y: bounds.height / 2 - rockerWidth / 2,
                width: rockerWidth,
                height: rockerWidth)
        } else if let touchPoint = touchPoint {
            let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
            let offset = CGPoint(x: touchPoint.x - center.x, y: touchPoint.y - center.y)
            let radius = minLength / 2 - rockerWidth / 2
            let offsetRadius = sqrt(pow(offset.x, 2) + pow(offset.y, 2))
            rect = CGRect(
                x: touchPoint.x - rockerWidth / 2,
                y: touchPoint.y - rockerWidth / 2,
                width: rockerWidth,
                height: rockerWidth)
            if offsetRadius > radius {
                // 限制位于圆内
                let rate = radius / offsetRadius
                rect.origin.x = center.x + rate * offset.x - rockerWidth / 2
                rect.origin.y = center.y + rate * offset.y - rockerWidth / 2
            }
        }
        let path = UIBezierPath(roundedRect: rect, cornerRadius: rockerWidth / 2)
        UIColor(red: 251 / 255.0, green: 251 / 255.0, blue: 251 / 255.0, alpha: 0.8).set()
        path.fill()
    }
}

// MARK: - Touch Event
extension OperationView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        touchPoint = point
        setNeedsDisplay()
        
        timer.fireDate = Date().addingTimeInterval(interval)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        let preDirection = selectedDirection // 记录切换前方向
        touchPoint = point
        setNeedsDisplay()
        
        // 长按，且方向有变化，回调一次新方向
        let currentDirection = selectedDirection
        if let preDirection = preDirection, let currentDirection = currentDirection {
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchPoint = nil
        setNeedsDisplay()
        
        timer.fireDate = Date.distantFuture
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchPoint = nil
        setNeedsDisplay()
        
        timer.fireDate = Date.distantFuture
    }
    
    @objc func timerAction(_ timer: Timer) {
        guard let direction = selectedDirection else { return }
        didLongPress(direction, self)
    }
}

// MARK: - Direction Struct
extension OperationView {
    struct Direction: OptionSet {
        var rawValue: Int
        
        typealias RawValue = Int
        static let right = Direction(rawValue: 1 << 0)
        static let lowerright = Direction(rawValue: 1 << 1)
        static let down = Direction(rawValue: 1 << 2)
        static let lowerleft = Direction(rawValue: 1 << 3)
        static let left = Direction(rawValue: 1 << 4)
        static let upperleft = Direction(rawValue: 1 << 5)
        static let up = Direction(rawValue: 1 << 6)
        static let upperright = Direction(rawValue: 1 << 7)
        
        func has(angle: CGFloat) -> Bool {
            var hasAngle = false
            for i in 0..<8 {
                if !contains(Direction(rawValue: 1 << i)) {
                    continue
                }
                let startAngle = (CGFloat(i) - 0.5) * .pi / 4
                let endAngle = (CGFloat(i) + 0.5) * .pi / 4
                if startAngle < 0 {
                    hasAngle = ((startAngle + .pi * 2) ..< .pi * 2).contains(angle) || (0..<endAngle).contains(angle)
                } else {
                    hasAngle = (startAngle..<endAngle).contains(angle)
                }
                if hasAngle {
                    break
                }
            }
            return hasAngle
        }
        
        func bitIndexs() -> [Int] {
            var array: [Int] = []
            for i in 0..<8 {
                if contains(Direction(rawValue: 1 << i)) {
                    array.append(i)
                }
            }
            return array
        }
    }
}
