//
//  GameEntryRouter.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

protocol GameEntryRouterInput: class {
    func displayGameScene(with settings: GameSettings)
}

final class GameEntryRouter: Router, GameEntryRouterInput {
    typealias V = GameEntryViewController
    typealias I = GameEntryInteractor
    typealias P = GameEntryPresenter
    
    var module: Module<GameEntryRouter>?
    
    required init() {
        
    }
    
    func displayGameScene(with settings: GameSettings) {
        do {
            let presentingModule = try GameSceneRouter.module(with: settings)
            guard let vc = presentingModule.view else { return }
            
            module?.view?.present(vc, animated: true, completion: nil)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
