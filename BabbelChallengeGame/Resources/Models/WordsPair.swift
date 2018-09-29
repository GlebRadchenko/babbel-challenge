//
//  WordsPair.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

struct WordsPair: Codable {
    var engText: String
    var spaText: String
    
    enum CodingKeys: String, CodingKey {
        case engText = "text_eng"
        case spaText = "text_spa"
    }
}
