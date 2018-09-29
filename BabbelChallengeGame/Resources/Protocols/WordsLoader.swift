//
//  WordsLoader.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

protocol WordsLoader {
    func loadWords(callback: @escaping Callback<[WordsPair]>)
}
