//
//  BGGUrlBuilder.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 27.12.2025.
//

import Foundation

struct BGGUrlBuilder {
    func build(for endpoint: BGGEndpoint) -> URL? {
        let fullURL = endpoint.baseURL + endpoint.path
        
        guard var components = URLComponents(string: fullURL) else {
            return nil
        }
        
        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }
        
        return components.url
    }
}
