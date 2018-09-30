//
//  Result.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

enum Result<T> {
    case value(T)
    case error(Error)
}

extension Error {
    func toResult<T>() -> Result<T> {
        return .error(self)
    }
}

extension Result {
    func map<V>(_ f: (T) throws -> V) -> Result<V> {
        switch self {
        case let .value(v):
            do {
                return .value(try f(v))
            } catch {
                return error.toResult()
            }
        case let .error(e):
            return e.toResult()
        }
    }
    
    func onValue(_ f: (T) -> Void) {
        guard case let .value(v) = self else { return }
        f(v)
    }
    
    func onError(_ f: (Error) -> Void) {
        guard case let .error(e) = self else { return }
        f(e)
    }
}

typealias Callback<T> = (Result<T>) -> Void
