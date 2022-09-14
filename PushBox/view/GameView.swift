//
//  GameView.swift
//  PushBox
//
//  Created by Wuhuijuan on 2022/9/9.
//

import Foundation
import UIKit

extension GameView {
    func updateUI(with direction: OperationView.Direction) {
        guard let personItem = personItem else { return }
        var nearArr: [DrawItem] = []
        switch direction {
        case .left:
            let index = personItem.xIndex - 1
            let item = DrawItem(xIndex: index, yIndex: personItem.yIndex)
            var nearItem = item
            while boxArr.isContains(nearItem) {
                nearArr.append(nearItem)
                nearItem = DrawItem(xIndex: nearItem.xIndex - 1, yIndex: nearItem.yIndex)
            }
            if nearArr.last?.xIndex ?? rightIndex <= leftIndex + 1 || obstaclesArr.isContains(nearItem) {
                nearArr.removeAll()
                break
            }
            personItem.xIndex = index < leftIndex + 1 ? leftIndex + 1 : index
        case .right:
            let index = personItem.xIndex + 1
            let item = DrawItem(xIndex: index, yIndex: personItem.yIndex)
            var nearItem = item
            while boxArr.isContains(nearItem) {
                nearArr.append(nearItem)
                nearItem = DrawItem(xIndex: nearItem.xIndex + 1, yIndex: nearItem.yIndex)
            }
            if nearArr.last?.xIndex ?? leftIndex >= rightIndex - 1 || obstaclesArr.isContains(nearItem) {
                nearArr.removeAll()
                break
            }
            personItem.xIndex = index > rightIndex - 1 ? rightIndex - 1 : index
        case .up:
            let index = personItem.yIndex - 1
            let item = DrawItem(xIndex: personItem.xIndex, yIndex: index)
            var nearItem = item
            while boxArr.isContains(nearItem) {
                nearArr.append(nearItem)
                nearItem = DrawItem(xIndex: nearItem.xIndex, yIndex: nearItem.yIndex - 1)
            }
            if nearArr.last?.yIndex ?? bottomIndex <= topIndex + 1 || obstaclesArr.isContains(nearItem) {
                nearArr.removeAll()
                break
            }
            personItem.yIndex = index < topIndex + 1 ? topIndex + 1 : index
        case .down:
            let index = personItem.yIndex + 1
            let item = DrawItem(xIndex: personItem.xIndex, yIndex: index)
            var nearItem = item
            while boxArr.isContains(nearItem) {
                nearArr.append(nearItem)
                nearItem = DrawItem(xIndex: nearItem.xIndex, yIndex: nearItem.yIndex + 1)
            }
            if nearArr.last?.yIndex ?? topIndex >= bottomIndex - 1 || obstaclesArr.isContains(nearItem) {
                nearArr.removeAll()
                break
            }
            personItem.yIndex = index > bottomIndex - 1 ? bottomIndex - 1 : index
        default:
            break
        }
        updatePerson(with: direction, nearArr: nearArr)
        updateBoxStatus()
        self.setNeedsDisplay()
    }
    
    private func updatePerson(with direction: OperationView.Direction, nearArr: [DrawItem]) {
        if nearArr.isEmpty {
            return
        }
        switch direction {
        case .left:
            for item in boxArr where (nearArr.isContains(item)) {
                item.xIndex -= 1
            }
        case .right:
            for item in boxArr where (nearArr.isContains(item)) {
                item.xIndex += 1
            }
        case .up:
            for item in boxArr where (nearArr.isContains(item)) {
                item.yIndex -= 1
            }
        case .down:
            for item in boxArr where (nearArr.isContains(item)) {
                item.yIndex += 1
            }
        default:
            break
        }
    }
    
    private func updateBoxStatus() {
        self.fullBoxArr.removeAll()
        emptyBoxArr.forEach { [weak self] item in
            guard let self = self else { return }
            if self.boxArr.isContains(item) {
                self.fullBoxArr.append(item)
            }
        }
    }
}

class GameView: UIView {
    private var coloum: NSInteger = 0
    private var row: NSInteger = 0
    private var centerXIndex: NSInteger { Int(Double(coloum) * 0.5) }
    private var centerYIndex: NSInteger { Int(Double(row) * 0.5) }
    private var leftIndex = 1
    private var rightIndex: NSInteger { row - 1 }
    private var topIndex = 1
    private var bottomIndex: NSInteger { coloum - 1 }
    
    private let lineColor = UIColor.white
    private let emptyBoxColor = UIColor.yellow
    private let boxColor = UIColor.red
    private let fullBoxColor = UIColor.purple
    private let personColor = UIColor.blue

    private var lineArr: [DrawItem] = []
    private var emptyBoxArr: [DrawItem] = []
    private var boxArr: [DrawItem] = []
    private var fullBoxArr: [DrawItem] = []
    private var obstaclesArr: [DrawItem] = []
    
    private var personItem: DrawItem?
    private let itemWidth: CGFloat
    private let boxCount: Int
    
    init(itemWidth: CGFloat = 24, boxCount: Int = 5) {
        self.itemWidth = itemWidth
        self.boxCount = boxCount
        super.init(frame: CGRect.zero)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        coloum = Int(rect.height / itemWidth)
        row = Int(rect.width / itemWidth)
        if personItem == nil {
            personItem = DrawItem(xIndex: centerXIndex, yIndex: centerYIndex)
        }

        drawLine()
        drawFullBox()
        drawEmptyBox()
        drawBox()
        drawPerson()
        drawObstacles()
    }
    
    private func drawObstacles() {
        // 两个障碍物
        if !obstaclesArr.isEmpty {
            obstaclesArr.forEach { [weak self] item in
                self?.drawItem(item: item, mode: .obstacles)
            }
            return
        }
        for _ in 0...1 {
            let drawItem = DrawItem(
                xIndex: Int(arc4random()) % (bottomIndex - topIndex - 2) + topIndex + 1,
                yIndex: Int(arc4random()) % (rightIndex - leftIndex - 2) + leftIndex + 1)
            while boxArr.isContains(drawItem) || emptyBoxArr.isContains(drawItem) || personItem ?? DrawItem() == drawItem || obstaclesArr.isContains(drawItem) {
                drawItem.xIndex = Int(arc4random()) % (bottomIndex - topIndex - 2) + topIndex + 1
                drawItem.yIndex = Int(arc4random()) % (rightIndex - leftIndex - 2) + leftIndex + 1
            }
            obstaclesArr.append(drawItem)
            self.drawItem(item: drawItem, mode: .obstacles)
        }
        
    }
}

// MARK: - draw
extension GameView {
    private func drawFullBox() {
        for item in fullBoxArr {
            self.drawItem(item: item, mode: .full)
        }
    }
    
    private func drawEmptyBox() {
        if emptyBoxArr.count >= boxCount {
            for item in emptyBoxArr {
                if !self.fullBoxArr.isContains(item) {
                    self.drawItem(item: item, mode: .empty)
                }
            }
            return
        }
        var index = 0
        while index < boxCount {
            let yIndex = Int(arc4random()) % (bottomIndex - topIndex - 2) + topIndex + 1
            let xIndex = Int(arc4random()) % (rightIndex - leftIndex - 2) + leftIndex + 1
            let item = DrawItem(xIndex: xIndex, yIndex: yIndex)
            if !emptyBoxArr.isContains(item) {
                emptyBoxArr.append(item)
                index += 1
            }
        }
        emptyBoxArr.forEach { [weak self] item in
            self?.drawItem(item: item, mode: .empty)
        }
    }
    
    private func drawBox() {
        if boxArr.count == boxCount {
            for item in boxArr {
                if !self.fullBoxArr.isContains(item) {
                    self.drawItem(item: item, mode: .normal)
                }
            }
            return
        }
        var index = 0
        while index < boxCount {
            let yIndex = Int(arc4random()) % (bottomIndex - topIndex - 4) + topIndex + 2
            let xIndex = Int(arc4random()) % (rightIndex - leftIndex - 4) + leftIndex + 2
            let item = DrawItem(xIndex: xIndex, yIndex: yIndex)
            if !boxArr.isContains(item) && !emptyBoxArr.isContains(item) {
                boxArr.append(item)
                index += 1
            }
        }
        boxArr.forEach { [weak self] item in
            self?.drawItem(item: item, mode: .normal)
        }
    }
    
    private func drawLine() {
        guard lineArr.isEmpty else {
            lineArr.forEach { [weak self] item in
                self?.drawItem(item: item, mode: .line)
            }
            return
        }

        for i in leftIndex...rightIndex {
            let item1 = DrawItem(xIndex: i, yIndex: topIndex)
            let item2 = DrawItem(xIndex: i, yIndex: bottomIndex)
            lineArr += [item1, item2]
        }
        for j in topIndex...bottomIndex {
            let item1 = DrawItem(xIndex: leftIndex, yIndex: j)
            let item2 = DrawItem(xIndex: rightIndex, yIndex: j)
            lineArr += [item1, item2]
        }
        
        lineArr.forEach { [weak self] item in
            self?.drawItem(item: item, mode: .line)
        }
    }

    private func drawPerson() {
        guard let personItem = personItem else { return }
        while boxArr.isContains(personItem) {
            personItem.xIndex = Int(arc4random()) % (bottomIndex - topIndex - 2) + topIndex + 1
            personItem.yIndex = Int(arc4random()) % (rightIndex - leftIndex - 2) + leftIndex + 1
        }
        drawItem(item: personItem, mode: .person)
    }

    func drawItem(item: DrawItem, mode: Mode) {
        let rect = CGRect(x: CGFloat(item.xIndex) * itemWidth, y: CGFloat(item.yIndex) * itemWidth, width: itemWidth, height: itemWidth)
        if mode != .normal {
            mode.image()?.draw(in: rect)
            return
        }
        let path = UIBezierPath(rect: rect)
        UIColor.red.set()
        path.fill()
    }
}
