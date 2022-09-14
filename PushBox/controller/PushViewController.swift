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
    private let gameView = GameView(itemWidth: 28)
    var obstaclesCount: Int = 5 {
        didSet {
            self.gameView.obstaclesCount = obstaclesCount
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        installUI()
        bindViewModel()
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
    
    private func bindViewModel() {
        gameView.didSucceed = { [weak self] in
            guard let self = self else { return }
            let alertVC = UIAlertController(title: "Congratulation!", message: "You have passed the level, please choose to restart or exit", preferredStyle: .alert)
            let restart = UIAlertAction(title: "restart", style: .default) { _ in
                self.gameView.resetUI()
            }
            let exit = UIAlertAction(title: "exit", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alertVC.addAction(exit)
            alertVC.addAction(restart)
            self.present(alertVC, animated: true, completion: nil)
        }
        
    }
}
