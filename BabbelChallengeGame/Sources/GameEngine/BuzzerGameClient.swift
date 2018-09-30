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
        didSet { broadcast(event: .winnerUpdated(isWinner: isWinner)) }
    }
    
    var wrongCount = 0 {
        didSet { broadcast(event: .statisticUpdated) }
    }
    
    var correctCount = 0 {
        didSet { broadcast(event: .statisticUpdated) }
    }
    
    var statisticString: String {
        return "W: \(wrongCount), C: \(correctCount)"
    }
    
    var onEvent: ((Event) -> Void)?
    var notifyQueue: DispatchQueue
    
    init(session: BuzzerGameSession, notifyQueue: DispatchQueue = .main) {
        self.session = session
        self.notifyQueue = notifyQueue
    }
    
    func buzz() -> AnswerResult {
        return session?.processBuzz(from: self) ?? .none
    }
    
    func broadcast(event: Event) {
        notifyQueue.async { [weak self] in
            guard let wSelf = self else { return }
            wSelf.onEvent?(event)
        }
    }
}

extension BuzzerGameClient {
    enum Event {
        case statisticUpdated
        case winnerUpdated(isWinner: Bool)
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
