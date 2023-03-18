//
//  UserListViewModel.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

protocol UserListViewPresentable {
    typealias Input = (
        userSelect: Driver<UserViewModel>, ()
    )
    typealias Output = (
        userList: Driver<[UserItemsSection]>, ()
    )
    typealias ViewModelBuilder = (UserListViewPresentable.Input) -> UserListViewPresentable
    
    var input: UserListViewPresentable.Input { get }
    var output: UserListViewPresentable.Output { get }
}

class UserListViewModel: UserListViewPresentable {
    
    var input: UserListViewPresentable.Input
    var output: UserListViewPresentable.Output
    private let gitHubService: GitHubAPI
    private let bag = DisposeBag()
    
    typealias State = (userList: BehaviorRelay<Set<GitHubUser>>, ())
    private let state: State = (userList: .init(value: []), ())
    
    private typealias RoutingAction = (userSelectedRelay: PublishRelay<[GitHubUser]>, ())
    private let routingAction: RoutingAction = (userSelectedRelay: .init(), ())
    
    typealias Routing = (userSelected: Driver<[GitHubUser]>, ())
    lazy var router: Routing = (userSelected: routingAction.userSelectedRelay.asDriver(onErrorDriveWith: .empty()), ())
    
    init(input: UserListViewPresentable.Input, gitHubService: GitHubAPI) {
        self.input = input
        self.gitHubService = gitHubService
        self.output = UserListViewModel.output(input: self.input, state: self.state)
        
        process()
    }
}

extension UserListViewModel {
    static func output(input: UserListViewPresentable.Input, state: State) -> UserListViewPresentable.Output {
        let userListObservable = state.userList.asObservable()
        let sections = userListObservable
            .map { $0.map(UserViewModel.init) }
            .map { $0.sorted { $0.id < $1.id} }
            .map { [UserItemsSection(model: 0, items: $0)] }
            .asDriver(onErrorJustReturn: [])
        return (sections, ())
    }
    
    func process() {
        gitHubService
            .fetchUserList()
            .map(Set.init)
            .map { [state] in state.userList.accept($0) }
            .subscribe()
            .disposed(by: bag)
        
        input.userSelect
            .map { $0.id }
            .withLatestFrom(state.userList.asDriver()) { ($0, $1) }
            .map { (id, userList) in
                userList.filter { $0.id == id }
            }
            .map { [routingAction] in
                routingAction.userSelectedRelay.accept($0)
            }
            .drive()
            .disposed(by: bag)
    }
}
