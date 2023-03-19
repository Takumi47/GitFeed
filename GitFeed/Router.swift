//
//  Router.swift
//  GitFeed
//
//  Created by xander on 2023/3/19.
//

import UIKit

typealias NavigationBackHandler = (() -> Void)

protocol Routing {
    func push(_ drawable: Drawable, animated: Bool, onNavigationBack: NavigationBackHandler?)
    func pop(_ isAnimated: Bool)
}

final class Router: NSObject {
    
    private let navigationController: UINavigationController
    private var handlers: [String: NavigationBackHandler] = [:]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }
}

extension Router: Routing {
    func push(_ drawable: Drawable, animated: Bool, onNavigationBack handler: NavigationBackHandler?) {
        guard let viewController = drawable.viewController else { return }
        
        if let handler = handler {
            handlers.updateValue(handler, forKey: viewController.description)
        }
        
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func pop(_ isAnimated: Bool) {
        navigationController.popViewController(animated: isAnimated)
    }
}

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        guard !navigationController.viewControllers.contains(previousController) else { return }
        executeHandler(previousController)
    }
    
    private func executeHandler(_ viewController: UIViewController) {
        guard let handler = handlers.removeValue(forKey: viewController.description) else { return }
        handler()
    }
}
