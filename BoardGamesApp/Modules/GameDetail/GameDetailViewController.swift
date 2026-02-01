//
//  GameDetailsView.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 08.01.2026.
//

import UIKit


final class GameDetailViewController: UIViewController {
    
    private let viewModel: GameDetailViewModelProtocol
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerView = GameDetailHeaderView()
    private let descriptionView = GameDescriptionView()
    private let actionsView = GameActionsView()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init(viewModel: GameDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(headerView, descriptionView, actionsView)
        
        actionsView.delegate = self
        scrollView.alpha = 0
        
        applyConstraints()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        loadingIndicator.startAnimating()
        viewModel.fetchGameDetails()
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                
                headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                
                descriptionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                
                actionsView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor),
                actionsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                actionsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                actionsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                
                loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
    
    private func configure(with detail: BoardGameDetail) {
        headerView.configure(with: detail)
        descriptionView.configure(description: detail.description)
        
        let isInCollection = viewModel.isGameInCollection()
        actionsView.updateCollectionButtonState(isInCollection: isInCollection)
    }
}

extension GameDetailViewController: GameDetailViewModelDelegate {
    func viewModelDidUpdateGameDetails(_ viewModel: GameDetailViewModel) {
        loadingIndicator.stopAnimating()
        
        guard let detail = viewModel.gameDetail else { return }
        
        configure(with: detail)
        
        UIView.animate(withDuration: 0.3) {
            self.scrollView.alpha = 1
        }
    }
    
    func viewModel(_ viewModel: GameDetailViewModel, didFailWithError error: Error) {
        loadingIndicator.stopAnimating()
        AlertHelper.showError(error.localizedDescription, on: self)
    }
}

extension GameDetailViewController: GameActionsViewDelegate {
    func gameActionsViewDidTappedAddToPlay(_ view: GameActionsView) {
        do {
            try viewModel.logPlay()
            AlertHelper.showSuccess("Play logged!", on: self)
        } catch {
            AlertHelper.showError("Failed to log play", on: self)
        }
    }
    
    func gameActionsViewDidTappedAddTiCollection(_ view: GameActionsView) {
        do {
            let isNowInCollection = try viewModel.toggleCollection()
            actionsView.updateCollectionButtonState(isInCollection: isNowInCollection)
            
            let message = isNowInCollection ? "Added to collection" : "Removed from collection"
            AlertHelper.showSuccess(message, on: self)
        } catch {
            AlertHelper.showError("Failed to update collection", on: self)
        }
    }
}
