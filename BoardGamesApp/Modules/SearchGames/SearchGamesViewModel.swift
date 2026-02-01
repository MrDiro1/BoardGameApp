//
//  SearchGamesViewModel.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 23.01.2026.
//

import Foundation

protocol SearchGamesViewModelDelegate: AnyObject {
    func viewModelDidUpdateResults()
    func viewModel(didFailWithError error: Error)
    func viewModelDidStartLoading()
    func viewModelDidFinishLoading()
}

protocol SearchGamesViewModelProtocol: AnyObject {
    var games: [BoardGame] { get }
    var hasMoreGames: Bool { get }
    
    var delegate: SearchGamesViewModelDelegate? { get set }
    
    func search(query: String)
    func loadNextPage()
    func clearResult()
}

final class SearchGamesViewModel: SearchGamesViewModelProtocol {
    
    weak var delegate: SearchGamesViewModelDelegate?
    private let apiService: APIServiceProtocol
    
    private(set) var games: [BoardGame] = []
    private var searchResults: [SearchResult] = []
    
    private var currentPage = 0
    private let gamesPerPage = 20
    private var isLoading = false
    private(set) var hasMoreGames = false
    
    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }
    
    func search(query: String) {
        guard !query.isEmpty else {
            clearResult()
            return
        }
        
        guard !isLoading else { return }
        
        isLoading = true
        delegate?.viewModelDidStartLoading()
        
        apiService.searchGames(query: query) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.delegate?.viewModelDidFinishLoading()
                
                switch result {
                case .success(let results):
                    self.searchResults = results
                    self.currentPage = 0
                    self.games = []
                    self.hasMoreGames = !results.isEmpty
                    
                    if results.isEmpty {
                        self.delegate?.viewModelDidUpdateResults()
                    } else {
                        self.loadNextPage()
                    }
                    
                case .failure(let error):
                    self.searchResults = []
                    self.games = []
                    self.delegate?.viewModel(didFailWithError: error)
                }
            }
        }
    }
    
    func loadNextPage() {
        guard !isLoading, hasMoreGames else { return }
        
        let startIndex = currentPage * gamesPerPage
        let endIndex = min(startIndex + gamesPerPage, searchResults.count)
        
        guard startIndex < searchResults.count else {
            hasMoreGames = false
            return
        }
        
        let pageResults = Array(searchResults[startIndex..<endIndex])
        let ids = pageResults.map { $0.id }
        
        isLoading = true
        delegate?.viewModelDidStartLoading()
        
        apiService.fetchGamesDetails(ids: ids) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.delegate?.viewModelDidFinishLoading()
                
                switch result {
                case .success(let games):
                    self.games.append(contentsOf: games)
                    self.currentPage += 1
                    self.hasMoreGames = endIndex < self.searchResults.count
                    self.delegate?.viewModelDidUpdateResults()
                case .failure(let error):
                    self.delegate?.viewModel(didFailWithError: error)
                }
            }
        }
    }
    
    func clearResult() {
        games = []
        searchResults = []
        currentPage = 0
        hasMoreGames = false
        delegate?.viewModelDidUpdateResults()
    }
    
}
