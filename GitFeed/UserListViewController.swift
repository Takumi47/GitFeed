//
//  UserListViewController.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class UserListViewController: UIViewController, Storyboardable {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    private lazy var refresher = UIRefreshControl()
    
    private var viewModel: UserListViewPresentable!
    var viewModelBuilder: UserListViewPresentable.ViewModelBuilder!
    
    private let bag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<UserItemsSection>(configureCell: { _, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserViewCell.reuseId, for: indexPath) as? UserViewCell else { return .init() }
        cell.configure(viewModel: item)
        return cell
    })
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = viewModelBuilder((
            refreshAction: refresher.rx.controlEvent(.valueChanged).asDriver(),
            userSelect: tableView.rx.modelSelected(UserViewPresentable.self).asDriver(onErrorDriveWith: .empty())
        ))
        
        setUI()
        setBinding()
        refresher.sendActions(for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Private Implementation
    
    private func setUI() {
        title = "Users"
        tableView.addSubview(refresher)
        tableView.register(UINib(nibName: "\(UserViewCell.self)", bundle: nil), forCellReuseIdentifier: UserViewCell.reuseId)
    }
    
    private func setBinding() {
        viewModel.output.userList
            .do { [weak self] _ in self?.refresher.endRefreshing() }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
}
