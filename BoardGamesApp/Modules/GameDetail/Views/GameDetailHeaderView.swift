//
//  GameDetailHeaderView.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 10.01.2026.
//

import UIKit

final class GameDetailHeaderView: UIView {
    
    private let headerImageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bigGameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(Constants.overlayAlpha)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private lazy var titleLabel = makeOverlayLabel(
        font: .boldSystemFont(ofSize: Constants.titleFontSize),
        numberOfLines: 2
    )
    
    private lazy var yearLabel = makeOverlayLabel(
        font: .systemFont(ofSize: Constants.yearFontSize, weight: .medium)
    )
    
    private let topRightInfoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.topStackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let bottomLeftInfoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.stackSpacing
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var rankInfoView = GameInfoItemView(icon: SFSymbols.rankingChart, title: "RANK")
    private lazy var ageInfoView = GameInfoItemView(icon: SFSymbols.person, title: "AGE")
    private lazy var timeInfoView = GameInfoItemView(icon: SFSymbols.clock, title: "TIME")
    private lazy var playersInfoView = GameInfoItemView(icon: SFSymbols.twoPersons, title: "PLAYERS")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerImageContainer)
        headerImageContainer.addSubviews(bigGameImageView, overlayView)
        
        overlayView.addSubviews(
            titleLabel,
            yearLabel,
            topRightInfoStack,
            bottomLeftInfoStack
        )
        
        topRightInfoStack.addArrangedSubview(rankInfoView)
        
        bottomLeftInfoStack.addArrangedSubview(ageInfoView)
        bottomLeftInfoStack.addArrangedSubview(timeInfoView)
        bottomLeftInfoStack.addArrangedSubview(playersInfoView)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            headerImageContainer.topAnchor.constraint(equalTo: topAnchor),
            headerImageContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImageContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerImageContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerImageContainer.heightAnchor.constraint(equalToConstant: Constants.headerHeight),
            
            bigGameImageView.topAnchor.constraint(equalTo: headerImageContainer.topAnchor),
            bigGameImageView.leadingAnchor.constraint(equalTo: headerImageContainer.leadingAnchor),
            bigGameImageView.trailingAnchor.constraint(equalTo: headerImageContainer.trailingAnchor),
            bigGameImageView.bottomAnchor.constraint(equalTo: headerImageContainer.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: bigGameImageView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: bigGameImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: bigGameImageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bigGameImageView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            titleLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -Constants.padding),
            
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.smallPadding),
            yearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            bottomLeftInfoStack.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: Constants.padding),
            bottomLeftInfoStack.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -Constants.padding),
            
            topRightInfoStack.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -Constants.padding),
            topRightInfoStack.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -Constants.padding)
        ])
    }
    
    private func makeOverlayLabel(font: UIFont, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = .white
        label.numberOfLines = numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func configure(with detail: BoardGameDetail) {
        titleLabel.text = detail.name
        yearLabel.text = detail.yearPublished.map { "(\($0))" } ?? ""
        
        if let imageURL = detail.imageURL, let url = URL(string: imageURL) {
            bigGameImageView.loadImage(from: url)
        }
        
        rankInfoView.configure(value: detail.rank.map { "#\($0)" } ?? "N/A")
        ageInfoView.configure(value: detail.minAge.map { "\($0)+" } ?? "N/A")
        timeInfoView.configure(value: detail.playingTime.map { "\($0)m" } ?? "N/A")
        
        let playersValue: String
        if let min = detail.minPlayers, let max = detail.maxPlayers {
            playersValue = min == max ? "\(min)" : "\(min)-\(max)"
        } else {
            playersValue = "N/A"
        }
        playersInfoView.configure(value: playersValue)
    }
}

private extension GameDetailHeaderView {
    enum Constants {
        static let headerHeight: CGFloat = 450
        static let overlayAlpha: CGFloat = 0.4
        static let titleFontSize: CGFloat = 28
        static let yearFontSize: CGFloat = 16
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 4
        static let stackSpacing: CGFloat = 8
        static let topStackSpacing: CGFloat = 16
    }
}
