//
//  UIColor+Extensions.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import UIKit

extension UIColor {
    static var defaultColor: UIColor {
        return UIColor(red: 47, green: 50, blue: 80)
    }
    
    static var defaultRedColor: UIColor {
        return UIColor(red: 205, green: 89, blue: 74)
    }
    
    static var defaultGreenColor: UIColor {
        return UIColor(red: 76, green: 160, blue: 102)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: rgb & 0xFF)
    }
    
    convenience init(hex: String) {
        var hex = hex
        
        if hex.hasPrefix("#") {
            hex.removeFirst()
        }
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)
        
        self.init(rgb: Int(rgb))
    }
}
