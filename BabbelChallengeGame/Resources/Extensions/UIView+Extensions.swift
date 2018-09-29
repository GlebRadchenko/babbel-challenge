//
//  UIView+Extensions.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func randomlyLaunch(view: UIView, duration: TimeInterval) {
        view.layer.removeAllAnimations()
        
        let move = CAKeyframeAnimation(keyPath: "position")
        move.path = generateRandomPath(for: view).cgPath
        move.duration = duration
        move.timingFunctions = [CAMediaTimingFunction(name: .easeOut)]
        
        let fade = CAKeyframeAnimation(keyPath: "opacity")
        fade.values = [0, 1, 1, 0]
        fade.duration = duration
        
        view.layer.add(move, forKey: "move")
        view.layer.add(fade, forKey: "fade")
    }
    
    fileprivate func generateRandomPath(for view: UIView) -> UIBezierPath {
        let path = UIBezierPath()
        
        let threeSides = RectSide.allCases.removingRandomValue().shuffled()
        var points = threeSides.map { $0.randomSidePoint(in: bounds) }
        path.move(to: points[0])
        path.addQuadCurve(to: points[2], controlPoint: points[1])
        
        return path
    }
}

enum RectSide: CaseIterable {
    case left, top, right, bottom
    
    func randomSidePoint(in rect: CGRect, contentRect: CGRect) -> CGPoint {
        var randomPoint = randomSidePoint(in: rect)
        
        switch self {
        case .left:
            randomPoint.x -= contentRect.width / 2
        case .right:
            randomPoint.x += contentRect.width / 2
        case .top:
            randomPoint.y -= contentRect.height / 2
        case .bottom:
            randomPoint.y += contentRect.height / 2
        }
        
        return randomPoint
    }
    
    func randomSidePoint(in rect: CGRect) -> CGPoint {
        var x: CGFloat = rect.minX
        var y: CGFloat = rect.minY
        
        switch self {
        case .left, .right:
            x = self == .left ? rect.minX : rect.maxX
            y = CGFloat.random(in: rect.minY...rect.maxY)
        case .bottom, .top:
            y = self == .top ? rect.minY : rect.maxY
            x = CGFloat.random(in: rect.minX...rect.maxX)
        }
        
        return CGPoint(x: x, y: y)
    }
}
