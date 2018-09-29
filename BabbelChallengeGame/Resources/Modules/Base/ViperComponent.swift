//
//  ViperComponent.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

protocol ViperComponent: class, InstanceInitializable, SpecificCastable { }

protocol InstanceInitializable {
    static func instance() -> Self
}

protocol SpecificCastable {
    func specific<T>() throws -> T
}

extension SpecificCastable {
    func specific<T>() throws -> T {
        guard let specific = self as? T else {
            throw SpecificCastError.cantCast
        }
        
        return specific
    }
}

enum SpecificCastError: Error {
    case cantCast
}
