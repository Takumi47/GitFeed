//
//  ViewCoordinator.swift
//  GitFeed
//
//  Created by xander on 2023/3/19.
//

import Foundation

class ViewCoordinator: BaseCoordinator {
    
    private let router: Routing
    private let model: GitHubUser
    
    init(router: Routing, model: GitHubUser) {
        self.router = router
        self.model = model
    }
    
    override func start() {
        let view = ViewController.instantiate()
        router.present(view, isAnimated: true, onDismiss: completionHandler)
    }
}
