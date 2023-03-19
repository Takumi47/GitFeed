//
//  UserDetailsCoordinator.swift
//  GitFeed
//
//  Created by xander on 2023/3/18.
//

import UIKit

class UserDetailsCoordinator: BaseCoordinator {
    
    private let router: Routing
    private let models: [GitHubUser]
    
    init(router: Routing, models: [GitHubUser]) {
        self.router = router
        self.models = models
    }
    
    override func start() {
        let view = UserDetailsViewController.instantiate()
        view.viewModelBuilder = { [models] in
            UserDetailsViewModel(input: $0, dependencies: (models, ()))
        }
        
        router.push(view, isAnimated: true, onNavigationBack: completionHandler)
    }
}
