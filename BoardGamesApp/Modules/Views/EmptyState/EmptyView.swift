//
//  EmptyStateView.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 27.01.2026.
//

import UIKit

class EmptyView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = SFSymbols.tray
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = .secondaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Constants.titleNumberOfLines
        label.textColor = .secondaryLabel
        label.font = .systemFont(
            ofSize: Constants.titleFontSize,
            weight: Constants.titleFontWeight
        )
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(imageView, titleLabel)
        applyConstraints()
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Constants.imageVerticalOffset),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.titleTopPadding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.titleHorizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.titleHorizontalPadding)
        ])
    }
    
    func configure(with state: EmptyViewState) {
        titleLabel.text = state.title
    }
}

private extension EmptyView {
    enum Constants {
        static let imageSize: CGFloat = 120
        static let imageVerticalOffset: CGFloat = -50
        
        static let titleTopPadding: CGFloat = 24
        static let titleHorizontalPadding: CGFloat = 40

        static let titleFontSize: CGFloat = 22
        static let titleFontWeight: UIFont.Weight = .semibold
        static let titleNumberOfLines = 0
    }
}

