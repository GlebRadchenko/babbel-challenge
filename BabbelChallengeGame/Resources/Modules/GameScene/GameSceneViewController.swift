//
//  GameSceneViewController.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import UIKit

protocol GameSceneViewInput: class {
    
}

protocol GameSceneViewOutput {
    func viewDidLoad()
    func handleClose()
}

class GameSceneViewController: UIViewController, View, GameSceneViewInput {
    typealias Presenter = GameSceneViewOutput
    
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
