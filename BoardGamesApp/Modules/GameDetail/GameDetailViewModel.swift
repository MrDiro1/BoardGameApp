//
//  GameDetailViewModel.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 08.01.2026.
//

import Foundation

protocol GameDetailViewModelDelegate: AnyObject {
    func viewModelDidUpdateGameDetails(_ viewModel: GameDetailViewModel)
    func viewModel(_ viewModel: GameDetailViewModel, didFailWithError error: Error)
}

protocol GameDetailViewModelProtocol: AnyObject {
    var gameDetail: BoardGameDetail? { get }
    
    var delegate: GameDetailViewModelDelegate? { get set }
    
    func fetchGameDetails()
    
    func isGameInCollection() -> Bool
    func toggleCollection() throws -> Bool
    func logPlay() throws
}

enum GameDetailViewModelError: Error {
    case gameNotLoaded
}

final class GameDetailViewModel: GameDetailViewModelProtocol {
    
    weak var delegate: GameDetailViewModelDelegate?
    private let apiService: APIServiceProtocol
    private let collectionService: GameCollectionServiceProtocol
    private let playService: PlayServiceProtocol
    private let gameId: Int
    
    private(set) var gameDetail: BoardGameDetail?
    
    private var isFetching = false
    
    init(
        gameId: Int,
        apiService: APIServiceProtocol = APIService.shared,
        collectionService: GameCollectionServiceProtocol = GameCollectionService(),
        playService: PlayServiceProtocol = PlayService()
    ) {
        self.gameId = gameId
        self.apiService = apiService
        self.collectionService = collectionService
        self.playService = playService
    }
    
    
    func fetchGameDetails() {
        guard !isFetching else { return }
        
        isFetching = true
        
        apiService.fetchGameDetails(id: gameId) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isFetching = false
                
                switch result {
                case .success(let detail):
                    self.gameDetail = detail
                    self.delegate?.viewModelDidUpdateGameDetails(self)
                case .failure(let error):
                    self.delegate?.viewModel(self, didFailWithError: error)
                }
            }
        }
    }
}

extension GameDetailViewModel {
    func isGameInCollection() -> Bool {
        guard let gameDetail else { return false }
        return collectionService.isGameInCollection(withId: gameDetail.id)
    }
    
    @discardableResult
    func toggleCollection() throws -> Bool {
        guard let gameDetail else {
            assertionFailure("toggleCollection called before game loaded")
            throw GameDetailViewModelError.gameNotLoaded
        }
        
        return try collectionService.toggleGameInCollection(gameDetail)
    }
    
    func logPlay() throws {
        guard let gameDetail else {
            assertionFailure("logPlay called before game loaded")
            throw GameDetailViewModelError.gameNotLoaded
        }
        
        try playService.logPlay(for: gameDetail)
    }
}
