//
//  GameSceneInteractor.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

protocol GameSceneInteractorInput: class {
    func prepareGame(for settings: GameSettings)
    func gameClients() -> [BuzzerGameClient]
    func startGame()
}

protocol GameSceneInteractorOutput: class {
    func handleGameStartPreparing()
    func handleGameStopPreparing()
    func handle(error: Error)
    
    func handleNextRound(round: Int)
    func handleNextWord(_ word: WordsPair)
    func handleNextPossibleWord(_ word: WordsPair)
    func handleGameFinished()
}

class GameSceneInteractor: Interactor {
    typealias Presenter = GameSceneInteractorOutput
    weak var output: GameSceneInteractorOutput!
    
    var wordsLoader: WordsLoader
    var gameSession: BuzzerGameSession?
    
    deinit { debugPrint("\(type(of: self)) deinited") }
    
    required init() {
        wordsLoader = BabbelApiService()//BabbelWordsLoader()
    }
    
    fileprivate func configureGameSession() {
        gameSession?.batchSize = 5
        gameSession?.onNextRound = { [weak self] (round) in
            guard let wSelf = self else { return }
            DispatchQueue.main.async {
                wSelf.output?.handleNextRound(round: round)
            }
        }
        
        gameSession?.onNextWord = { [weak self] (word) in
            guard let wSelf = self else { return }
            DispatchQueue.main.async {
                wSelf.output?.handleNextWord(word)
            }
        }
        
        gameSession?.onPossibleWord = { [weak self] (word) in
            guard let wSelf = self else { return }
            DispatchQueue.main.async {
                wSelf.output?.handleNextPossibleWord(word)
            }
        }
        
        gameSession?.onGameFinished = { [weak self] in
            guard let wSelf = self else { return }
            DispatchQueue.main.async {
                wSelf.output?.handleGameFinished()
            }
        }
    }
    
    fileprivate func loadWords() {
        wordsLoader.loadWords { [weak self] (result) in
            guard let wSelf = self else { return }
            
            result.onError { (error) in
                wSelf.output?.handle(error: error)
            }
            
            result.onValue { (words) in
                wSelf.process(words: words)
            }
        }
    }
    
    fileprivate func process(words: [WordsPair]) {
        gameSession?.configure(with: words)
        output?.handleGameStopPreparing()
    }
}

extension GameSceneInteractor: GameSceneInteractorInput {
    func prepareGame(for settings: GameSettings) {
        output?.handleGameStartPreparing()
        gameSession = BuzzerGameSession(settings: settings)
        configureGameSession()
        loadWords()
    }
    
    func gameClients() -> [BuzzerGameClient] {
        return gameSession?.clients ?? []
    }
    
    func startGame() {
        gameSession?.start()
    }
}
