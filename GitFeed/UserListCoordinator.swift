//
//  UserListCoordinator.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import UIKit

class UserListCoordinator: BaseCoordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let view = UserListViewController.instantiate()
        let service = GitHubService.shared
        view.viewModelBuilder = { input in
            UserListViewModel(input: input, gitHubService: service)
        }
        
        navigationController.pushViewController(view, animated: true)
    }
}
