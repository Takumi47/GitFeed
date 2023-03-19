//
//  Drawable.swift
//  GitFeed
//
//  Created by xander on 2023/3/19.
//
//  Credit: https://benoitpasquier.com/coordinator-pattern-navigation-back-button-swift/

import UIKit

protocol Drawable {
    var viewController: UIViewController? { get }
}

extension UIViewController: Drawable {
    var viewController: UIViewController? { self }
}
