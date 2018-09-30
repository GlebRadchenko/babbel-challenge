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
    fileprivate let notifyQueue: DispatchQueue
    
    fileprivate(set) var winScoreValue: Int = 0
    fileprivate(set) var clients: [BuzzerGameClient] = []
    
    fileprivate(set) var isRunning = Synchronized<Bool>(value: false)
    
    var currentRound = 0 {
        didSet { broadcast(event: .roundChanged(currentRound)) }
    }
    
    var currentWord: WordsPair? {
        didSet {
            guard let word = currentWord else { return }
            broadcast(event: .newCurrentWord(word))
        }
    }
    
    var currentEmitingWord: WordsPair? {
        didSet {
            guard let word = currentEmitingWord else { return }
            broadcast(event: .newProposedWord(word))
        }
    }
    
    var onEvent: ((Event) -> Void)?
    var wordEmitTime: TimeInterval = 5
    var batchSize = 5
    
    fileprivate var generator = ElementGenerator<WordsPair>()
    fileprivate var timer: Timer?
    
    init(settings: GameSettings, notifyQueue: DispatchQueue = .main) {
        self.notifyQueue = notifyQueue
        apply(settings: settings)
    }
    
    func apply(settings: GameSettings) {
        self.winScoreValue = settings.playUntilScore
        self.clients = (1...settings.playerCount)
            .map { _ in BuzzerGameClient(session: self) }
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
        guard isRunning.value else { return .none }
        
        isRunning.value = false
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
    
    fileprivate func broadcast(event: Event) {
        notifyQueue.async { [weak self] in
            guard let wSelf = self else { return }
            wSelf.onEvent?(event)
        }
    }
    
    fileprivate func launchNextRound() {
        guard !isRunning.value else { return }
        guard !generator.elements.isEmpty else { return }
        
        isRunning.value = true
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
        
        broadcast(event: .gameFinished)
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

extension BuzzerGameSession {
    enum Event {
        case roundChanged(Int)
        case newCurrentWord(WordsPair)
        case newProposedWord(WordsPair)
        case gameFinished
    }
}
