//
//  Storyboardable.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import UIKit

protocol Storyboardable {
    static func instantiate() -> Self
}

extension Storyboardable where Self: UIViewController {
    static func instantiate() -> Self {
        let className = "\(type(of: self))".components(separatedBy: ".")[0]
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(identifier: className)
    }
}
