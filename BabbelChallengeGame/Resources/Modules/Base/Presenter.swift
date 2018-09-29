//
//  Presenter.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

protocol Presenter: ViperComponent {
    associatedtype View
    associatedtype Interactor
    associatedtype Router
    
    var view: View! { get set }
    var interactor: Interactor! { get set }
    var router: Router! { get set }
}
