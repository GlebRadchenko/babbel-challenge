//
//  GameSceneRouter.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

protocol GameSceneRouterInput: class {
    
}

final class GameSceneRouter: Router, GameSceneRouterInput {
    typealias V = GameSceneViewController
    typealias I = GameSceneInteractor
    typealias P = GameScenePresenter
    
    var module: Module<GameSceneRouter>?
    
    deinit { debugPrint("\(type(of: self)) deinited") }
    
    required init() { }
}
