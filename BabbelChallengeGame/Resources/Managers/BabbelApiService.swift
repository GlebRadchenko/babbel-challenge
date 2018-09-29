//
//  BabbelApiService.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

class BabbelApiService: ApiService, WordsLoader {
    func loadWords(callback: @escaping Callback<[WordsPair]>) {
        sendRequest(ApiMethod.getWords, callback: callback)
    }
}

extension BabbelApiService {
    enum ApiMethod: RequestConvertible {
        static let baseURL = "https://gist.githubusercontent.com/"
        
        case getWords
        
        var httpMethod: HTTPMethod {
            switch self {
            case .getWords:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .getWords:
                return ApiMethod.baseURL + "DroidCoder/7ac6cdb4bf5e032f4c737aaafe659b33/raw/baa9fe0d586082d85db71f346e2b039c580c5804/words.json"
            }
        }
    }
}
