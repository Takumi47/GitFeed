//
//  GitHubService.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import Foundation
import RxSwift
import Alamofire

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
                    .responseDecodable(of: GitHubUserList.self) { [weak self] response in
                        if let error = response.error {
                            single(.failure(error))
                        }
                        
                        if let headers = response.response?.headers,
                           let nextPageURL = self?.getNextPageURL(withHeaders: headers) {
                            UserDefaults.standard.setValue(nextPageURL, forKey: "nextPageURL")
                        }
                        
                        guard let userList = response.value else { return }
                        single(.success(userList))
                    }
            } catch {
                single(.failure(GHError.error(message: "UserList fetch failed: \(error.localizedDescription)")))
            }
            return Disposables.create()
        }
    }
    
    func fetchUserListNextPage() -> Single<GitHubUserList> {
        return Single.create { [httpService] single -> Disposable in
            do {
                let urlString = UserDefaults.standard.string(forKey: "nextPageURL") ?? ""
                let url = try urlString.asURL()
                let request = try URLRequest(url: url, method: .get)
                
                httpService.request(request)
                    .responseDecodable(of: GitHubUserList.self) { [weak self] response in
                        if let error = response.error {
                            single(.failure(error))
                        }
                        
                        if let headers = response.response?.headers,
                           let nextPageURL = self?.getNextPageURL(withHeaders: headers) {
                            UserDefaults.standard.setValue(nextPageURL, forKey: "nextPageURL")
                        }
                        
                        guard let userList = response.value else { return }
                        single(.success(userList))
                    }
            } catch {
                single(.failure(GHError.error(message: "UserList fetch failed: \(error.localizedDescription)")))
            }
            return Disposables.create()
        }
    }
    
    func fetchUserDetails(username: String) -> Single<GitHubUserDetails> {
        return Single.create { [httpService] single -> Disposable in
            do {
                try GitHubHttpRouter.getAUser(username: username)
                    .request(usingHttpService: httpService)
                    .responseDecodable(of: GitHubUserDetails.self) { response in
                        if let error = response.error {
                            single(.failure(error))
                        }
                        
                        guard let userDetails = response.value else { return }
                        single(.success(userDetails))
                    }
            } catch {
                single(.failure(GHError.error(message: "UserDetails fetch failed: \(error.localizedDescription)")))
            }
            return Disposables.create()
        }
    }
}

extension GitHubService {
    private func getNextPageURL(withHeaders headers: HTTPHeaders) -> String {
        guard let linkHeaders = headers["Link"] else { return "" }
        let links = linkHeaders.components(separatedBy: ",")
        
        var nextPageURL = ""
        for link in links {
            if link.hasSuffix("rel=\"next\"") {
                nextPageURL = link
                    .components(separatedBy: ";")[0]
                    .replacingOccurrences(of: "<", with: "")
                    .replacingOccurrences(of: ">", with: "")
            }
        }
        return nextPageURL
    }
}
