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
    fileprivate(set) var words: [WordsPair] = []
    
    fileprivate var engKeyedWords: [String: WordsPair] = [:]
    fileprivate var spaKeyedWords: [String: WordsPair] = [:]
    
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
            
            self.words = words
            engKeyedWords = words.keyed(by: { $0.engText })
            spaKeyedWords = words.keyed(by: { $0.spaText })
        }
    }
    
    func start() {
        launchNextRound()
    }
    
    fileprivate func launchNextRound() {
        guard !isRunning else { return }
        
        queue.sync {
            isRunning = true
            currentRound += 1
            
            let newWord = generator.randomElement()
            currentWord = newWord
            generator.prepareBatch(base: newWord)
            
            startEmittingPossibleWords()
        }
    }
    
    fileprivate func handleRoundEnded() {
        queue.sync {
            isRunning = false
        }
    }
    
    fileprivate func startEmittingPossibleWords() {
        let time = wordEmitTime
        
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
