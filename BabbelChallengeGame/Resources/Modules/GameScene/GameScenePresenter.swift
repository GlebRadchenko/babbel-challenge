//
//  GameScenePresenter.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

class GameScenePresenter: Presenter, Initializable {
    typealias View = GameSceneViewInput
    typealias Interactor = GameSceneInteractorInput
    typealias Router = GameSceneRouterInput
    
    weak var view: GameSceneViewInput!
    var interactor: GameSceneInteractorInput!
    var router: GameSceneRouterInput!
    
    var settings: GameSettings = GameSettings()
    
    deinit { debugPrint("\(type(of: self)) deinited") }
    
    required init() { }
    
    fileprivate func loadClientModules() {
        let clients = interactor.gameClients()
        let panels = clients.compactMap { router?.playerPanel(for: $0) }
        view.embedd(viewControllers: panels)
    }
    
    fileprivate func launchGameWithCountDown() {
        countDown(from: 3,
                  step: 1,
                  onEach: { [weak self] (value) in self?.view.setStatusText("\(value)") },
                  completion: { [weak self] in self?.launchGame() })
    }
    
    fileprivate func launchGame() {
        interactor.startGame()
    }
    
    fileprivate func countDown(
        from value: Int,
        step: TimeInterval,
        onEach: ((Int) -> Void)?,
        completion: (() -> Void)?) {
        
        guard value > 0 else {
            completion?()
            return
        }
        
        onEach?(value)
        DispatchQueue.main.asyncAfter(deadline: .now() + step) { [weak self] in
            guard let wSelf = self else { return }
            wSelf.countDown(from: value - 1, step: step, onEach: onEach, completion: completion)
        }
    }
}

extension GameScenePresenter: GameSceneViewOutput {
    func viewDidLoad() {
        interactor.prepareGame(for: settings)
        loadClientModules()
    }
    
    func handleClose() {
        router?.performClose()
    }
}

extension GameScenePresenter: GameSceneInteractorOutput {
    var wordEmittingTime: TimeInterval {
        return 3
    }
    
    func handleGameStartPreparing() {
        DispatchQueue.main.async { [weak self] in
            guard let wSelf = self else { return }
            wSelf.view.setStatusText("Loading game...")
        }
    }
    
    func handleGameStopPreparing() {
        DispatchQueue.main.async { [weak self] in
            guard let wSelf = self else { return }
            wSelf.view.setStatusText("Game loaded!")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                wSelf.launchGameWithCountDown()
            }
        }
    }
    
    func handle(error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    func handleNextRound(round: Int) {
        view.setStatusText("Round: \(round)")
    }
    
    func handleNextWord(_ word: WordsPair) {
        view.setCentralText(word.engText)
    }
    
    func handleNextPossibleWord(_ word: WordsPair) {
        view.emitTextRandomly(word.spaText, duration: .random(in: 2...wordEmittingTime))
    }
    
    func handleGameFinished() {
        view.setStatusText("Game finished!")
        view.setCentralText("")
    }
}
