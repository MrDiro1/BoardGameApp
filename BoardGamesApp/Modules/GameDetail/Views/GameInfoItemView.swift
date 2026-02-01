//
//  GameInfoItemView.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 10.01.2026.
//

import UIKit

final class GameInfoItemView: UIView {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .semibold)
        label.textColor = .white.withAlphaComponent(Constants.whiteAlpha)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.valueFontSize, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(icon: UIImage?, title: String) {
        super.init(frame: .zero)
        iconImageView.image = icon
        titleLabel.text = title
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(iconImageView, titleLabel, valueLabel)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.minWidth),
            
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.iconSize),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: Constants.iconTitleSpacing),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.titleValueSpacing),
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(value: String) {
        valueLabel.text = value
    }
}

private extension GameInfoItemView {
    enum Constants {
        static let minWidth: CGFloat = 44
        static let iconSize: CGFloat = 20
        static let titleFontSize: CGFloat = 10
        static let valueFontSize: CGFloat = 14
        static let iconTitleSpacing: CGFloat = 4
        static let titleValueSpacing: CGFloat = 2
        static let whiteAlpha: CGFloat = 0.8
    }
}
