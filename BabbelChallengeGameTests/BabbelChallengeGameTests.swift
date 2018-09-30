//
//  BabbelChallengeGameTests.swift
//  BabbelChallengeGameTests
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import XCTest
@testable import BabbelChallengeGame

class BabbelChallengeGameTests: XCTestCase {
    var session: BuzzerGameSession!
    
    override func setUp() {
        session = BuzzerGameSession(settings: .default)
    }
    
    override func tearDown() {
        session = nil
    }
    
    func testLoadWordsFromDisk() {
        let expectation = XCTestExpectation(description: "Loading from disk")
        
        BabbelWordsLoader().loadWords { (result) in
            result.onValue { (words) in
                XCTAssertFalse(words.isEmpty, "Words is empty")
                expectation.fulfill()
            }
            
            result.onError { (error) in
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testLoadWordsFromServer() {
        let expectation = XCTestExpectation(description: "Loading from disk")
        
        let client = BabbelApiService()
        
        client.loadWords { (result) in
            result.onValue { (words) in
                XCTAssertFalse(words.isEmpty, "Words is empty")
                expectation.fulfill()
            }
            
            result.onError { (error) in
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testStartSession() {
        session.configure(with: [WordsPair(englishText: "Eng", spanishText: "Span")])
        session.start()
        
        XCTAssert(session.currentRound == 1, "Wrong round number")
        XCTAssertNotNil(session.currentWord, "Current word not exist")
    }
    
    func testEmittingWord() {
        session.configure(with: [WordsPair(englishText: "Eng", spanishText: "Span")])
        session.start()
        
        let expectation = XCTestExpectation(description: "Emitting word expectation")
        session.onEvent = { (event) in
            guard case .newProposedWord = event else { return }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testClientsIsEmpty() {
        session.start()
        XCTAssertFalse(session.clients.isEmpty, "Clients is empty")
    }
    
    func testPositiveBuzz() {
        session.configure(with: [WordsPair(englishText: "Eng", spanishText: "Span")])
        session.start()
        
        let client = session.clients[0]
        
        let expectation = XCTestExpectation(description: "Emitting word expectation")
        session.onEvent = { (event) in
            guard case .newProposedWord = event else { return }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        
        let beforeWrongCount = client.wrongCount
        let beforCorrentCount = client.correctCount
        
        XCTAssertEqual(client.buzz(), .correct)
        XCTAssertEqual(client.wrongCount, beforeWrongCount)
        XCTAssertEqual(client.correctCount, beforCorrentCount + 1)
    }
    
    func testNeutralBuzz() {
        session.start()
        
        let client = session.clients[0]
        let result = client.buzz()
        
        XCTAssertEqual(result, .none)
    }
    
    func testNegativeBuzz() {
        session.wordEmitTime = 0.1
        session.configure(with: [WordsPair(englishText: "1", spanishText: "1"),
                                 WordsPair(englishText: "2", spanishText: "2"),
                                 WordsPair(englishText: "3", spanishText: "3"),
                                 WordsPair(englishText: "4", spanishText: "4")])
        session.start()
        
        let currentWord = session.currentWord!
        
        let expectation = XCTestExpectation(description: "Wrong word expectation")
        session.onEvent = { (event) in
            guard case let .newProposedWord(word) = event, word != currentWord else {
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        
        let client = session.clients[0]
        let beforeWrongCount = client.wrongCount
        let beforCorrentCount = client.correctCount
        
        XCTAssertEqual(client.buzz(), .wrong)
        XCTAssertEqual(client.wrongCount, beforeWrongCount + 1)
        XCTAssertEqual(client.correctCount, beforCorrentCount)
    }
    
    func testSimultaneousBuzz() {
        session.configure(with: [WordsPair(englishText: "Eng", spanishText: "Span")])
        session.start()
        
        let expectation = XCTestExpectation(description: "Emitting word expectation")
        session.onEvent = { [weak self] (event) in
            guard let wSelf = self else { return }
            
            guard case .newProposedWord = event else {
                return
            }
            
            let client1 = wSelf.session.clients[0]
            let client2 = wSelf.session.clients[1]
            
            XCTAssertEqual(client1.buzz(), .correct)
            XCTAssertEqual(client2.buzz(), .none)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testWinner() {
        session.apply(settings: GameSettings(playerCount: 1, playUntilScore: 1))
        session.configure(with: [WordsPair(englishText: "Eng", spanishText: "Span")])
        session.start()
        
        let expectation = XCTestExpectation(description: "Emitting word expectation")
        session.onEvent = { [weak self] (event) in
            guard let wSelf = self else { return }
            
            guard case .newProposedWord = event else {
                return
            }
            
            let client1 = wSelf.session.clients[0]
            client1.buzz()
            
            XCTAssertTrue(client1.isWinner, "Client is not winner")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
}
