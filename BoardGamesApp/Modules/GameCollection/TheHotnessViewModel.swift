//
//  TheHotnessViewModel.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 27.12.2025.
//

import Foundation
import SWXMLHash


final class TheHotnessViewModel: GameCollectionViewModelProtocol {
    
    weak var delegate: GameCollectionViewModelDelegate?
    
    private let apiService: APIServiceProtocol
    private(set) var games: [BoardGame] = []
    
    private var isFetching = false
    private var hasFetchedOnce = false
    private var lastFetchFailed = false
    
    var emptyViewState: EmptyViewState {
        return .noApiData
    }
        
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func fetchGames(forceRefresh: Bool = false) {
        
        if hasFetchedOnce && !forceRefresh && !lastFetchFailed {
            delegate?.viewModelDidUpdateGames()
            return
        }
        
        guard !isFetching else { return }
        
        isFetching = true
        
        apiService.fetchHotGames() { [weak self] result in
            guard let self else { return }
            
            self.isFetching = false
            
            DispatchQueue.main.async {
                switch result {
                case .success(let games):
                    self.games = games
                    self.hasFetchedOnce = true
                    self.lastFetchFailed = false
                    self.delegate?.viewModelDidUpdateGames()
                case .failure(let error):
                    self.lastFetchFailed = true
                    if !self.hasFetchedOnce {
                        self.games = []
                    }
                    self.delegate?.viewModel(didFailWithError: error)
                }
            }
        }
    }
}
