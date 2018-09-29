//
//  BuzzerGameClient.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

class BuzzerGameClient {
    let identifier = UUID().uuidString
    
    weak var session: BuzzerGameSession?
    
    init(session: BuzzerGameSession) {
        self.session = session
    }
}

extension BuzzerGameClient: Hashable {
    var hashValue: Int {
        return identifier.hashValue
    }
    
    static func == (lhs: BuzzerGameClient, rhs: BuzzerGameClient) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
