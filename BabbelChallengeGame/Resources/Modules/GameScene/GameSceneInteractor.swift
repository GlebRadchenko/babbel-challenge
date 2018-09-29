//
//  GameSceneInteractor.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

protocol GameSceneInteractorInput: class {
    
}

protocol GameSceneInteractorOutput: class {
    
}

class GameSceneInteractor: Interactor, GameSceneInteractorInput {
    typealias Presenter = GameSceneInteractorOutput
    weak var output: GameSceneInteractorOutput!
    
    var wordsLoader: WordsLoader
    
    deinit { debugPrint("\(type(of: self)) deinited") }
    
    required init() {
        wordsLoader = BabbelWordsLoader() //BabbelApiService()
    }
}
