//
//  AppCoordinator.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 26.12.2025.
//

import Foundation
import UIKit

class AppCoordinator: CoordinatorProtocol {
    let window: UIWindow
    let navigationController = UINavigationController()
    
    private var childCoordinators: [CoordinatorProtocol] = []
        
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let tabBarController = UITabBarController()
        
        let coordinators: [CoordinatorProtocol] = [
            makeHotnessCoordinator(),
            makeSearchCoordinator(),
            makeNewsCoordinator(),
            makeYourProfileCoordinator()
        ]
        
        childCoordinators = coordinators
        coordinators.forEach { $0.start() }
        
        tabBarController.viewControllers = coordinators.map { $0.navigationController  }
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func makeHotnessCoordinator() -> CoordinatorProtocol {
        return TheHotnessCoordinator(navigationController: UINavigationController())
    }
    
    private func makeSearchCoordinator() -> CoordinatorProtocol {
        return SearchCoordinator(navigationController: UINavigationController())
    }
    
    private func makeNewsCoordinator() -> CoordinatorProtocol {
        return NewsCoordinator(navigationController: UINavigationController())
    }
    
    private func makeYourProfileCoordinator() -> CoordinatorProtocol {
        return YourProfileCoordinator(navigationController: UINavigationController())
    }
}
