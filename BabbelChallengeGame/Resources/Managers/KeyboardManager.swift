//
//  KeyboardManager.swift
//  BabbelChallengeGame
//
//  Created by Gleb Radchenko on 9/29/18.
//  Copyright © 2018 Gleb Radchenko. All rights reserved.
//

import Foundation
import UIKit

open class KeyboardManager {
    var notificationCenter: NotificationCenter {
        return NotificationCenter.default
    }
    
    var mainWindow: UIWindow? {
        guard let delegate = UIApplication.shared.delegate else {
            return nil
        }
        
        return delegate.window ?? nil
    }
    
    weak var scrollView: UIScrollView?
    
    var trackKeyboard = true
    var shouldScrollToInputViews = false
    var defaultScrollViewBottomInset: CGFloat = 0
    
    var onKeyboardFrameDidChange: ((CGRect, TimeInterval) -> Void)?
    var onKeyboardFrameWillChange: ((CGRect, TimeInterval) -> Void)?
    
    deinit {
        removeObservers()
    }
    
    public init() {
        addObservers()
    }
    
    public convenience init(scrollView: UIScrollView) {
        self.init()
        self.scrollView = scrollView
    }
    
    public static func managing(scrollView: UIScrollView) -> KeyboardManager {
        return KeyboardManager(scrollView: scrollView)
    }
    
    public func addObservers() {
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillChangeFrame),
                                       name: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardDidChangeFrame),
                                       name: UIResponder.keyboardDidChangeFrameNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(textViewTextDidBeginEditing),
                                       name: UITextView.textDidBeginEditingNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(textFieldTextDidBeginEditing),
                                       name: UITextField.textDidBeginEditingNotification,
                                       object: nil)
    }
    
    public func removeObservers() {
        notificationCenter.removeObserver(self)
    }
    
    @objc
    open func textViewTextDidBeginEditing(notification: Notification) {
        guard let object = notification.object as? UITextView else { return }
        handleViewDidBeginEditing(view: object, notification: notification)
    }
    
    @objc
    open func textFieldTextDidBeginEditing(notification: Notification) {
        guard let object = notification.object as? UITextField else { return }
        handleViewDidBeginEditing(view: object, notification: notification)
    }
    
    fileprivate func handleViewDidBeginEditing(view: UIView, notification: Notification) {
        guard shouldScrollToInputViews else { return }
        guard let scrollView = scrollView else { return }
        guard view.isDescendant(of: scrollView) else { return }
        
        let container = view.superview ?? view
        let rect = container.convert(view.frame, to: scrollView)
        scrollView.scrollRectToVisible(rect, animated: true)
    }
    
    @objc
    open func keyboardWillChangeFrame(notification: Notification) {
        guard trackKeyboard else { return }
        
        guard let endFrame = keyboardEndFrame(from: notification) else {
            return
        }
        
        adjustScrollViewInsets(for: endFrame)
        
        let duration = keyboardAnimationDuration(from: notification) ?? 0
        onKeyboardFrameWillChange?(endFrame, duration)
    }
    
    @objc
    open func keyboardDidChangeFrame(notification: Notification) {
        guard trackKeyboard else { return }
        
        guard let endFrame = keyboardEndFrame(from: notification) else {
            return
        }
        
        adjustScrollViewInsets(for: endFrame)
        
        let duration = keyboardAnimationDuration(from: notification) ?? 0
        onKeyboardFrameDidChange?(endFrame, duration)
    }
    
    fileprivate func adjustScrollViewInsets(for keyboardEndFrame: CGRect) {
        guard let window = mainWindow else { return }
        guard let scrollView = scrollView else { return }
        let container = scrollView.superview ?? window
        let scrollViewRect = container.convert(scrollView.frame, to: window)
        
        let keyboardRect = window.convert(keyboardEndFrame, to: window)
        
        if scrollViewRect.intersects(keyboardRect) {
            let intersection = scrollViewRect.intersection(keyboardRect)
            updateBottomInset(intersection.height)
        } else {
            updateBottomInset(defaultScrollViewBottomInset)
        }
    }
    
    fileprivate func updateBottomInset(_ value: CGFloat) {
        guard let scrollView = scrollView else { return }
        
        scrollView.contentInset.bottom = value
        scrollView.scrollIndicatorInsets.bottom = value
    }
    
    func keyboardBeginFrame(from notification: Notification) -> CGRect? {
        let userInfo = notification.userInfo
        return userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect
    }
    
    func keyboardEndFrame(from notification: Notification) -> CGRect? {
        let userInfo = notification.userInfo
        return userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
    }
    
    func keyboardAnimationDuration(from notification: Notification) -> TimeInterval? {
        let userInfo = notification.userInfo
        return userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
    }
}
