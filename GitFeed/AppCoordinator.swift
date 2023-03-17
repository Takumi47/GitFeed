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
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }()
    
    // MARK: - Lifecycle
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Override
    
    override func start() {
        let userListCoordinator = UserListCoordinator(navigationController: navigationController)
        add(coordinator: userListCoordinator)
        userListCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
