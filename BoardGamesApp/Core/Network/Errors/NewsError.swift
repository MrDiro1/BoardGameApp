//
//  NewsError.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 04.01.2026.
//

import Foundation

enum NewsError: Error {
    case invalidURL
    case noData
    case parsingError
    case networkError(Error)
}

extension NewsError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .parsingError:
            return "Failed to parse RSS feed"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
