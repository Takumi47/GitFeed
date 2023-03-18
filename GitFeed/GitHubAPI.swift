//
//  GitHubAPI.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import Foundation
import RxSwift

protocol GitHubAPI {
    func fetchUserList() -> Single<GitHubUserList>
}