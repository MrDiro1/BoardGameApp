//
//  EmptyViewState.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 27.01.2026.
//

enum EmptyViewState {
    case noApiData
    case noCoreData
    case emptyCollection
    case emptyPlays

    var title: String {
        switch self {
        case .noApiData:
            return "Nothing found"
        case .noCoreData:
            return "No saved data yet"
        case .emptyCollection:
            return "Your game collection is empty"
        case .emptyPlays:
            return "No plays recorded yet"
        }
    }
}

