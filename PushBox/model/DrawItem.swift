//
//  DrawItem.swift
//  PushBox
//
//  Created by Wuhuijuan on 2022/9/14.
//

import Foundation
import UIKit

class DrawItem {
    var xIndex: Int = 0
    var yIndex: Int = 0
    var color: UIColor?
    convenience init(xIndex: Int, yIndex: Int, color: UIColor?) {
        self.init()
        self.xIndex = xIndex
        self.yIndex = yIndex
        self.color = color
    }
    
    static func == (lhs: DrawItem, rhs: DrawItem) -> Bool {
        return lhs.xIndex == rhs.xIndex &&
        lhs.yIndex == rhs.yIndex
    }
}
