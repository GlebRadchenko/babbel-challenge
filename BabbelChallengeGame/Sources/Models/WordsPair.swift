//
//  WordsPair.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

struct WordsPair: Codable, Equatable {
    var englishText: String
    var spanishText: String
    
    enum CodingKeys: String, CodingKey {
        case englishText = "text_eng"
        case spanishText = "text_spa"
    }
}
