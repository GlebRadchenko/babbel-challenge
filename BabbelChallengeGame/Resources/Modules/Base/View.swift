//
//  View.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation
import UIKit

protocol View: ViperComponent {
    associatedtype Presenter
    
    var output: Presenter! { get set }
}

extension View where Self: UIViewController {
    static func instance() -> Self {
        return UIStoryboard.viewController() ?? Self()
    }
}
