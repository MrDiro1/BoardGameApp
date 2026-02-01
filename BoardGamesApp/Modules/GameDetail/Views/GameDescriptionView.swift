//
//  GameDescriptionView.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 10.01.2026.
//

import UIKit

final class GameDescriptionView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.titleFontSize)
        label.text = "Description"
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expandableTextView = ExpandableTextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(titleLabel, expandableTextView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.topPadding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            
            expandableTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.titleDescriptionSpacing),
            expandableTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            expandableTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            expandableTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.bottomPadding)
        ])
    }
    
    func configure(description: String?) {
        expandableTextView.configure(text: description)
    }
}

private extension GameDescriptionView {
    enum Constants {
        static let topPadding: CGFloat = 24
        static let horizontalPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 24
        static let titleDescriptionSpacing: CGFloat = 12
        static let titleFontSize: CGFloat = 20
        static let descriptionFontSize: CGFloat = 15
    }
}
