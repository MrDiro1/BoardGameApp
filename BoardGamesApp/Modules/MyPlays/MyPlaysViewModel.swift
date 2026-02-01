//
//  MyPlaysViewModel.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 19.01.2026.
//

import Foundation

protocol MyPlaysViewModelDelegate: AnyObject {
    func viewModelDidUpdatePlays()
    func viewModel(didFailWithError error: Error)
}

protocol MyPlaysViewModelProtocol: AnyObject {
    var plays: [PlayRecord] { get }
    
    var delegate: MyPlaysViewModelDelegate? { get set }
    
    func fetchPlays()
}

final class MyPlaysViewModel: MyPlaysViewModelProtocol {
    weak var delegate: MyPlaysViewModelDelegate?
    private let coreDataManager: CoreDataManagerProtocol
    
    private(set) var plays: [PlayRecord] = []
    
    init(coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchPlays() {
        do {
            plays = try coreDataManager.fetchAllPlays()
            delegate?.viewModelDidUpdatePlays()
        } catch {
            delegate?.viewModel(didFailWithError: error)
        }
    }
}
