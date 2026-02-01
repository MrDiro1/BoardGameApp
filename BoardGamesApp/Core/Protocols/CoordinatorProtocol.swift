//
//  CoordinatorProtocol.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 08.01.2026.
//

import Foundation
import UIKit

protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}


