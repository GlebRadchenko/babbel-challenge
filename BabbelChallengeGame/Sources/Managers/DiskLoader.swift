//
//  DiskLoader.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

class DiskLoader {
    func loadObject<T: Codable>(from fileName: String, ext: String, callback: @escaping Callback<T>) {
        DispatchQueue.global().async {
            do {
                guard let url = Bundle.main.url(forResource: fileName, withExtension: ext) else {
                    throw Error.noFilePresented
                }
                
                let data = try Data(contentsOf: url)
                let object: T = try JSONDecoder().decode(from: data)
                
                callback(.value(object))
            } catch {
                callback(error.toResult())
            }
        }
    }
    
    enum Error: LocalizedError {
        case noDirectory
        case noFilePresented
    }
}
