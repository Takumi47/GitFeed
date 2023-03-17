//
//  GitHubService.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import Foundation
import RxSwift

class GitHubService {
    static let shared = GitHubService()
    
    private lazy var httpService = GitHubHttpService()
}

extension GitHubService: GitHubAPI {
    func fetchUserList() -> Single<GitHubUserList> {
        return Single.create { [httpService] single -> Disposable in
            do {
                try GitHubHttpRouter.listUsers
                    .request(usingHttpService: httpService)
                    .responseDecodable(of: GitHubUserList.self) { response in
                        if let error = response.error {
                            single(.failure(error))
                        }
                        
                        guard let userList = response.value else { return }
                        single(.success(userList))
                    }
            } catch {
                single(.failure(GHError.error(message: "UserList fetch failed")))
            }
            return Disposables.create()
        }
    }
}
