//
//  UserViewModel.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import Foundation
import RxDataSources

typealias UserItemsSection = SectionModel<Int, UserViewPresentable>

protocol UserViewPresentable {
    var id: Int { get }
    var login: String { get }
    var avatarUrl: String { get }
    var siteAdmin: Bool { get }
    
}

struct UserViewModel: UserViewPresentable {
    let model: GitHubUser
    
    var id: Int { model.id }
    var login: String { model.login }
    var avatarUrl: String { model.avatarURL }
    var siteAdmin: Bool { model.siteAdmin }
}
