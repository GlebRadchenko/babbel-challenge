//
//  UIStoryboard+Extensions.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    static func viewController<T: UIViewController>() -> T? {
        var storyboardName = String(describing: T.self)
        
        if let range = storyboardName.range(of: "ViewController") {
            storyboardName.removeSubrange(range)
        }
        
        if let range = storyboardName.range(of: "View") {
            storyboardName.removeSubrange(range)
        }
        
        return viewController(storyboardName: storyboardName)
    }
    
    static func viewController<T: UIViewController>(storyboardName: String) -> T? {
        let bundle = Bundle(for: T.self)
        return UIStoryboard(name: storyboardName, bundle: bundle).instantiateInitialViewController() as? T
    }
}
