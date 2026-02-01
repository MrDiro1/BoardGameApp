//
//  NewsViewModel.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 05.01.2026.
//

import Foundation
import SWXMLHash

protocol NewsViewModelDelegate: AnyObject {
    func viewModelDidUpdateNews(_ viewModel: NewsViewModel)
    func viewModel(_ viewModel: NewsViewModel, didFailWithError error: Error)
}

protocol NewsViewModelProtocol: AnyObject {
    var news: [NewsArticle] { get }
    var delegate: NewsViewModelDelegate? { get set }
    
    func fetchNews(forceRefresh: Bool)
    func refreshGames()
}

final class NewsViewModel: NewsViewModelProtocol {
    
    weak var delegate: NewsViewModelDelegate?
    
    private let newsService: NewsService
    private(set) var news: [NewsArticle] = []
    
    private var isFetching = false
    private var hasFetchedOnce = false
    
    init(newsService: NewsService = .shared) {
        self.newsService = newsService
    }
    
    func fetchNews(forceRefresh: Bool = false) {
        if hasFetchedOnce && !forceRefresh {
            delegate?.viewModelDidUpdateNews(self)
            return
        }
        
        guard !isFetching else { return }
        
        isFetching = true
        
        newsService.fetchNews { [weak self] result in
            guard let self = self else { return }
            
            self.isFetching = false
            
            DispatchQueue.main.async {
                switch result {
                case .success(let news):
                    self.news = news
                    self.hasFetchedOnce = true
                    self.delegate?.viewModelDidUpdateNews(self)
                case .failure(let error):
                    if !self.hasFetchedOnce {
                        self.news = []
                    }
                    self.delegate?.viewModel(self, didFailWithError: error)
                }
            }
        }
    }
    
    func refreshGames() {
        fetchNews(forceRefresh: true)
    }
}
