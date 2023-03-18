//
//  UserDetailsViewCell.swift
//  GitFeed
//
//  Created by xander on 2023/3/18.
//

import UIKit

class UserDetailsViewCell: UITableViewCell {

    static let reuseId = "\(UserDetailsViewCell.self)"
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var siteAdminLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clear()
    }
    
    private func clear() {
        avatarImageView.image = nil
        nameLabel.text = ""
        bioLabel.text = ""
        loginLabel.text = ""
        siteAdminLabel.isHidden = true
        locationLabel.text = ""
        blogLabel.text = ""
    }
}

extension UserDetailsViewCell {
    func configure(viewModel: DetailsViewPresentable) {
        nameLabel.text = viewModel.login
        loginLabel.text = viewModel.login
        siteAdminLabel.isHidden = !viewModel.siteAdmin
        
        if let url = URL(string: viewModel.avatarUrl) {
            avatarImageView.kf.setImage(with: url, placeholder: UIImage(named: "blank-avatar"))
        }
    }
}
