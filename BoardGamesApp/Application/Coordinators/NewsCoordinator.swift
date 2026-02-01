//
//  NewsCoordinator.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 26.12.2025.
//

import Foundation
import UIKit
import SafariServices


class NewsCoordinator: NewsNavigatableProtocol {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel: NewsViewModelProtocol = NewsViewModel(newsService: .shared)
        let viewController = NewsViewController(viewModel: viewModel)
        viewController.coordinator = self
        
        viewController.title = "News"
        viewController.tabBarItem = UITabBarItem(
            title: "News",
            image: SFSymbols.newspaper,
            selectedImage: SFSymbols.newspaperFill
        )
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showArticle(_ article: NewsArticle, from viewController: UIViewController) {
        guard let url = URL(string: article.link) else { return }
        openURL(url, from: viewController)
    }

}

