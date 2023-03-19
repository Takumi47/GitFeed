//
//  UserViewCell.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import UIKit
import Kingfisher

class UserViewCell: UITableViewCell {

    static let reuseId = "\(UserViewCell.self)"
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var siteAdminLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clear()
    }
    
    private func clear() {
        avatarImageView.image = nil
        nameLabel.text = ""
        siteAdminLabel.isHidden = true
    }
}

extension UserViewCell {
    func configure(viewModel: UserViewPresentable) {
        nameLabel.text = viewModel.login
        siteAdminLabel.isHidden = !viewModel.siteAdmin
        
        if let url = URL(string: viewModel.avatarUrl) {
            avatarImageView.kf.setImage(with: url, placeholder: UIImage(named: "blank-avatar"))
        }
    }
}
