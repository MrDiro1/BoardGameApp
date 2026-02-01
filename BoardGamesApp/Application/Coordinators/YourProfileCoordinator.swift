//
//  YourProfileCoordinator.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 13.01.2026.
//

import UIKit
import Foundation


final class YourProfileCoordinator:  YourProfileNavigatableProtocol {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = YourProfileViewController()
        viewController.coordinator = self
        
        viewController.title = "Your Profile"
        viewController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: SFSymbols.nonFillPerson,
            selectedImage: SFSymbols.person
        )
        
        navigationController.setViewControllers([viewController], animated: false)
    }
}
