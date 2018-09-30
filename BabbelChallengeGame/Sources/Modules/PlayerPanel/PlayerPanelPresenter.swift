//
//  PlayerPanelPresenter.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

class PlayerPanelPresenter: Presenter {
    typealias View = PlayerPanelViewInput
    typealias Interactor = PlayerPanelInteractorInput
    typealias Router = PlayerPanelRouterInput
    
    weak var view: PlayerPanelViewInput!
    var interactor: PlayerPanelInteractorInput!
    var router: PlayerPanelRouterInput!
    
    required init() { }
}

extension PlayerPanelPresenter: PlayerPanelViewOutput {
    func viewDidLoad() {
        updateStatistic()
    }
    
    func handleBuzzAction() {
        let result = interactor.submitAnswer()
        
        switch result {
        case .none:
            break
        case.correct:
            view.highlightBuzzButton(with: .defaultGreenColor, duration: 0.6)
        case .wrong:
            view.highlightBuzzButton(with: .defaultRedColor, duration: 0.6)
        }
    }
}

extension PlayerPanelPresenter: PlayerPanelInteractorOutput {
    func handleWinnerStatusChanged(isWinner: Bool) {
        if isWinner {
            view.presentEndTitle("WINNER", backgroundColor: .defaultGreenColor)
        } else {
            view.presentEndTitle("LOSER", backgroundColor: .defaultRedColor)
        }
    }
    
    func handleStatisticUpdate() {
        updateStatistic()
    }
    
    fileprivate func updateStatistic() {
        view?.updateStatistic(text: interactor?.client?.statisticString ?? "")
    }
}
