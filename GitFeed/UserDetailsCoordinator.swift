//
//  UserDetailsCoordinator.swift
//  GitFeed
//
//  Created by xander on 2023/3/18.
//

import UIKit
import RxSwift

class UserDetailsCoordinator: BaseCoordinator {
    
    private let router: Routing
    private let models: [GitHubUser]
    private let bag = DisposeBag()
    
    init(router: Routing, models: [GitHubUser]) {
        self.router = router
        self.models = models
    }
    
    override func start() {
        let view = UserDetailsViewController.instantiate()
        view.viewModelBuilder = { [models, bag] in
            let viewModel = UserDetailsViewModel(input: $0, dependencies: (models, ()))
            viewModel.router.detailsSelected
                .map { [weak self] in
                    guard let self = self else { return }
                    self.showDetails(usingModel: $0)
                }
                .drive()
                .disposed(by: bag)
            return viewModel
        }
        
        router.push(view, isAnimated: true, onNavigationBack: completionHandler)
    }
}

extension UserDetailsCoordinator {
    func showDetails(usingModel model: GitHubUser) {
        let coordinator = ViewCoordinator(router: router, model: model)
        add(coordinator: coordinator)
        coordinator.completionHandler = { [weak self, weak coordinator] in
            guard let coordinator = coordinator else { return }
            self?.remove(coordinator: coordinator)
        }
        coordinator.start()
    }
}
