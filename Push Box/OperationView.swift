//
//  OperationView.swift
//  Push Box
//
//  Created by Wuhuijuan on 2022/9/8.
//

import Foundation
import UIKit

class OperationView: UIView {

}

// MARK: - Draw
extension OperationView {
    override func draw(_ rect: CGRect) {
        drawBackground(rect)
        drawCircle(rect)
    }
    
    private func drawBackground(_ rect: CGRect) {
        UIColor.clear.set()
        let path = UIBezierPath(rect: rect)
        path.fill()
    }
    
    private func drawCircle(_ rect: CGRect) {
        let radius = min(rect.height, rect.width) * 0.5
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        UIColor.black.withAlphaComponent(0.5)
        path.fill()
    }

}
