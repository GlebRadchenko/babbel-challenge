//
//  Router.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation
import UIKit

struct Module<R: Router> {
    weak var view: R.V?
    weak var interactor: R.I?
    weak var presenter: R.P?
    weak var router: R?
}

protocol Router: ViperComponent, Initializable {
    associatedtype V: View
    associatedtype I: Interactor
    associatedtype P: Presenter
    
    var module: Module<Self>? { get set }
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
        
        let module = Module(view: v, interactor: i, presenter: p, router: r)
        
        r.module = module
        
        return module
    }
}

extension Router where V: UIViewController {
    @discardableResult
    static func module(displayedIn window: UIWindow) throws -> Module<Self> {
        let m = try module()
        
        window.rootViewController = m.view
        window.makeKeyAndVisible()
        
        return m
    }
}
