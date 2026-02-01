//
//  GameCellCollectionViewCell.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 26.12.2025.
//

import UIKit

final class GameCollectionViewCell: UICollectionViewCell {
    static let reuseID = "GameCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Test Game"
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: Constants.titleFontSize, weight: Constants.titleFontWeight)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(imageView, titleLabel)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.titleTopPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
    
    func set(game: BoardGame) {
        titleLabel.text = game.name
        
        if let thumbnailURLString = game.thumbnailURL,
           let url = URL(string: thumbnailURLString) {
            imageView.loadImage(from: url)
        } else {
            imageView.image = nil
        }
    }
}

private extension GameCollectionViewCell {
     enum Constants {
        static let imageCornerRadius: CGFloat = 8
        static let titleFontSize: CGFloat = 16
        static let titleFontWeight: UIFont.Weight = .bold
        static let titleTopPadding: CGFloat = 4
    }
}
