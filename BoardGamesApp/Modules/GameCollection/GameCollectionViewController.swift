//
//  TheHotnessViewController.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 24.12.2025.
//
import UIKit

protocol GameCollectionViewModelProtocol: AnyObject {
    var games: [BoardGame] { get }
    var delegate: GameCollectionViewModelDelegate? { get set }
    var emptyViewState: EmptyViewState { get }
    
    func fetchGames(forceRefresh: Bool)
}

protocol GameCollectionViewModelDelegate: AnyObject {
    func viewModelDidUpdateGames()
    func viewModel(didFailWithError error: Error)
}

class GameCollectionViewController: UICollectionViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<String, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, String>
    
    private var dataSource: DataSource!
    private let viewModel: GameCollectionViewModelProtocol
    private let emptyView = EmptyView()
    
    weak var coordinator: GameDetailNavigatableProtocol?
    
    init(viewModel: GameCollectionViewModelProtocol) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchGames(forceRefresh: false)
    }
    
    private func setupUI() {
        configureViewController()
        configureCollectionView()
        configureDataSource()
        configureRefreshControl()
        setupEmptyView()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchGames(forceRefresh: false)
    }
    
    private func setupEmptyView() {
        emptyView.configure(with: viewModel.emptyViewState)
        emptyView.isHidden = true
        view.addSubview(emptyView)
        
        emptyView.pinToEdges(of: view, useSafeArea: true)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView() {
        collectionView.register(
            GameCollectionViewCell.self,
            forCellWithReuseIdentifier: GameCollectionViewCell.reuseID
        )
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, gameId in
            self?.cell(for: collectionView, at: indexPath, gameId: gameId) ?? UICollectionViewCell()
        }
    }
    
    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func handleRefresh() {
        viewModel.fetchGames(forceRefresh: true)
    }
    
    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(["main"])
        snapshot.appendItems(viewModel.games.map { String($0.id) })
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension GameCollectionViewController {
    func cell(
        for collectionView: UICollectionView,
        at indexPath: IndexPath,
        gameId: String
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GameCollectionViewCell.reuseID,
            for: indexPath
        ) as? GameCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let game = viewModel.games.first(where: { String($0.id) == gameId }) {
            cell.set(game: game)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard
            let idString = dataSource.itemIdentifier(for: indexPath),
            let gameId = Int(idString)
        else { return }
        
        coordinator?.showGameDetail(gameId: gameId)
    }
}

extension GameCollectionViewController: GameCollectionViewModelDelegate {
    func viewModelDidUpdateGames() {
        updateSnapshot()
        collectionView.refreshControl?.endRefreshing()
        emptyView.isHidden = !viewModel.games.isEmpty
    }
    
    func viewModel(didFailWithError error: any Error) {
        collectionView.refreshControl?.endRefreshing()
        AlertHelper.showError(error.localizedDescription, on: self)
        emptyView.isHidden = !viewModel.games.isEmpty
    }
}



