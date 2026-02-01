//
//  MyGamesViewModel.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 14.01.2026.
//

import Foundation
import CoreData

final class MyGamesViewModel: GameCollectionViewModelProtocol {
    
    private let coreDataManager: CoreDataManagerProtocol
    private(set) var games: [BoardGame] = []
    
    weak var delegate: GameCollectionViewModelDelegate?
    
    var emptyViewState: EmptyViewState {
        return .emptyCollection
    }
    
    init(coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchGames(forceRefresh: Bool) {
        do {
            games = try coreDataManager.fetchAllGames()
            delegate?.viewModelDidUpdateGames()
        } catch {
            delegate?.viewModel(didFailWithError: error)
        }
    }
}
