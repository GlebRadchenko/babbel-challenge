//
//  GameSceneViewController.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import UIKit

protocol GameSceneViewInput: class {
    func embedd(viewControllers: [UIViewController])
    
    func setStatusText(_ text: String)
    func setCentralText(_ text: String)
    
    func emitTextRandomly(_ text: String, duration: TimeInterval)
}

protocol GameSceneViewOutput {
    func viewDidLoad()
    func handleClose()
}

class GameSceneViewController: UIViewController, View {
    typealias Presenter = GameSceneViewOutput
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var centerContentLabel: UILabel!
    
    lazy var emittingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.defaultColor.cgColor
        
        self.view.addSubview(view)
        return view
    }()
    
    lazy var emittingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .defaultColor
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        emittingView.addSubview(label)
        return label
    }()
    
    var output: GameSceneViewOutput!
    
    deinit { debugPrint("\(type(of: self)) deinited") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerContentLabel.alpha = 0
        output.viewDidLoad()
    }
    
    @IBAction func closeButtonTouched(_ sender: UIButton) {
        output?.handleClose()
    }
}

extension GameSceneViewController: GameSceneViewInput {
    func embedd(viewControllers: [UIViewController]) {
        clearChildren()
        
        viewControllers.forEach { (vc) in
            vc.willMove(toParentViewController: self)
            addChildViewController(vc)
            contentStackView.addArrangedSubview(vc.view)
            vc.didMove(toParentViewController: self)
        }
    }
    
    fileprivate func clearChildren() {
        childViewControllers.forEach { $0.willMove(toParentViewController: nil) }
        contentStackView.arrangedSubviews.forEach { (view) in
            contentStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        childViewControllers.forEach { $0.didMove(toParentViewController: nil) }
    }
    
    func setStatusText(_ text: String) {
        statusLabel.text = text
    }
    
    func setCentralText(_ text: String) {
        centerContentLabel.alpha = 0
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let wSelf = self else { return }
            wSelf.centerContentLabel.alpha = 1
            wSelf.centerContentLabel.text = text
        }
    }
    
    func emitTextRandomly(_ text: String, duration: TimeInterval) {
        configureEmittingView(with: text)
        view.randomlyLaunch(view: emittingView, duration: duration)
    }
    
    fileprivate func configureEmittingView(with text: String) {
        emittingView.alpha = 0
        emittingLabel.text = text
        emittingLabel.sizeToFit()
        emittingView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: emittingLabel.bounds.width + 24,
                                    height: emittingLabel.bounds.height + 12)
        
        emittingLabel.center = emittingView.center
    }
}
