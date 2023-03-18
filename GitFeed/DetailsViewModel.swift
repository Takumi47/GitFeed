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
    var login: String { get }
    var avatarUrl: String { get }
    var siteAdmin: Bool { get }
}

struct DetailsViewModel: DetailsViewPresentable {
    let model: GitHubUser
    
    var id: Int { model.id }
    var login: String { model.login }
    var avatarUrl: String { model.avatarURL }
    var siteAdmin: Bool { model.siteAdmin }
}
