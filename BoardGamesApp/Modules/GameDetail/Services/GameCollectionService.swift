//
//  GameCollectionService.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 15.01.2026.
//

import Foundation

protocol GameCollectionServiceProtocol {
    func toggleGameInCollection(_ game: BoardGameDetail) throws -> Bool
    func isGameInCollection(withId id: Int) -> Bool
}

final class GameCollectionService: GameCollectionServiceProtocol {
    
    private let coreDataManager: CoreDataManagerProtocol
    
    init(coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    func toggleGameInCollection(_ game: BoardGameDetail) throws -> Bool {
        let isInCollection = coreDataManager.isGameInCollection(gameId: game.id)
        
        if isInCollection {
            try removeGame(withId: game.id)
            return false
        } else {
            try addGame(game)
            return true
        }
    }
    
    func isGameInCollection(withId id: Int) -> Bool {
        coreDataManager.isGameInCollection(gameId: id)
    }
    
    private func addGame(_ detail: BoardGameDetail) throws {
        let game = BoardGame(
            id: detail.id,
            name: detail.name,
            yearPublished: detail.yearPublished,
            thumbnailURL: detail.thumbnailURL,
            imageURL: detail.imageURL,
            rank: detail.rank ?? 0
        )
        
        try coreDataManager.addGameToCollection(game: game)
    }
    
    private func removeGame(withId id: Int) throws {
        try coreDataManager.removeGameFromCollection(gameId: id)
    }
    
}


