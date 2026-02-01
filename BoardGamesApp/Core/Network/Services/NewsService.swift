//
//  NewsService.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 04.01.2026.
//

import Foundation

protocol NewsServiceProtocol {
    func fetchNews(completion: @escaping (Result<[NewsArticle], NewsError>) -> Void)
}

final class NewsService: NewsServiceProtocol {
    static let shared = NewsService()
    
    private let urlBuilder = BGGUrlBuilder()
    private let session: URLSession
    private let parser = RSSParser()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchNews(completion: @escaping (Result<[NewsArticle], NewsError>) -> Void) {
        let endpoint = BGGEndpoint.rssNews
        
        guard let url = urlBuilder.build(for: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, _, error in
            if let error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            guard let self = self else {
                return
            }
            
            let articles = parser.parse(data: data)
            
            if articles.isEmpty {
                completion(.failure(.parsingError))
                return
            } else {
                completion(.success(articles))
            }
        }
        
        task.resume()
    }
}
