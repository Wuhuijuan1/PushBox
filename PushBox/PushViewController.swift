//
//  PushViewController.swift
//  PushBox
//
//  Created by Wuhuijuan on 2022/9/8.
//

import Foundation
import UIKit
import SnapKit

class PushViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        installUI()
    }
    
    private func installUI() {
        let operationView = OperationView(directions: [.right,.down,.left,.up]) { direction, view in
            NSLog("%d", direction.rawValue)
        }
        view.addSubview(operationView)
        operationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(200)
        }
    }
}
