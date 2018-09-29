//
//  PlayerPanelRouter.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

protocol PlayerPanelRouterInput {
    
}

final class PlayerPanelRouter: Router, PlayerPanelRouterInput {
    typealias V = PlayerPanelViewController
    typealias I = PlayerPanelInteractor
    typealias P = PlayerPanelPresenter
    
    var module: Module<PlayerPanelRouter>?
    
    required init() { }
    
    static func module(with client: BuzzerGameClient) throws -> Module<PlayerPanelRouter> {
        let m = try module()
        m.interactor?.client = client
        
        return m
    }
}
