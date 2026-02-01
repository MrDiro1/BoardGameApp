//
//  NewsViewController.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 24.12.2025.
//

import UIKit

class NewsViewController: UIViewController {
    
    private let viewModel: NewsViewModelProtocol
    private let tableView = UITableView()
    private let emptyView = EmptyView()
    
    weak var coordinator: NewsNavigatableProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchNews(forceRefresh: false)
    }
    
    init(viewModel: NewsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupEmptyView() {
        emptyView.configure(with: .noApiData)
        emptyView.isHidden = true
        view.addSubview(emptyView)
        
        emptyView.pinToEdges(of: view, useSafeArea: true)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pinToEdges(of: view)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ImageTitleTableViewCell.self, forCellReuseIdentifier: ImageTitleTableViewCell.reuseID)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .singleLine
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func handleRefresh() {
        viewModel.refreshGames()
    }
}

extension NewsViewController: NewsViewModelDelegate {
    func viewModelDidUpdateNews(_ viewModel: NewsViewModel) {
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
        
        emptyView.isHidden = !self.viewModel.news.isEmpty
    }
    
    func viewModel(_ viewModel: NewsViewModel, didFailWithError error: any Error) {
        tableView.refreshControl?.endRefreshing()
        
        AlertHelper.showError(error.localizedDescription, on: self)
        
        tableView.reloadData()
        emptyView.isHidden = !viewModel.news.isEmpty
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.news.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImageTitleTableViewCell.reuseID,
            for: indexPath
        ) as? ImageTitleTableViewCell else {
            return UITableViewCell()
        }
        
        let article = viewModel.news[indexPath.row]
        cell.configure(with: article)
        return cell
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = viewModel.news[indexPath.row]
        coordinator?.showArticle(article, from: self)
    }
}
