//
//  SearchGamesViewController.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 24.12.2025.
//

import UIKit

class SearchGamesViewController: UIViewController {

    private let viewModel: SearchGamesViewModelProtocol
    private var resultsViewController: SearchResultsViewController?
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Board Game Name..."
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: Constants.textFieldFontSize)
        textField.autocorrectionType = .no
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var searchButton = UIButton.makeActionButton(title: "Search", backgroundColor: .systemGreen, contentInsets: Constants.buttonContentInsets)
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Search for your favorite board games"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: Constants.placeholderFontSize, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var coordinator: SearchNavigatableProtocol?
    
    init(viewModel: SearchGamesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupGestures()
    }
    
    private func setupUI() {
        configureViewController()
        view.addSubviews(searchTextField, searchButton, placeholderLabel)
        applyConstraints()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Search Games"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.textFieldTopPadding),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            searchTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: Constants.buttonTopPadding),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.placeholderHorizontalPadding),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.placeholderHorizontalPadding)
        ])
    }
    
    private func setupActions() {
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        searchTextField.delegate = self
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func searchTapped() {
        performSearch()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func performSearch() {
        guard let query = searchTextField.text, !query.isEmpty else { return }
        
        searchTextField.resignFirstResponder()
        coordinator?.showSearchResults(query: query, viewModel: viewModel)
    }
}

extension SearchGamesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        return true
    }
}

private extension SearchGamesViewController {
    enum Constants {
        static let textFieldTopPadding: CGFloat = 20
        static let horizontalPadding: CGFloat = 20
        static let textFieldHeight: CGFloat = 50
        static let textFieldFontSize: CGFloat = 17
        
        static let buttonTopPadding: CGFloat = 16
        static let buttonWidth: CGFloat = 120
        static let buttonContentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 20,
            bottom: 12,
            trailing: 20
        )
 
        
        static let placeholderHorizontalPadding: CGFloat = 40
        static let placeholderFontSize: CGFloat = 18
    }
}
