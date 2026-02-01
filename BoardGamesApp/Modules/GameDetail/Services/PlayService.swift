//
//  PlayService.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 19.01.2026.
//

import Foundation

protocol PlayServiceProtocol {
    func logPlay(for game: BoardGameDetail) throws
}

final class PlayService: PlayServiceProtocol {
    
    private let coreDataManager: CoreDataManagerProtocol
    
    init(coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    func logPlay(for game: BoardGameDetail) throws {
        try coreDataManager.addPlayForGame(game)
    }
}
