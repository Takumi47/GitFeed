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
    typealias Input = ()
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

struct UserDetailsViewModel: UserDetailsViewPresentable {
    
    var input: UserDetailsViewPresentable.Input
    var output: UserDetailsViewPresentable.Output
    
    init(input: UserDetailsViewPresentable.Input, dependencies: UserDetailsViewPresentable.Dependencies) {
        self.input = input
        self.output = UserDetailsViewModel.output(dependencies: dependencies)
    }
}

extension UserDetailsViewModel {
    static func output(dependencies: UserDetailsViewPresentable.Dependencies) -> UserDetailsViewPresentable.Output {
        let sections = Driver.just(dependencies.models)
            .map { $0.map(DetailsViewModel.init) }
            .map { [DetailsItemsSection(model: 0, items: $0)] }
        return (userDetails: sections, ())
    }
}
