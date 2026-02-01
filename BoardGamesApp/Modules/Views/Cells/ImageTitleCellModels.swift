//
//  ImageTitleCellModels.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 20.01.2026.
//

import Foundation

protocol ImageTitleCellModel {
    var imageURL: String? { get }
    var title: String { get }
    var leftSubtitle: String? { get }
    var rightSubtitle: String? { get }
}

extension NewsArticle: ImageTitleCellModel {
    var leftSubtitle: String? { author ?? "BGG News" }
    var rightSubtitle: String? { pubDate.toDisplayString() }
}

struct PlayRecordCellModel: ImageTitleCellModel {
    let play: PlayRecord
    
    var imageURL: String? { play.gameThumbnailURL }
    var title: String { play.gameName ?? "Unknown Game" }
    var leftSubtitle: String? {
        guard let date = play.lastPlayedDate else { return nil }
        return "Last: \(date.toDisplayString())"
    }
    var rightSubtitle: String? {
        "Plays: \(play.playCount)"
    }
}

