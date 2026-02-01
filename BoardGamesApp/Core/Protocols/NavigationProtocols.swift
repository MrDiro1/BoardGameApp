//
//  NavigationProtocols.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 17.01.2026.
//

import Foundation
import UIKit
import SafariServices

protocol GameDetailNavigatableProtocol: AnyObject {
    func showGameDetail(gameId: Int)
}

extension GameDetailNavigatableProtocol where Self: CoordinatorProtocol {
    func showGameDetail(gameId: Int) {
        let viewModel: GameDetailViewModelProtocol = GameDetailViewModel(gameId: gameId)
        let detailVC = GameDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
}

protocol WebNavigatableProtocol: AnyObject {
    func openURL(_ url: URL, from viewController: UIViewController)
}

extension WebNavigatableProtocol {
    func openURL(_ url: URL, from viewController: UIViewController) {
        let safariVC = SFSafariViewController(url: url)
        viewController.present(safariVC, animated: true)
    }
}

protocol SearchNavigatableProtocol: CoordinatorProtocol, GameDetailNavigatableProtocol {
    func showSearchResults(query: String, viewModel: SearchGamesViewModelProtocol)
}

extension SearchNavigatableProtocol {
    func showSearchResults(query: String, viewModel: SearchGamesViewModelProtocol) {
        let resultsVC = SearchResultsViewController(viewModel: viewModel)
        resultsVC.searchQuery = query
        resultsVC.coordinator = self
        navigationController.pushViewController(resultsVC, animated: true)
    }
}

protocol TheHotnessNavigatableProtocol: CoordinatorProtocol, GameDetailNavigatableProtocol {}


protocol NewsNavigatableProtocol: CoordinatorProtocol, WebNavigatableProtocol {
    func showArticle(_ article: NewsArticle, from viewController: UIViewController)
}

protocol YourProfileNavigatableProtocol: CoordinatorProtocol, GameDetailNavigatableProtocol {
    func showMyGames()
    func showMyPlays()
}

extension YourProfileNavigatableProtocol {
    func showMyGames() {
        let viewModel: GameCollectionViewModelProtocol = MyGamesViewModel()
        let vc = GameCollectionViewController(viewModel: viewModel)
        vc.coordinator = self
        vc.title = "My Games"
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showMyPlays() {
        let viewModel: MyPlaysViewModelProtocol = MyPlaysViewModel()
        let vc = MyPlaysViewController(viewModel: viewModel)
        vc.coordinator = self
        vc.title = "My Plays"
        navigationController.pushViewController(vc, animated: true)
    }
}
