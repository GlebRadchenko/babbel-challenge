//
//  BuzzerGameSession.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

class BuzzerGameSession {
    fileprivate let queue = DispatchQueue(label: "buzzer-game-session-queue")
    
    fileprivate(set) var winScoreValue: Int
    fileprivate(set) var clients: [BuzzerGameClient] = []
    
    fileprivate var runningLock = NSLock()
    fileprivate var _isRunning = false
    fileprivate(set) var isRunning: Bool {
        get {
            runningLock.lock(); defer { runningLock.unlock() }
            let value = _isRunning
            return value
        }
        
        set {
            runningLock.lock()
            _isRunning = newValue
            runningLock.unlock()
        }
    }
    
    fileprivate var currentRound = 0 {
        didSet {
            onNextRound?(currentRound)
        }
    }
    
    fileprivate var currentWord: WordsPair? {
        didSet {
            guard let word = currentWord else { return }
            onNextWord?(word)
        }
    }
    
    fileprivate var currentEmitingWord: WordsPair? {
        didSet {
            guard let word = currentEmitingWord else { return }
            onPossibleWord?(word)
        }
    }
    
    fileprivate var generator = ElementGenerator<WordsPair>()
    fileprivate var timer: Timer?
    
    var wordEmitTime: TimeInterval = 5
    var batchSize = 5
    
    var onNextRound: ((Int) -> Void)?
    var onNextWord: ((WordsPair) -> Void)?
    var onPossibleWord: ((WordsPair) -> Void)?
    var onGameFinished: (() -> Void)?
    
    init(settings: GameSettings) {
        winScoreValue = settings.playUntilScore
        clients = (1...settings.playerCount).map { _ in BuzzerGameClient(session: self) }
    }
    
    func configure(with words: [WordsPair]) {
        queue.sync {
            generator = ElementGenerator<WordsPair>(elements: words, batchSize: batchSize)
        }
    }
    
    func start() {
        queue.sync { launchNextRound() }
    }
    
    func processBuzz(from client: BuzzerGameClient) -> AnswerResult {
        guard isRunning else { return .none }
        
        isRunning = false
        guard let word = currentWord, let submitedWord = currentEmitingWord else {
            return .none
        }
        
        defer {
            if client.correctCount == winScoreValue {
                handleGameFinished()
            } else {
                queue.asyncAfter(deadline: .now() + 1) { [weak self] in
                    guard let wSelf = self else { return }
                    wSelf.launchNextRound()
                }
            }
        }
        
        if word == submitedWord {
            client.correctCount += 1
            return .correct
        } else {
            client.wrongCount += 1
            return .wrong
        }
    }
    
    fileprivate func launchNextRound() {
        guard !isRunning else { return }
        
        isRunning = true
        currentRound += 1
        
        var newWord = generator.randomElement()
        while newWord == currentWord {
            newWord = generator.randomElement()
        }
        
        currentWord = newWord
        generator.prepareBatch(base: newWord)
        
        startEmittingPossibleWords()
    }
    
    fileprivate func handleGameFinished() {
        clients.forEach { (client) in
            client.isWinner = winScoreValue == client.correctCount
        }
        
        onGameFinished?()
        timer?.invalidate()
    }
    
    fileprivate func startEmittingPossibleWords() {
        let time = wordEmitTime
        
        timer?.invalidate()
        DispatchQueue.main.async { [weak self] in
            guard let wSelf = self else { return }
            wSelf.timer = Timer.scheduledTimer(withTimeInterval: time, repeats: true) { (_) in
                guard let currentWord = wSelf.currentWord else { return }
                
                wSelf.currentEmitingWord = wSelf.generator.randomDequeue(base: currentWord)
            }
            
            wSelf.timer?.fire()
        }
    }
}
