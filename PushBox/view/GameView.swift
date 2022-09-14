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
            let item = DrawItem(xIndex: index, yIndex: personItem.yIndex, color: nil)
            var nearItem = item
            while boxArr.isContains(nearItem) {
                nearArr.append(nearItem)
                nearItem = DrawItem(xIndex: nearItem.xIndex - 1, yIndex: nearItem.yIndex, color: nil)
            }
            if nearArr.last?.xIndex ?? rightIndex <= leftIndex + 1 {
                nearArr.removeAll()
                break
            }
            personItem.xIndex = index < leftIndex + 1 ? leftIndex + 1 : index
        case .right:
            let index = personItem.xIndex + 1
            let item = DrawItem(xIndex: index, yIndex: personItem.yIndex, color: nil)
            var nearItem = item
            while boxArr.isContains(nearItem) {
                nearArr.append(nearItem)
                nearItem = DrawItem(xIndex: nearItem.xIndex + 1, yIndex: nearItem.yIndex, color: nil)
            }
            if nearArr.last?.xIndex ?? leftIndex >= rightIndex - 1 {
                nearArr.removeAll()
                break
            }
            personItem.xIndex = index > rightIndex - 1 ? rightIndex - 1 : index
        case .up:
            let index = personItem.yIndex - 1
            let item = DrawItem(xIndex: personItem.xIndex, yIndex: index, color: nil)
            var nearItem = item
            while boxArr.isContains(nearItem) {
                nearArr.append(nearItem)
                nearItem = DrawItem(xIndex: nearItem.xIndex, yIndex: nearItem.yIndex - 1, color: nil)
            }
            if nearArr.last?.yIndex ?? bottomIndex <= topIndex + 1 {
                nearArr.removeAll()
                break
            }
            personItem.yIndex = index < topIndex + 1 ? topIndex + 1 : index
        case .down:
            let index = personItem.yIndex + 1
            let item = DrawItem(xIndex: personItem.xIndex, yIndex: index, color: nil)
            var nearItem = item
            while boxArr.isContains(nearItem) {
                nearArr.append(nearItem)
                nearItem = DrawItem(xIndex: nearItem.xIndex, yIndex: nearItem.yIndex + 1, color: nil)
            }
            if nearArr.last?.yIndex ?? topIndex >= bottomIndex - 1 {
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
                item.color = self.fullBoxColor
                self.fullBoxArr.append(item)
            } else {
                item.color = emptyBoxColor
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
    
    private var personItem: DrawItem?
    private let itemWidth: CGFloat
    private let boxCount: Int
    
    init(itemWidth: CGFloat = 24, boxCount: Int = 5) {
        self.itemWidth = itemWidth
        self.boxCount = boxCount
        super.init(frame: CGRect.zero)
        backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        coloum = Int(rect.height / itemWidth)
        row = Int(rect.width / itemWidth)
        if personItem == nil {
            personItem = DrawItem(xIndex: centerXIndex, yIndex: centerYIndex, color: personColor)
        }

        drawLine()
        drawFullBox()
        drawEmptyBox()
        drawBox()
        drawPerson()
    }
}

// MARK: - draw box
extension GameView {
    private func drawFullBox() {
        for item in fullBoxArr {
            self.drawItem(item: item)
        }
    }
    
    private func drawEmptyBox() {
        if emptyBoxArr.count >= boxCount {
            for item in emptyBoxArr {
                if !self.fullBoxArr.isContains(item) {
                    self.drawItem(item: item)
                }
            }
            return
        }
        var index = 0
        while index < boxCount {
            let yIndex = Int(arc4random()) % (bottomIndex - topIndex - 2) + topIndex + 1
            let xIndex = Int(arc4random()) % (rightIndex - leftIndex - 2) + leftIndex + 1
            let item = DrawItem(xIndex: xIndex, yIndex: yIndex, color: emptyBoxColor)
            if !emptyBoxArr.isContains(item) {
                emptyBoxArr.append(item)
                index += 1
            }
        }
        emptyBoxArr.forEach { [weak self] item in
            self?.drawItem(item: item)
        }
    }
    
    private func drawBox() {
        if boxArr.count == boxCount {
            for item in boxArr {
                if !self.fullBoxArr.isContains(item) {
                    self.drawItem(item: item)
                }
            }
            return
        }
        var index = 0
        while index < boxCount {
            let yIndex = Int(arc4random()) % (bottomIndex - topIndex - 4) + topIndex + 2
            let xIndex = Int(arc4random()) % (rightIndex - leftIndex - 4) + leftIndex + 2
            let item = DrawItem(xIndex: xIndex, yIndex: yIndex, color: boxColor)
            if !boxArr.isContains(item) && !emptyBoxArr.isContains(item) {
                boxArr.append(item)
                index += 1
            }
        }
        boxArr.forEach { [weak self] item in
            self?.drawItem(item: item)
        }
    }
    
    private func drawLine() {
        guard lineArr.isEmpty else {
            lineArr.forEach { [weak self] item in
                self?.drawItem(item: item)
            }
            return
        }

        for i in leftIndex...rightIndex {
            let item1 = DrawItem(xIndex: i, yIndex: topIndex, color: lineColor)
            let item2 = DrawItem(xIndex: i, yIndex: bottomIndex, color: lineColor)
            lineArr += [item1, item2]
        }
        for j in topIndex...bottomIndex {
            let item1 = DrawItem(xIndex: leftIndex, yIndex: j, color: lineColor)
            let item2 = DrawItem(xIndex: rightIndex, yIndex: j, color: lineColor)
            lineArr += [item1, item2]
        }
        
        lineArr.forEach { [weak self] item in
            self?.drawItem(item: item)
        }
    }

    private func drawPerson() {
        guard let personItem = personItem else { return }
        let rect = CGRect(x: CGFloat(personItem.xIndex) * itemWidth, y: CGFloat(personItem.yIndex) * itemWidth, width: itemWidth, height: itemWidth)
        
        let headWidth = itemWidth * 0.2
        let headRect = CGRect(x: rect.midX - headWidth, y: rect.minY + 2, width: headWidth * 2, height: headWidth * 2)
        let headPath = UIBezierPath(roundedRect: headRect, cornerRadius: headWidth)
        headPath.lineWidth = 3
        headPath.move(to: CGPoint(x: rect.minX, y: rect.midY + 2))
        headPath.addLine(to: CGPoint(x: rect.minX + itemWidth, y: rect.midY + 2))
        headPath.move(to: CGPoint(x: headRect.midX, y: headRect.maxY))
        headPath.addLine(to: CGPoint(x: rect.midX, y: rect.midY + 2))
        headPath.addLine(to: CGPoint(x: rect.minX + 4, y: rect.maxY))
        headPath.move(to: CGPoint(x: headRect.midX, y: headRect.maxY))
        headPath.addLine(to: CGPoint(x: rect.maxX - 4, y: rect.maxY))

        UIColor.blue.set()
        headPath.stroke()
    }

    func drawItem(item: DrawItem) {
        let rect = CGRect(x: CGFloat(item.xIndex) * itemWidth, y: CGFloat(item.yIndex) * itemWidth, width: itemWidth, height: itemWidth)
        let path = UIBezierPath(rect: rect)
        item.color?.set()
        path.fill()
    }
}
