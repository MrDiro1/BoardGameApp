//
//  BGGError.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 27.12.2025.
//

import Foundation

enum BGGError: Error {
    case invalidURL
    case noData
    case parsingError
    case networkError(Error)
    case unauthorized
    case rateLimitExceeded
}

extension BGGError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .noData:
            return "No data received from server"
        case .parsingError:
            return "Failed to parse server response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unauthorized:
            return "Authorization failed. Please check your API token."
        case .rateLimitExceeded:
            return "Too many requests. Please try again later."
        }
    }
}
