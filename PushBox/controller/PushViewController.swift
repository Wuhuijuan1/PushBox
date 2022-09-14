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
    private let gameView = GameView(itemWidth: 36)
    override func viewDidLoad() {
        super.viewDidLoad()
        installUI()
    }
    
    private func installUI() {
        let imageView = UIImageView(image: UIImage(named: "bac"))
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let operationView = OperationView(directions: [.right,.down,.left,.up]) { direction, view in
            self.gameView.updateUI(with: direction)
        }
        view.addSubview(operationView)
        operationView.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-32)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.height.width.equalTo(150)
        }

        view.addSubview(gameView)
        gameView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(operationView.snp.top).offset(-40)
        }
    }
}
