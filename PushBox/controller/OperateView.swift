//
//  OperationView.swift
//  PushBox
//
//  Created by Wuhuijuan on 2022/9/14.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class OperateView: UIView {
    lazy private var buttonArr = [easyButton, middleButton, hardButton, hellButton]
    private var easyButton = UIButton()
    private var middleButton = UIButton()
    private var hardButton = UIButton()
    private var hellButton = UIButton()
    public let modeDidSelectedSubject = PublishSubject<Int>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        installUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        // 画背景
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 16)
        UIColor.lightGray.withAlphaComponent(0.2).setFill()
        path.fill()
    }
    
    private func installUI() {
        buttonArr.forEach { button in
            button.titleLabel?.font = .systemFont(ofSize: 32)
            button.layer.cornerRadius = 16
            button.clipsToBounds = true
            button.backgroundColor = .blue.withAlphaComponent(0.3)
        }
        
        easyButton.setTitle("简单模式", for: .normal)
        easyButton.tag = 10
        easyButton.addTarget(self, action: #selector(buttonDidClicked(_:)), for: .touchUpInside)
        
        middleButton.setTitle("中等模式", for: .normal)
        middleButton.tag = 20
        middleButton.addTarget(self, action: #selector(buttonDidClicked(_:)), for: .touchUpInside)
        
        hardButton.setTitle("困难模式", for: .normal)
        hardButton.tag = 30
        hardButton.addTarget(self, action: #selector(buttonDidClicked(_:)), for: .touchUpInside)
        
        hellButton.setTitle("地狱模式", for: .normal)
        hellButton.tag = 40
        hellButton.addTarget(self, action: #selector(buttonDidClicked(_:)), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: buttonArr)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(24)
            make.leading.equalTo(self).offset(32)
            make.center.equalTo(self)
        }
    }
    
    @objc func buttonDidClicked(_ sender: UIButton) {
        modeDidSelectedSubject.onNext(sender.tag)
    }
}

