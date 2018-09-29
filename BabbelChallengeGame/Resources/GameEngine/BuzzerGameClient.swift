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
    
    var isWinner = false {
        didSet {
            onUpdateWinner?(isWinner)
        }
    }
    
    var wrongCount = 0 {
        didSet {
            onUpdateStats?()
        }
    }
    
    var correctCount = 0 {
        didSet {
            onUpdateStats?()
        }
    }
    
    var statisticString: String {
        return "W: \(wrongCount), C: \(correctCount)"
    }
    
    var onUpdateStats: (() -> Void)?
    var onUpdateWinner: ((Bool) -> Void)?
    
    init(session: BuzzerGameSession) {
        self.session = session
    }
    
    func buzz() -> AnswerResult {
        return session?.processBuzz(from: self) ?? .none
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

enum AnswerResult {
    case none
    case wrong
    case correct
}
