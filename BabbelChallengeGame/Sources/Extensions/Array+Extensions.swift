//
//  Array+Extensions.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

extension Array {
    public func keyed<K: Hashable>(by keyGenerator: (Element) throws -> K?) rethrows -> [K: Element] {
        var container: [K: Element] = [:]
        
        try forEach { (element) in
            guard let key = try keyGenerator(element) else { return }
            container[key] = element
        }
        
        return container
    }
    
    public func removingRandomValue() -> [Element] {
        var array = self
        array.removeRandomValue()
        return array
    }
    
    @discardableResult
    public mutating func removeRandomValue() -> Element {
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        return remove(at: randomIndex)
    }
}
