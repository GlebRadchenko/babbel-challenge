//
//  PlayerPanelInteractor.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

protocol PlayerPanelInteractorInput {
    var client: BuzzerGameClient? { get set }
    
    func submitAnswer() -> AnswerResult
}

protocol PlayerPanelInteractorOutput {
    func handleWinnerStatusChanged(isWinner: Bool)
    func handleStatisticUpdate()
}

class PlayerPanelInteractor: Interactor {
    typealias Presenter = PlayerPanelInteractorOutput
    
    var output: PlayerPanelInteractorOutput!
    var client: BuzzerGameClient? {
        didSet {
            configureClient()
        }
    }
    
    required init() { }
    
    func configureClient() {
        client?.onUpdateWinner = { [weak self] (isWinner) in
            guard let wSelf = self else { return }
            DispatchQueue.main.async {
                wSelf.output?.handleWinnerStatusChanged(isWinner: isWinner)
            }
        }
        
        client?.onUpdateStats = { [weak self] in
            guard let wSelf = self else { return }
            DispatchQueue.main.async {
                wSelf.output?.handleStatisticUpdate()
            }
        }
    }
}

extension PlayerPanelInteractor: PlayerPanelInteractorInput {
    func submitAnswer() -> AnswerResult {
        guard let client = client else {
            return .none
        }
        
        return client.buzz()
    }
}
