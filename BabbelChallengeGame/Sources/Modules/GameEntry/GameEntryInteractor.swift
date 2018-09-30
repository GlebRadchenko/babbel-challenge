//
//  GameEntryInteractor.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

protocol GameEntryInteractorInput: class {
    
}

protocol GameEntryInteractorOutput: class {
    
}

class GameEntryInteractor: Interactor, GameEntryInteractorInput {
    typealias Presenter = GameEntryInteractorOutput
    
    var output: GameEntryInteractorOutput!
    
    required init() {
        
    }
}
