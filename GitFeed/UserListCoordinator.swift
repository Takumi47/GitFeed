//
//  UserListCoordinator.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import UIKit
import RxSwift

class UserListCoordinator: BaseCoordinator {
    
    private let navigationController: UINavigationController
    private let bag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let view = UserListViewController.instantiate()
        let service = GitHubService.shared
        view.viewModelBuilder = { [bag] input in
            let viewModel = UserListViewModel(input: input, gitHubService: service)
            viewModel.router.userSelected
                .map { [weak self] in
                    guard let self = self else { return }
                    self.showUserDetails(usingModel: $0)
                }
                .drive()
                .disposed(by: bag)
            return viewModel
        }
        
        navigationController.pushViewController(view, animated: true)
    }
}

extension UserListCoordinator {
    func showUserDetails(usingModel models: [GitHubUser]) {
        let userDetailsCoordinator = UserDetailsCoordinator(navigationController: navigationController, models: models)
        add(coordinator: userDetailsCoordinator)
        userDetailsCoordinator.start()
    }
}
