//
//  SearchResultsViewController.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 24.01.2026.
//

import UIKit

final class SearchResultsViewController: UICollectionViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<String, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, String>
    
    private var dataSource: DataSource!
    private let viewModel: SearchGamesViewModelProtocol
    
    var searchQuery: String = ""
    weak var coordinator: GameDetailNavigatableProtocol?
    
    private let emptyView = EmptyView()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init(viewModel: SearchGamesViewModelProtocol) {
        let layout = UIHelper.createThreeColumnLayout(width: UIScreen.main.bounds.width)
        self.viewModel = viewModel
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        performSearch()
    }
    
    private func setupUI() {
        configureViewController()
        configureCollectionView()
        configureDataSource()
        setupLoadingIndicator()
        setupEmptyView()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Search Results"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureCollectionView() {
        collectionView.register(
            GameCollectionViewCell.self,
            forCellWithReuseIdentifier: GameCollectionViewCell.reuseID
        )
    }
    
    private func setupEmptyView() {
        emptyView.configure(with: .noApiData)
        emptyView.isHidden = true
        view.addSubview(emptyView)
        
        emptyView.pinToEdges(of: view, useSafeArea: true)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, gameId in
            self?.makeCell(for: collectionView, at: indexPath, gameId: gameId) ?? UICollectionViewCell()
        }
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func performSearch() {
         viewModel.search(query: searchQuery)
     }
    
    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(["main"])
        snapshot.appendItems(viewModel.games.map { String($0.id) })
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func makeCell(for collectionView: UICollectionView, at indexPath: IndexPath, gameId: String) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GameCollectionViewCell.reuseID,
            for: indexPath
        ) as? GameCollectionViewCell, let game = viewModel.games.first(where: { String($0.id) == gameId }) else {
            return UICollectionViewCell()
        }
        
        cell.set(game: game)
        return cell
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            viewModel.loadNextPage()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let idString = dataSource.itemIdentifier(for: indexPath),
            let gameId = Int(idString)
        else { return }
        
        coordinator?.showGameDetail(gameId: gameId)
    }
    
}

extension SearchResultsViewController: SearchGamesViewModelDelegate {
    func viewModelDidUpdateResults() {
        updateSnapshot()
        emptyView.isHidden = !viewModel.games.isEmpty
    }
    
    func viewModel(didFailWithError error: any Error) {
        AlertHelper.showError(error.localizedDescription, on: self)
        emptyView.isHidden = !viewModel.games.isEmpty
    }
    
    func viewModelDidStartLoading() {
        if viewModel.games.isEmpty {
            emptyView.isHidden = true
            loadingIndicator.startAnimating()
        }
    }
    
    func viewModelDidFinishLoading() {
        loadingIndicator.stopAnimating()
    }
}


