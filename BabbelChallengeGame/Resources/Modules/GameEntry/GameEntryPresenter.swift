//
//  GameEntryPresenter.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

class GameEntryPresenter: Presenter {
    typealias View = GameEntryViewInput
    typealias Interactor = GameEntryInteractorInput
    typealias Router = GameEntryRouterInput
    
    weak var view: GameEntryViewInput!
    var interactor: GameEntryInteractorInput!
    var router: GameEntryRouterInput!
    
    var gameSettings: GameSettings
    
    required init() {
        self.gameSettings = GameSettings()
    }
}

extension GameEntryPresenter: GameEntryViewOutput {
    func viewDidLoad() {
        view.update(with: gameSettings)
        view.displayStartButton()
    }
    
    func handlePlayerCountValueChanged(_ newValue: Int) {
        gameSettings.playerCount = newValue
        view.update(with: gameSettings)
    }
    
    func handlePlayUntilValueChanged(_ newValue: Int) {
        gameSettings.playUntilScore = newValue
        view.update(with: gameSettings)
    }
    
    func handleStart() {
        router?.displayGameScene(with: gameSettings)
    }
}

extension GameEntryPresenter: GameEntryInteractorOutput {
    
}
