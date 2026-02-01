//
//  NewsArticle.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 04.01.2026.
//

import Foundation

struct NewsArticle: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let link: String
    let description: String
    let pubDate: Date
    let author: String?
    let imageURL: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
