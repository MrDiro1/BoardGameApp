//
//  SearchResult.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 22.01.2026.
//

import SWXMLHash
import Foundation

struct SearchResult: Identifiable, Hashable {
    let id: Int
    let name: String
    let yearPublished: Int?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.id == rhs.id
    }
}

extension SearchResult: XMLObjectDeserialization {
    static func deserialize(_ node: XMLIndexer) throws -> SearchResult {
        let id: Int = try node.value(ofAttribute: "id")
        
        let nameValue: String
        do {
            nameValue = try node["name"].withAttribute("type", "primary").value(ofAttribute: "value")
        } catch {
            nameValue = try node["name"].value(ofAttribute: "value")
        }
        
        let year: Int? =  node["yearpublished"].value(ofAttribute: "value")
        
        return SearchResult(
            id: id,
            name: nameValue,
            yearPublished: year
        )
    }
}

extension SearchResult {
    static func parse(from xml: XMLIndexer) -> [SearchResult] {
        return xml["items"]["item"].all.compactMap { item -> SearchResult? in
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
            
            let yearString = item["yearpublished"].element?.attribute(by: "value")?.text
            let year = yearString.flatMap { Int($0) }
            
            return SearchResult(id: id, name: gameName, yearPublished: year)
        }
    }
}
