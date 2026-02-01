//
//  BoardGameDetail.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 09.01.2026.
//

import Foundation
import SWXMLHash

struct BoardGameDetail: Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String?
    let yearPublished: Int?
    let minPlayers: Int?
    let maxPlayers: Int?
    let playingTime: Int?
    let minAge: Int?
    let thumbnailURL: String?
    let imageURL: String?
    
    let averageRating: Double?
    let usersRated: Int?
    let rank: Int?
    let complexity: Double?
    
    let designers: [String]
    let artists: [String]
    let publishers: [String]
    let categories: [String]
    let mechanics: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: BoardGameDetail, rhs: BoardGameDetail) -> Bool {
        lhs.id == rhs.id
    }
}

extension BoardGameDetail: XMLObjectDeserialization {
    static func deserialize(_ node: XMLIndexer) throws -> BoardGameDetail {
        let id: Int = try node.value(ofAttribute: "id")
        let name: String = try node["name"].withAttribute("type", "primary").value(ofAttribute: "value")
        let description: String? =  node["description"].element?.text
        let yearPublished: Int? = node["yearpublished"].value(ofAttribute: "value")
        
        let minPlayers: Int? = node["minplayers"].value(ofAttribute: "value")
        let maxPlayers: Int? = node["maxplayers"].value(ofAttribute: "value")
        let playingTime: Int? = node["playingtime"].value(ofAttribute: "value")
        let minAge: Int? = node["minage"].value(ofAttribute: "value")
        
        let thumbnailURL: String? = node["thumbnail"].element?.text
        let imageURL: String? = node["image"].element?.text
        
        let stats = node["statistics"]["ratings"]
        let averageRating: Double? = stats["average"].value(ofAttribute: "value")
        let usersRated: Int? = stats["usersrated"].value(ofAttribute: "value")
        let complexity: Double? = stats["averageweight"].value(ofAttribute: "value")
        
        let rank: Int? = try? stats["ranks"]["rank"]
            .withAttribute("type", "subtype")
            .withAttribute("id", "1")
            .value(ofAttribute: "value")
        
        let designers = extractLinks(from: node, type: "boardgamedesigner")
        let artists = extractLinks(from: node, type: "boardgameartist")
        let publishers = extractLinks(from: node, type: "boardgamepublisher")
        let categories = extractLinks(from: node, type: "boardgamecategory")
        let mechanics = extractLinks(from: node, type: "boardgamemechanic")
        
        return BoardGameDetail(
            id: id,
            name: name,
            description: description,
            yearPublished: yearPublished,
            minPlayers: minPlayers,
            maxPlayers: maxPlayers,
            playingTime: playingTime,
            minAge: minAge,
            thumbnailURL: thumbnailURL,
            imageURL: imageURL,
            averageRating: averageRating,
            usersRated: usersRated,
            rank: rank,
            complexity: complexity,
            designers: designers,
            artists: artists,
            publishers: publishers,
            categories: categories,
            mechanics: mechanics
        )
    }
    
    private static func extractLinks(from node: XMLIndexer, type: String) -> [String] {
        return (try? node["link"]
            .withAttribute("type", type)
            .all
            .compactMap { try? $0.value(ofAttribute: "value") as String }) ?? []
    }
}
