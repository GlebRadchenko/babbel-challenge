//
//  LayoutSet.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import UIKit

open class LayoutSet {
    public var top: NSLayoutConstraint?
    public var bottom: NSLayoutConstraint?
    public var leading: NSLayoutConstraint?
    public var trailing: NSLayoutConstraint?
    public var height: NSLayoutConstraint?
    public var width: NSLayoutConstraint?
    public var centerX: NSLayoutConstraint?
    public var centerY: NSLayoutConstraint?
    
    var allConstraints: [NSLayoutConstraint] {
        return [top, bottom, leading, trailing, height, width, centerX, centerY]
            .compactMap { $0 }
    }
    
    public init() { }
    public init(top: NSLayoutConstraint,
                bottom: NSLayoutConstraint,
                leading: NSLayoutConstraint,
                trailing: NSLayoutConstraint) {
        self.top = top
        self.bottom = bottom
        self.leading = leading
        self.trailing = trailing
    }
    
    public func activate() {
        NSLayoutConstraint.activate(allConstraints)
    }
    
    public func deactivate(shouldClear: Bool = false) {
        NSLayoutConstraint.deactivate(allConstraints)
        
        if shouldClear {
            top = nil
            bottom = nil
            leading = nil
            trailing = nil
            height = nil
            width = nil
            centerX = nil
            centerY = nil
        }
    }
}
