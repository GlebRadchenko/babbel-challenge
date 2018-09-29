//
//  GameSceneRouter.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

protocol GameSceneRouterInput: class {
    func performClose()
}

final class GameSceneRouter: Router, GameSceneRouterInput {
    typealias V = GameSceneViewController
    typealias I = GameSceneInteractor
    typealias P = GameScenePresenter
    
    var module: Module<GameSceneRouter>?
    
    deinit { debugPrint("\(type(of: self)) deinited") }
    
    required init() { }
    
    static func module(with settings: GameSettings) throws -> Module<GameSceneRouter> {
        let m = try module()
        m.presenter?.settings = settings
        return m
    }
    
    func performClose() {
        module?.view?.dismiss(animated: true, completion: nil)
    }
}
