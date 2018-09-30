//
//  ApiService.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

class ApiService {
    let queue = DispatchQueue(label: "api-service-queue", qos: .background, attributes: .concurrent)
    let decoder = JSONDecoder()
    
    func sendRequest<T: Codable>(_ request: RequestConvertible, callback: @escaping Callback<T>) {
        do {
            let r = try request.toRequest()
            let task = URLSession.shared.dataTask(with: r) { [weak self] (data, response, error) in
                guard let wSelf = self else { return }
                
                do {
                    if let data = data {
                        callback(.value(try wSelf.decoder.decode(from: data)))
                    } else {
                        throw error ?? Error.noErrorNoValue
                    }
                } catch {
                    callback(error.toResult())
                }
            }
            
            queue.async { task.resume() }
        } catch {
            callback(error.toResult())
        }
    }
}

extension ApiService {
    enum Error: LocalizedError {
        case noErrorNoValue
    }
}
