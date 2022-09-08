//
//  PushViewController.swift
//  Push Box
//
//  Created by Wuhuijuan on 2022/9/8.
//

import Foundation
import UIKit

class PushViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        installUI()
    }
    
    private func installUI() {
        let operationView = OperationView()
        view.addSubview(operationView)

    }
}
