//
//  UserListCoordinator.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import UIKit
import RxSwift

class UserListCoordinator: BaseCoordinator {
    
    private let router: Routing
    private let bag = DisposeBag()
    
    init(router: Routing) {
        self.router = router
    }
    
    override func start() {
        let view = UserListViewController.instantiate()
        let service = GitHubService.shared
        view.viewModelBuilder = { [bag] input in
            let viewModel = UserListViewModel(input: input, gitHubService: service)
            viewModel.router.userSelected
                .map { [weak self] in
                    guard let self = self else { return }
                    self.showUserDetails(usingModels: $0)
                }
                .drive()
                .disposed(by: bag)
            return viewModel
        }
        
        router.push(view, isAnimated: true, onNavigationBack: completionHandler)
    }
}

extension UserListCoordinator {
    func showUserDetails(usingModels models: [GitHubUser]) {
        let userDetailsCoordinator = UserDetailsCoordinator(router: router, models: models)
        add(coordinator: userDetailsCoordinator)
        userDetailsCoordinator.completionHandler = { [weak self, weak userDetailsCoordinator] in
            guard let coordinator = userDetailsCoordinator else { return }
            self?.remove(coordinator: coordinator)
        }
        userDetailsCoordinator.start()
    }
}
