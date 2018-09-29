//
//  PlayerPanelViewController.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import UIKit

protocol PlayerPanelViewInput: class {
    func updateStatistic(text: String)
    func highlightBuzzButton(with color: UIColor, duration: TimeInterval)
    func presentEndTitle(_ title: String, backgroundColor: UIColor)
}

protocol PlayerPanelViewOutput: class {
    func viewDidLoad()
    func handleBuzzAction()
}

class PlayerPanelViewController: UIViewController, View {
    typealias Presenter = PlayerPanelViewOutput
    
    @IBOutlet weak var statisticLabel: UILabel!
    @IBOutlet weak var buzzButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    var output: PlayerPanelViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    @IBAction func buzzButtonTouched(_ sender: UIButton) {
        output?.handleBuzzAction()
    }
}

extension PlayerPanelViewController: PlayerPanelViewInput {
    func highlightBuzzButton(with color: UIColor, duration: TimeInterval) {
        buzzButton.backgroundColor = color
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            guard let wSelf = self else { return }
            wSelf.buzzButton.backgroundColor = .defaultColor
        }
    }
    
    func updateStatistic(text: String) {
        statisticLabel.text = text
    }
    
    func presentEndTitle(_ title: String, backgroundColor: UIColor) {
        statusLabel.text = title
        statusLabel.isHidden = false
        view.backgroundColor = backgroundColor
    }
}
