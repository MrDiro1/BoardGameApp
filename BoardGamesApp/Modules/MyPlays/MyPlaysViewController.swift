//
//  MyPlaysViewController.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 19.01.2026.
//

import UIKit

class MyPlaysViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel: MyPlaysViewModelProtocol
    private let emptyView = EmptyView()
    
    weak var coordinator: YourProfileNavigatableProtocol?
    
    init(viewModel: MyPlaysViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchPlays()
    }
    
    private func setupUI() {
        configureViewController()
        setupTableView()
        setupEmptyView()
        configureRefreshControl()
        setupViewModel()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "My Plays"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupEmptyView() {
        emptyView.configure(with: .emptyPlays)
        emptyView.isHidden = true
        view.addSubview(emptyView)
        
        emptyView.pinToEdges(of: view, useSafeArea: true)
    }
    
    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pinToEdges(of: view)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ImageTitleTableViewCell.self, forCellReuseIdentifier: ImageTitleTableViewCell.reuseID)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .singleLine
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchPlays()
    }
    
    @objc private func handleRefresh() {
         viewModel.fetchPlays()
     }
}

extension MyPlaysViewController: MyPlaysViewModelDelegate {
    func viewModelDidUpdatePlays() {
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
        
        emptyView.isHidden = !viewModel.plays.isEmpty
    }
    
    func viewModel(didFailWithError error: any Error) {
        tableView.refreshControl?.endRefreshing()
        AlertHelper.showError(error.localizedDescription, on: self)
        emptyView.isHidden = !viewModel.plays.isEmpty
    }
}

extension MyPlaysViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.plays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTitleTableViewCell.reuseID, for: indexPath) as? ImageTitleTableViewCell else {
            return UITableViewCell()
        }
        
        let record = viewModel.plays[indexPath.row]
        let model = PlayRecordCellModel(play: record)
        cell.configure(with: model)
        
        return cell
    }
}

extension MyPlaysViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let record = viewModel.plays[indexPath.row]
        coordinator?.showGameDetail(gameId: Int(record.gameId))
    }
}
