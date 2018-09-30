//
//  RequestConvertible.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

protocol RequestConvertible {
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var body: [String: Any]? { get }
    
    func toRequest() throws -> URLRequest
}

extension RequestConvertible {
    var body: [String: Any]? {
        return nil
    }
    
    func toRequest() throws -> URLRequest {
        guard let url = URL(string: path) else {
            throw RequestConvertibleError.invalidPath
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        return request
    }
}

enum RequestConvertibleError: Error {
    case invalidPath
}
