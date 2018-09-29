//
//  GameSceneViewController.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import UIKit

protocol GameSceneViewInput: class {
    func setStatusText(_ text: String)
}

protocol GameSceneViewOutput {
    func viewDidLoad()
    func handleClose()
}

class GameSceneViewController: UIViewController, View {
    typealias Presenter = GameSceneViewOutput
    
    @IBOutlet weak var statusLabel: UILabel!
    
    var output: GameSceneViewOutput!
    
    deinit { debugPrint("\(type(of: self)) deinited") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
    }
    
    @IBAction func closeButtonTouched(_ sender: UIButton) {
        output?.handleClose()
    }
}

extension GameSceneViewController: GameSceneViewInput {
    func setStatusText(_ text: String) {
        statusLabel.text = text
    }
}
