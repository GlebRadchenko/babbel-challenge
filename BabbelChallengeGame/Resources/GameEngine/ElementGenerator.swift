//
//  WordGenerator.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

class ElementGenerator<E> {
    var elements: [E]
    var batchSize: Int
    
    var currentElementsBatch: [E] = []
    
    var currentElement: E?
    var currentPossibleElement: E?
    
    init() {
        elements = []
        batchSize = 0
    }
    
    init(elements: [E], batchSize: Int) {
        self.elements = elements
        self.batchSize = batchSize
    }
    
    func randomElement() -> E {
        return elements.randomElement()!
    }
    
    func randomDequeue(base: E) -> E {
        if currentElementsBatch.isEmpty {
            prepareBatch(base: base)
        }
        
        return currentElementsBatch.removeRandomValue()
    }
    
    func prepareBatch(base: E) {
        var randomElements = (1..<batchSize).compactMap { _ in elements.randomElement() }
        randomElements.append(base)
        randomElements.shuffle()
        
        currentElementsBatch = randomElements
    }
}
