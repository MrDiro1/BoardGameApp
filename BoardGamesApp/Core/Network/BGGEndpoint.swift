//
//  BGGEndpoint.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 27.12.2025.
//

import Foundation

enum BGGEndpoint {
    case hot(type: BGGItemType)
    case search(query: String, type: BGGItemType)
    case thing(ids: [Int], stats: Bool)
    case rssNews
}

extension BGGEndpoint {
    
    var baseURL: String {
        switch self {
        case .rssNews:
            return "https://boardgamegeek.com"
        default:
            return "https://boardgamegeek.com/xmlapi2"
        }
    }
    
    var path: String {
        switch self {
        case .hot:
            return "/hot"
        case .search:
            return "/search"
        case .thing:
            return "/thing"
        case .rssNews:
            return "/rss/blog/1"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
            
        case .hot(let type):
            return [
                URLQueryItem(name: "type", value: type.rawValue)
            ]
            
        case .search(let query, let type):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "type", value: type.rawValue)
            ]
            
        case .thing(let ids, let stats):
            return [
                URLQueryItem(name: "id", value: ids.map(String.init).joined(separator: ",")),
                URLQueryItem(name: "stats", value: stats ? "1" : "0")
            ]
            
        case .rssNews:
            return []
        }
    }
}

enum BGGItemType: String {
    case boardgame
    case boardgameexpansion
    case boardgameaccessory
}
