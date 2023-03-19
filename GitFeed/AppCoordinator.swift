//
//  AppCoordinator.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    private let window: UIWindow
    
    private let navigationController: UINavigationController = {
        let nav = UINavigationController()
        return nav
    }()
    
    // MARK: - Lifecycle
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Override
    
    override func start() {
        let router = Router(navigationController: navigationController)
        let userListCoordinator = UserListCoordinator(router: router)
        add(coordinator: userListCoordinator)
        userListCoordinator.completionHandler = { [weak self, weak userListCoordinator] in
            guard let coordiantor = userListCoordinator else { return }
            self?.remove(coordinator: coordiantor)
        }
        userListCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
