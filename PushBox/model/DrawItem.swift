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
    convenience init(xIndex: Int, yIndex: Int) {
        self.init()
        self.xIndex = xIndex
        self.yIndex = yIndex
    }
    
    static func == (lhs: DrawItem, rhs: DrawItem) -> Bool {
        return lhs.xIndex == rhs.xIndex &&
        lhs.yIndex == rhs.yIndex
    }
}

enum Mode {
    case line, empty, normal, full, person, obstacles
    func image() -> UIImage? {
        var str = ""
        switch self {
        case .line:
            str = "line"
        case .empty:
            str = "empty"
        case .normal:
            str = "normal"
        case .full:
            str = "full"
        case .person:
            str = "person"
        case .obstacles:
            str = "line"
        }
        return UIImage(named: str)
    }
}
