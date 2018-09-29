//
//  Router.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation

struct Module<R: Router> {
    var view: R.V
    weak var interactor: R.I?
    weak var presenter: R.P?
    weak var router: R?
}

protocol Router: class, InstanceInitializable, SpecificCastable {
    associatedtype V: View
    associatedtype I: Interactor
    associatedtype P: Presenter
    
    init()
}

extension Router {
    static func module() throws -> Module<Self>  {
        let v = V.instance()
        let i = I.instance()
        let p = P.instance()
        let r = Self.instance()
        
        p.view = try v.specific()
        p.interactor = try i.specific()
        p.router = try r.specific()
        
        v.output = try p.specific()
        
        i.output = try p.specific()
        
        return Module(view: v, interactor: i, presenter: p, router: r)
    }
}
