//
//  CoreDataError.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 15.01.2026.
//

import Foundation

enum CoreDataError: LocalizedError {
    case saveFailed
    case fetchFailed
    case deleteFailed
    case entityNotFound
    
    var errorDescription: String? {
        switch self {
        case .saveFailed: return "Failed to save data"
        case .fetchFailed: return "Failed to fetch data"
        case .deleteFailed: return "Failed to delete data"
        case .entityNotFound: return "Entity not found"
        }
    }
}
