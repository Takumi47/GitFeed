//
//  UserDetailsCoordinator.swift
//  GitFeed
//
//  Created by xander on 2023/3/18.
//

import UIKit

class UserDetailsCoordinator: BaseCoordinator {
    
    private let navigationController: UINavigationController
    private let models: [GitHubUser]
    
    init(navigationController: UINavigationController, models: [GitHubUser]) {
        self.navigationController = navigationController
        self.models = models
    }
    
    override func start() {
        let view = UserDetailsViewController.instantiate()
        view.viewModelBuilder = { [models] in
            UserDetailsViewModel(input: $0, dependencies: (models, ()))
        }
        
        navigationController.pushViewController(view, animated: true)
    }
}
