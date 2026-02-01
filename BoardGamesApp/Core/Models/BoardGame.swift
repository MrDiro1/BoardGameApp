//
//  Game.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 26.12.2025.
//

import Foundation
import SWXMLHash

struct BoardGame: Identifiable, Hashable {
    let id: Int
    let name: String
    let yearPublished: Int?
    let thumbnailURL: String?
    let imageURL: String?
    let rank: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: BoardGame, rhs: BoardGame) -> Bool {
        lhs.id == rhs.id
    }
}

extension BoardGame: XMLObjectDeserialization {
    nonisolated static func deserialize(_ node: XMLIndexer) throws -> BoardGame {
        return try BoardGame(
            id: node.value(ofAttribute: "id"),
            name: node["name"].value(ofAttribute: "value"),
            yearPublished: node["yearpublished"].value(ofAttribute: "value"),
            thumbnailURL: node["thumbnail"].value(ofAttribute: "value"),
            imageURL: node["image"].value(ofAttribute: "value"),
            rank: node.value(ofAttribute: "rank")
        )
    }
}

extension BoardGame {
    static func parseFromThingAPI(xml: XMLIndexer) -> [BoardGame] {
        return xml["items"]["item"].all.compactMap { item -> BoardGame? in
            guard let idString = item.element?.attribute(by: "id")?.text,
                  let id = Int(idString) else {
                return nil
            }
            
            var name: String?
            
            for nameNode in item["name"].all {
                if nameNode.element?.attribute(by: "type")?.text == "primary",
                   let value = nameNode.element?.attribute(by: "value")?.text {
                    name = value
                    break
                }
            }
            
            if name == nil {
                name = item["name"].element?.attribute(by: "value")?.text
            }
            
            guard let gameName = name else {
                return nil
            }
            
            let thumbnail = item["thumbnail"].element?.text
            let image = item["image"].element?.text
            
            let yearString = item["yearpublished"].element?.attribute(by: "value")?.text
            let year = yearString.flatMap { Int($0) }
            
            let rank = 0
            
            return BoardGame(
                id: id,
                name: gameName,
                yearPublished: year,
                thumbnailURL: thumbnail,
                imageURL: image,
                rank: rank
            )
        }
    }
}
