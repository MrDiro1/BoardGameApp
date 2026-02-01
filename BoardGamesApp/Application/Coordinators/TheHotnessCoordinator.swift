//
//  TheHotnessCoordinator.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 26.12.2025.
//

import UIKit
import Foundation



class TheHotnessCoordinator:  TheHotnessNavigatableProtocol {

    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let viewModel = TheHotnessViewModel(apiService: APIService.shared)
        let viewController = GameCollectionViewController(viewModel: viewModel)
        viewController.coordinator = self
        
        viewController.title = "The Hotness"
        viewController.tabBarItem = UITabBarItem(
            title: "Hotness",
            image: SFSymbols.flame,
            selectedImage: SFSymbols.flameFill
        )
        
        navigationController.setViewControllers([viewController], animated: false)
    }
}
