//
//  UserDetailsViewModel.swift
//  GitFeed
//
//  Created by xander on 2023/3/18.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserDetailsViewPresentable {
    typealias Input = (
        detailsSelect: Driver<DetailsViewPresentable>, ()
    )
    typealias Output = (
        userDetails: Driver<[DetailsItemsSection]>, ()
    )
    typealias Dependencies = (
        models: [GitHubUser], ()
    )
    typealias ViewModelBuilder = (UserDetailsViewPresentable.Input) -> UserDetailsViewPresentable
    
    var input: UserDetailsViewPresentable.Input { get }
    var output: UserDetailsViewPresentable.Output { get }
}

class UserDetailsViewModel: UserDetailsViewPresentable {
    
    var input: UserDetailsViewPresentable.Input
    var output: UserDetailsViewPresentable.Output
    private let bag = DisposeBag()
    
    private typealias RoutingAction = (detailsSelectedRelay: PublishRelay<GitHubUser>, ())
    private let routingAction: RoutingAction = (detailsSelectedRelay: .init(), ())
    
    typealias Routing = (detailsSelected: Driver<GitHubUser>, ())
    lazy var router: Routing = (detailsSelected: routingAction.detailsSelectedRelay.asDriver(onErrorDriveWith: .empty()), ())
    
    init(input: UserDetailsViewPresentable.Input, dependencies: UserDetailsViewPresentable.Dependencies) {
        self.input = input
        self.output = UserDetailsViewModel.output(dependencies: dependencies)
        
        process(dependencies: dependencies)
    }
}

extension UserDetailsViewModel {
    static func output(dependencies: UserDetailsViewPresentable.Dependencies) -> UserDetailsViewPresentable.Output {
        let sections = Driver.just(dependencies.models)
            .map { $0.map(DetailsViewModel.init) }
            .map { [DetailsItemsSection(model: 0, items: $0)] }
        return (userDetails: sections, ())
    }
    
    func process(dependencies: UserDetailsViewPresentable.Dependencies) {
        input.detailsSelect
            .compactMap { [models = dependencies.models] viewModel in
                models.filter { $0.id == viewModel.id }.first
            }
            .map { [routingAction] in
                routingAction.detailsSelectedRelay.accept($0)
            }
            .drive()
            .disposed(by: bag)
    }
}
