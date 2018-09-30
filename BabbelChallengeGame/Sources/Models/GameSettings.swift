//
//  GameSettings.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

struct GameSettings {
    var playerCount: Int = 2
    var playUntilScore: Int = 5
    
    static var `default`: GameSettings {
        return GameSettings()
    }
}
