//
//  GameEntryViewController.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import UIKit

protocol GameEntryViewInput: class {
    func displayStartButton()
    func update(with settings: GameSettings)
}

protocol GameEntryViewOutput: class {
    func viewDidLoad()
    
    func handlePlayerCountValueChanged(_ newValue: Int)
    func handlePlayUntilValueChanged(_ newValue: Int)
    
    func handleStart()
}

class GameEntryViewController: UIViewController, View {
    typealias Presenter = GameEntryViewOutput
    
    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet weak var playerCountLabel: UILabel!
    @IBOutlet weak var playerCountStepper: UIStepper!
    
    @IBOutlet weak var playUntilLabel: UILabel!
    @IBOutlet weak var playUntilStepper: UIStepper!
    
    var startButtonLayout = LayoutSet()
    weak var startButton: UIButton?
    
    var output: GameEntryViewOutput!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStartButton()
        configureStartButton()
        
        output?.viewDidLoad()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        
        if sender == playUntilStepper {
            output?.handlePlayUntilValueChanged(value)
        } else {
            output?.handlePlayerCountValueChanged(value)
        }
    }
    
    @objc func startButtonTouched() {
        output?.handleStart()
    }
}

extension GameEntryViewController: GameEntryViewInput {
    func displayStartButton() {
        view.layoutIfNeeded()
        animateStartButton()
    }
    
    func update(with settings: GameSettings) {
        playerCountStepper.value = Double(settings.playerCount)
        playUntilStepper.value = Double(settings.playUntilScore)
        
        playerCountLabel.text = "Player count: \(settings.playerCount)"
        playUntilLabel.text = "Play until score: \(settings.playUntilScore)"
    }
    
    fileprivate func addStartButton() {
        guard startButton == nil else { return }
        
        let button = UIButton(type: .system)
        view.addSubview(button)
        
        self.startButton = button
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        startButtonLayout.centerX = button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        startButtonLayout.top = button.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 80)
        startButtonLayout.width = button.widthAnchor.constraint(equalToConstant: 120)
        startButtonLayout.height = button.heightAnchor.constraint(equalToConstant: 30)
        
        startButtonLayout.activate()
    }
    
    fileprivate func configureStartButton() {
        guard let button = startButton else { return }
        
        let title = NSAttributedString(string: "START",
                                       attributes: [.font: UIFont(name: "HelveticaNeue", size: 15)!,
                                                    .foregroundColor: UIColor.white])
        
        button.alpha = 0
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = UIColor(red: 47, green: 50, blue: 80)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        
        button.addTarget(self, action: #selector(startButtonTouched), for: .touchUpInside)
    }
    
    fileprivate func animateStartButton() {
        guard let button = startButton else { return }
        
        startButtonLayout.top?.constant = 20
        
        let animations = { [weak self] in
            guard let wSelf = self else { return }
            
            button.alpha = 1.0
            wSelf.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: animations,
                       completion: nil)
    }
}
