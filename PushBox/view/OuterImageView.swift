//
//  OuterImageView.swift
//  PushBox
//
//  Created by Wuhuijuan on 2022/9/9.
//

import Foundation
import UIKit

class OuterImageView: UIImageView {
    var width: CGFloat {
        didSet {
            setNeedsLayout()
        }
    }
    let shapeLayer = CAShapeLayer()
    init(image: UIImage?, width: CGFloat) {
        self.width = width
        super.init(image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let minLength = min(bounds.width, bounds.height)
        let innerLength = minLength - 2 * width
        let outerRect = CGRect(
            x: center.x - minLength / 2,
            y: center.y - minLength / 2,
            width: minLength,
            height: minLength)
        let outerPath = UIBezierPath(roundedRect: outerRect, cornerRadius: minLength / 2)
        
        let innerRect = CGRect(x: center.x - innerLength / 2, y: center.y - innerLength / 2, width: innerLength, height: innerLength)
        let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: innerLength / 2)
        outerPath.append(innerPath.reversing())
        shapeLayer.path = outerPath.cgPath
        layer.mask = shapeLayer
    }
}
