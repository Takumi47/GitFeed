//
//  GitHubUserDetails.swift
//  GitFeed
//
//  Created by xander on 2023/3/18.
//

import Foundation

struct GitHubUserDetails: Codable {
    let login: String
    let id: Int
    let avatarURL: String
    let siteAdmin: Bool
    let name: String?
    let blog: String?
    let location: String?
    let bio: String?

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
        case siteAdmin = "site_admin"
        case name, blog, location, bio
    }
}
