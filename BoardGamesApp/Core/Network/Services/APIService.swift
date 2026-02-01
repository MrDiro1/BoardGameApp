//
//  NetworkManager.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 26.12.2025.
//


import Foundation
import SWXMLHash

protocol APIServiceProtocol {
    func fetchHotGames(completion: @escaping (Result<[BoardGame], BGGError>) -> Void)
    func fetchGameDetails(id: Int, completion: @escaping (Result<BoardGameDetail, BGGError>) -> Void)
    func searchGames(query: String, completion: @escaping (Result<[SearchResult], BGGError>) -> Void)
    func fetchGamesDetails(ids: [Int], completion: @escaping (Result<[BoardGame], BGGError>) -> Void)
}

final class APIService: APIServiceProtocol {
    static let shared = APIService()
    
    private let urlBuilder = BGGUrlBuilder()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchHotGames(completion: @escaping (Result<[BoardGame], BGGError>) -> Void) {
        let endpoint = BGGEndpoint.hot(type: .boardgame)
        
        guard let url = urlBuilder.build(for: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        performArrayRequest(url: url, completion: completion)
    }
    
    func fetchGameDetails(id: Int, completion: @escaping (Result<BoardGameDetail, BGGError>) -> Void) {
        let endpoint = BGGEndpoint.thing(ids: [id], stats: true)
        
        guard let url = urlBuilder.build(for: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        performSingleRequest(url: url, completion: completion)
    }
    
    func fetchGamesDetails(ids: [Int], completion: @escaping (Result<[BoardGame], BGGError>) -> Void) {
        let endpoint = BGGEndpoint.thing(ids: ids, stats: false)
        
        guard let url = urlBuilder.build(for: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        performRequest(url: url) { result in
            switch result {
            case .success(let data):
                let xml = XMLHash.parse(data)
                let items = BoardGame.parseFromThingAPI(xml: xml)
                
                if items.isEmpty {
                    completion(.failure(.noData))
                } else {
                    completion(.success(items))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchGames(query: String, completion: @escaping (Result<[SearchResult], BGGError>) -> Void) {
        let endpoint = BGGEndpoint.search(query: query, type: .boardgame)
        
        guard let url = urlBuilder.build(for: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        performRequest(url: url) { result in
            switch result {
            case .success(let data):
                let xml = XMLHash.parse(data)
                let items = SearchResult.parse(from: xml)
                completion(.success(items))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    private func performRequest(
        url: URL,
        completion: @escaping (Result<Data, BGGError>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.applyDefaultHeaders()
        
        let task = session.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 401:
                    completion(.failure(.unauthorized))
                    return
                case 429:
                    completion(.failure(.rateLimitExceeded))
                    return
                default:
                    break
                }
            }
            
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    private func performArrayRequest<T: XMLObjectDeserialization>(
        url: URL,
        completion: @escaping (Result<[T], BGGError>) -> Void
    ) {
        performRequest(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let xml = XMLHash.parse(data)
                    let items: [T] = try xml["items"]["item"].value()
                    completion(.success(items))
                } catch {
                    completion(.failure(.parsingError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func performSingleRequest<T: XMLObjectDeserialization>(
        url: URL,
        completion: @escaping (Result<T, BGGError>) -> Void
    ) {
        performArrayRequest(url: url) { (result: Result<[T], BGGError>) in
            switch result {
            case .success(let items):
                guard let item = items.first else {
                    completion(.failure(.noData))
                    return
                }
                completion(.success(item))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
