//
//  GameScenePresenter.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

protocol GameScenePresenterModuleInput {
    
}

class GameScenePresenter: Presenter, Initializable {
    typealias View = GameSceneViewInput
    typealias Interactor = GameSceneInteractorInput
    typealias Router = GameSceneRouterInput
    
    weak var view: GameSceneViewInput!
    var interactor: GameSceneInteractorInput!
    var router: GameSceneRouterInput!
    
    var settings: GameSettings = GameSettings()
    
    deinit { debugPrint("\(type(of: self)) deinited") }
    
    required init() {
        
    }
}

extension GameScenePresenter: GameScenePresenterModuleInput {
    
}

extension GameScenePresenter: GameSceneViewOutput {
    func viewDidLoad() {
        
    }
    
    func handleClose() {
        router?.performClose()
    }
}

extension GameScenePresenter: GameSceneInteractorOutput {
    
}
