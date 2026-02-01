//
//  RSSParser.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 04.01.2026.
//

import Foundation
import SWXMLHash

final class RSSParser: NSObject {
    private var articles: [NewsArticle] = []
    
    private var currentElement = ""
    private var currentTitle = ""
    private var currentLink = ""
    private var currentDescription = ""
    private var currentPubDate = ""
    private var currentAuthor = ""
    private var currentImageURL = ""
    
    func parse(data: Data) -> [NewsArticle] {
        articles = []
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return articles
    }
}

extension RSSParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        
        
        if elementName == "item" {
            currentTitle = ""
            currentLink = ""
            currentDescription = ""
            currentPubDate = ""
            currentAuthor = ""
            currentImageURL = ""
        }
        
        if elementName == "enclosure" {
            if let imageURL = attributeDict["url"], attributeDict["type"]?.starts(with: "image") == true {
                currentImageURL = imageURL
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        print("FOUND CHARACTERS in <\(currentElement)>: \(trimmed)")
        
        switch currentElement {
        case "title":
            currentTitle += trimmed
        case "link":
            currentLink += trimmed
        case "description":
            currentDescription += trimmed
        case "pubDate":
            currentPubDate += trimmed
        case "author", "dc:creator":
            currentAuthor += trimmed
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let date = dateFormatter.date(from: currentPubDate) ?? Date()
            
            if currentImageURL.isEmpty {
                currentImageURL = currentDescription.extractImageURLs().first ?? ""
            }
            
            let article = NewsArticle(
                title: currentTitle,
                link: currentLink,
                description: currentDescription.stripHTML(),
                pubDate: date,
                author: currentAuthor.isEmpty ? nil : currentAuthor,
                imageURL: currentImageURL.isEmpty ? nil : currentImageURL
            )
            
            articles.append(article)
        }
    }
}

extension String {
    func stripHTML() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func extractImageURLs() -> [String] {
        let pattern = "<img[^>]+src=[\"']([^\"'>]+)[\"']"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let nsString = self as NSString
        let results = regex?.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length)) ?? []
        return results.map { nsString.substring(with: $0.range(at: 1)) }
    }
}
