//
//  GitHubUserList.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import Foundation

typealias GitHubUserList = [GitHubUser]

struct GitHubUser: Codable {
    let login: String
    let id: Int
    let avatarURL: String
    let siteAdmin: Bool
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
        case siteAdmin = "site_admin"
    }
}

extension GitHubUser: Equatable {
    static func ==(lhs: GitHubUser, rhs: GitHubUser) -> Bool {
        lhs.id == rhs.id
    }
}

extension GitHubUser: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
