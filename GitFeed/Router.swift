//
//  Router.swift
//  GitFeed
//
//  Created by xander on 2023/3/19.
//

import UIKit

typealias RoutingHandler = (() -> Void)

protocol Routing {
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigationBack: RoutingHandler?)
    func pop(_ isAnimated: Bool)
    func popToRoot(_ isAnimated: Bool)
    func present(_ drawable: Drawable, isAnimated: Bool, onDismiss: RoutingHandler?)
}

final class Router: NSObject {
    
    private let navigationController: UINavigationController
    private var handlers: [String: RoutingHandler] = [:]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }
}

extension Router: Routing {
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigationBack handler: RoutingHandler?) {
        guard let viewController = drawable.viewController else { return }
        
        if let handler = handler {
            handlers.updateValue(handler, forKey: viewController.description)
        }
        
        navigationController.pushViewController(viewController, animated: isAnimated)
    }
    
    func pop(_ isAnimated: Bool) {
        navigationController.popViewController(animated: isAnimated)
    }
    
    func popToRoot(_ isAnimated: Bool) {
        navigationController.popToRootViewController(animated: isAnimated)
    }
    
    func present(_ drawable: Drawable, isAnimated: Bool, onDismiss handler: RoutingHandler?) {
        guard let viewController = drawable.viewController else { return }
        
        if let handler = handler {
            handlers.updateValue(handler, forKey: viewController.description)
        }
        
        navigationController.present(viewController, animated: isAnimated)
        viewController.presentationController?.delegate = self
    }
    
    private func executeHandler(_ viewController: UIViewController) {
        guard let handler = handlers.removeValue(forKey: viewController.description) else { return }
        handler()
    }
}

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        guard !navigationController.viewControllers.contains(previousController) else { return }
        executeHandler(previousController)
    }
}

extension Router: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        executeHandler(presentationController.presentedViewController)
    }
}
