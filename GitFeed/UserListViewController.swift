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
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
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
            nextPageAction: rightBarButton.rx.asSafeDriver(),
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
            .do { [weak self] _ in
                self?.refresher.endRefreshing()
            }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.output.numberOfUsers
            .filter { $0 > 0 }
            .map { "\($0) user\($0 == 1 ? "" : "s")" }
            .drive(leftBarButton.rx.title)
            .disposed(by: bag)
        
        viewModel.output.nextPageStatus
            .drive(rightBarButton.rx.isEnabled)
            .disposed(by: bag)
    }
}
