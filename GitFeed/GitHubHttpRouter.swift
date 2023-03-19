//
//  GitHubHttpRouter.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import Alamofire

enum GitHubHttpRouter {
    case listUsers
    case getAUser(username: String)
}

extension GitHubHttpRouter: HttpRouter {
    var baseUrlString: String { "https://api.github.com/" }
    
    var path: String {
        switch self {
        case .listUsers:
            return "users"
        case .getAUser(let username):
            return "users/\(username)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .listUsers:
            return .get
        case .getAUser:
            return .get
        }
    }
    
    var parameters: Parameters? {
        [Parameters.Keys.since.rawValue: Parameters.Values.since.rawValue,
         Parameters.Keys.perPage.rawValue: Parameters.Values.perPage.rawValue]
    }
}

extension Parameters {
    enum Keys: String {
        case since
        case perPage = "per_page"
    }
    
    enum Values: String {
        case since = "0"
        case perPage = "20"
    }
}
