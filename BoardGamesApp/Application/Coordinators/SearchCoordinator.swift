//
//  SearchCoordinator.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 26.12.2025.
//

import UIKit
import Foundation

class SearchCoordinator: SearchNavigatableProtocol {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel: SearchGamesViewModelProtocol = SearchGamesViewModel()
        let viewController = SearchGamesViewController(viewModel: viewModel)
        viewController.coordinator = self
        
        viewController.title = "Search Games"
        viewController.tabBarItem = UITabBarItem(
            title: "Search",
            image: SFSymbols.searchIcon,
            selectedImage: nil
        )
        navigationController.setViewControllers([viewController], animated: false)
    }
}
