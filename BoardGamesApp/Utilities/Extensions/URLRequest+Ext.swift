//
//  URLRequest+Ext.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 02.01.2026.
//

import Foundation

extension URLRequest {
    mutating func applyDefaultHeaders() {
        self.setValue("Bearer \(APIConfig.bggAuthToken)", forHTTPHeaderField: "Authorization")
        self.setValue("BoardGamesApp/1.0", forHTTPHeaderField: "User-Agent")
        self.timeoutInterval = 30
    }
}
