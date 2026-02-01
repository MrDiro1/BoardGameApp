//
//  CoreDataManager.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 13.01.2026.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    func addPlayForGame(_ game: BoardGameDetail) throws
    func addGameToCollection(game: BoardGame) throws
    func removeGameFromCollection(gameId: Int) throws
    func isGameInCollection(gameId: Int) -> Bool
    func fetchAllGames() throws -> [BoardGame]
    func fetchAllPlays() throws -> [PlayRecord]
}

final class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BoardGamesApp")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    
    func addPlayForGame(_ game: BoardGameDetail) throws {
        let request: NSFetchRequest<PlayRecord> = PlayRecord.fetchRequest()
        request.predicate = NSPredicate(format: "gameId == %d", game.id)
        
        if let existingRecord = try context.fetch(request).first {
            existingRecord.playCount += 1
            existingRecord.lastPlayedDate = Date()
        } else {
            let record = PlayRecord(context: context)
            record.gameId = Int64(game.id)
            record.gameName = game.name
            record.gameImageURL = game.imageURL
            record.gameThumbnailURL = game.thumbnailURL
            record.playCount = 1
            record.firstPlayedDate = Date()
            record.lastPlayedDate = Date()
        }
        
        try saveContext()
    }
    
    func fetchAllPlays() throws -> [PlayRecord] {
        let request: NSFetchRequest<PlayRecord> = PlayRecord.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "gameName", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        ]
        
        do {
            return try context.fetch(request)
        } catch {
            throw CoreDataError.fetchFailed
        }
    }
    
    
    func addGameToCollection(game: BoardGame) throws {
        guard !isGameInCollection(gameId: game.id) else { return }
        
        let entity = GameEntity(context: context)
        entity.id = Int64(game.id)
        entity.name = game.name
        entity.thumbnailURL = game.thumbnailURL
        entity.imageURL = game.imageURL
        entity.addedDate = Date()
        
        try saveContext()
    }
    
    func removeGameFromCollection(gameId: Int) throws {
        guard let entity = try fetchGameEntity(withId: gameId) else {
            throw CoreDataError.deleteFailed
        }
        
        context.delete(entity)
        try saveContext()
    }
    
    func isGameInCollection(gameId: Int) -> Bool {
        (try? fetchGameEntity(withId: gameId)) != nil
    }
    
    func fetchAllGames() throws -> [BoardGame] {
        let entities = try fetchAllGameEntities()
        return entities.map { BoardGame(from: $0) }
    }
    
    
    private func fetchAllGameEntities() throws -> [GameEntity] {
        let request: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "addedDate", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            throw CoreDataError.fetchFailed
        }
    }
    
    private func fetchGameEntity(withId id: Int) throws -> GameEntity? {
        let request: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            throw CoreDataError.fetchFailed
        }
    }
    
    private func saveContext() throws {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            context.rollback()
            throw CoreDataError.saveFailed
        }
    }
}


extension BoardGame {
    init(from entity: GameEntity) {
        self.init(
            id: Int(entity.id),
            name: entity.name ?? "Unknown",
            yearPublished: nil,
            thumbnailURL: entity.thumbnailURL,
            imageURL: entity.imageURL,
            rank: 0
        )
    }
}
