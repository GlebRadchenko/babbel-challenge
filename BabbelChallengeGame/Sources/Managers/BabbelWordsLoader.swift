//
//  BabbelWordsLoader.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

class BabbelWordsLoader: DiskLoader, WordsLoader {
    func loadWords(callback: @escaping Callback<[WordsPair]>) {
        loadObject(from: "words", ext: "json", callback: callback)
    }
}
