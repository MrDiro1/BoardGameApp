//
//  YourProfileViewController.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 13.01.2026.
//

import UIKit

class YourProfileViewController: UIViewController {
    
    private enum Row: Int, CaseIterable {
        case myGames
        case myPlays
        
        var title: String {
            switch self {
            case .myGames: return "My Games"
            case .myPlays: return "My Plays"
            }
        }
    }
    
    weak var coordinator: YourProfileNavigatableProtocol?
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        configureViewController()
        configureTableView()
    }
    
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.pinToEdges(of: view)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension YourProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath
        )
        
        let row = Row.allCases[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = row.title
        cell.contentConfiguration = config
        
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .default
        
        return cell
    }
}

extension YourProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = Row.allCases[indexPath.row]
        
        switch row {
        case .myGames:
            coordinator?.showMyGames()
        case .myPlays:
            coordinator?.showMyPlays()
        }
    }
}
