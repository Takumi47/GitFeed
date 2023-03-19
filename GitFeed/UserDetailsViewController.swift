//
//  UserDetailsViewController.swift
//  GitFeed
//
//  Created by xander on 2023/3/18.
//

import UIKit
import RxSwift
import RxDataSources

class UserDetailsViewController: UIViewController, Storyboardable {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: UserDetailsViewPresentable!
    var viewModelBuilder: UserDetailsViewPresentable.ViewModelBuilder!
    
    private let bag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<DetailsItemsSection>(configureCell: { _, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailsViewCell.reuseId, for: indexPath) as? UserDetailsViewCell else { return .init() }
        cell.configure(viewModel: item)
        return cell
    })
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = viewModelBuilder(())
        
        setUI()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Private Implementation
    
    private func setUI() {
        title = ""
        tableView.register(UINib(nibName: "\(UserDetailsViewCell.self)", bundle: nil), forCellReuseIdentifier: UserDetailsViewCell.reuseId)
    }
    
    private func setBinding() {
        viewModel.output.userDetails
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
}
