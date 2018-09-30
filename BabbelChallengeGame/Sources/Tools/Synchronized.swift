//
//  Synchronized.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/30/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

struct Synchronized<V> {
    private var lock = NSLock()
    private var iValue: V
    
    var value: V {
        get {
            lock.lock(); defer { lock.unlock() }
            let v = iValue
            return v
        }
        
        set {
            lock.lock()
            iValue = newValue
            lock.unlock()
        }
    }
    
    init(value: V) {
        self.iValue = value
    }
}
