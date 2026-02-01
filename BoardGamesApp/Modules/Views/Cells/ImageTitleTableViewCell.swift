//
//  NewsTableViewCell.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 05.01.2026.
//

import UIKit

class ImageTitleTableViewCell: UITableViewCell {
    static let reuseID = "ImageTitleCell"
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = Constants.containerCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: Constants.titleFontWeight)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var leftSubtitleLabel: UILabel = makeInfoLabel()
    private lazy var rightSubtitleLabel: UILabel = makeInfoLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupContainer()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        titleLabel.text = nil
        leftSubtitleLabel.text = nil
        rightSubtitleLabel.text = nil
    }
    
    private func setupContainer() {
        contentView.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.containerVerticalPadding),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.containerVerticalPadding),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.containerHorizontalPadding),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.containerHorizontalPadding)
        ])
    }
    
    private func applyConstraints() {
        container.addSubviews(itemImageView, titleLabel, leftSubtitleLabel, rightSubtitleLabel)
        
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.imageLeadingPadding),
            itemImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.containerVerticalPadding),
            itemImageView.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -Constants.containerVerticalPadding),
            itemImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            itemImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.titleTopPadding),
            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: Constants.titleLeadingPadding),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Constants.titleTrailingPadding),
            
            leftSubtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.authorTopPadding),
            leftSubtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            leftSubtitleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.authorBottomPadding),
            
            rightSubtitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Constants.dateTrailingPadding),
            rightSubtitleLabel.centerYAnchor.constraint(equalTo: leftSubtitleLabel.centerYAnchor)
        ])
    }
    
    private func makeInfoLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.authorFontSize, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func configure(with model: ImageTitleCellModel) {
        titleLabel.text = model.title
        leftSubtitleLabel.text = model.leftSubtitle
        rightSubtitleLabel.text = model.rightSubtitle
        
        if let imageURLString = model.imageURL,
           let url = URL(string: imageURLString) {
            itemImageView.loadImage(from: url)
        } else {
            itemImageView.image = nil
        }
    }
}



private extension ImageTitleTableViewCell {
     enum Constants {
        static let containerCornerRadius: CGFloat = 12
        static let containerHorizontalPadding: CGFloat = 16
        static let containerVerticalPadding: CGFloat = 8
        
        static let imageSize: CGFloat = 80
        static let imageCornerRadius: CGFloat = 8
        static let imageLeadingPadding: CGFloat = 8
        
        static let titleFontSize: CGFloat = 16
        static let titleFontWeight: UIFont.Weight = .semibold
        static let titleTopPadding: CGFloat = 8
        static let titleLeadingPadding: CGFloat = 8
        static let titleTrailingPadding: CGFloat = 8
        
        static let authorFontSize: CGFloat = 12
        static let authorTopPadding: CGFloat = 4
        static let authorBottomPadding: CGFloat = 8
        
        static let dateTrailingPadding: CGFloat = 8
    }
}

