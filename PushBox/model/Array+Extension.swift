//
//  Array+Extension.swift
//  PushBox
//
//  Created by Wuhuijuan on 2022/9/14.
//

import Foundation

extension Array where Element == DrawItem {
    func isContains(_ item: DrawItem) -> Bool {
        var hasItem = false
        self.forEach { direction in
            if direction == item {
                hasItem = true
            }
        }
        return hasItem
    }
}
