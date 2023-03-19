//
//  DetailsViewModel.swift
//  GitFeed
//
//  Created by xander on 2023/3/18.
//

import Foundation
import RxDataSources

typealias DetailsItemsSection = SectionModel<Int, DetailsViewPresentable>

protocol DetailsViewPresentable {
    var id: Int { get }
    var name: String { get }
    var login: String { get }
    var avatarUrl: String { get }
    var siteAdmin: Bool { get }
    var bio: String { get }
    var blog: String { get }
    var location: String { get }
}

struct DetailsViewModel: DetailsViewPresentable {
    let model: GitHubUserDetails
    
    var id: Int { model.id }
    var name: String { model.name ?? "" }
    var login: String { model.login }
    var avatarUrl: String { model.avatarURL }
    var siteAdmin: Bool { model.siteAdmin }
    var bio: String { model.bio ?? "" }
    var blog: String { model.blog ?? "" }
    var location: String { model.location ?? "" }
}
