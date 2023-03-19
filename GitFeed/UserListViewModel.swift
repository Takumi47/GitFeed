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
        refreshAction: Driver<()>,
        nextPageAction: Driver<()>,
        userSelect: Driver<UserViewPresentable>
    )
    typealias Output = (
        userList: Driver<[UserItemsSection]>,
        numberOfUsers: Driver<Int>,
        nextPageStatus: Driver<Bool>
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
    
    typealias State = (
        userList: BehaviorRelay<Set<GitHubUser>>,
        numberOfUsers: BehaviorRelay<Int>,
        nextPageURL: BehaviorRelay<String>
    )
    private let state: State = (
        userList: .init(value: []),
        numberOfUsers: .init(value: 0),
        nextPageURL: .init(value: "")
    )
    
    private typealias RoutingAction = (userSelectedRelay: PublishRelay<[GitHubUserDetails]>, ())
    private let routingAction: RoutingAction = (userSelectedRelay: .init(), ())
    
    typealias Routing = (userSelected: Driver<[GitHubUserDetails]>, ())
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
        
        let numberOfUsers = state.numberOfUsers.asDriver()
        
        let nextPageStatus = state.nextPageURL.asObservable()
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        return (sections, numberOfUsers, nextPageStatus)
    }
    
    func process() {
        input.refreshAction.asObservable()
            .flatMapLatest { [gitHubService] _ in
                gitHubService.fetchUserList()
            }
            .map(Set.init)
            .map { [state] in
                state.userList.accept($0)
                state.numberOfUsers.accept($0.count)
            }
            .subscribe()
            .disposed(by: bag)
        
        input.userSelect.asObservable()
            .map { $0.id }
            .withLatestFrom(state.userList.asDriver()) { ($0, $1) }
            .compactMap { (id, userList) in
                userList.filter { $0.id == id }.first
            }
            .flatMapLatest { [gitHubService] user -> Single<GitHubUserDetails> in
                gitHubService.fetchUserDetails(username: user.login)
            }
            .map { [routingAction] in
                routingAction.userSelectedRelay.accept([$0])
            }
            .subscribe()
            .disposed(by: bag)
        
        UserDefaults.standard.rx
            .observe(String.self, "nextPageURL")
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .compactMap { $0 }
            .bind(to: state.nextPageURL)
            .disposed(by: bag)
        
        input.nextPageAction.asObservable()
            .flatMapLatest { [gitHubService] _ in
                gitHubService.fetchUserListNextPage()
            }
            .map(Set.init)
            .map { [state] in
                state.userList.accept($0)
                state.numberOfUsers.accept($0.count)
            }
            .subscribe()
            .disposed(by: bag)
    }
}
