//
//  GameActionsView.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 12.01.2026.
//

import UIKit

protocol GameActionsViewDelegate: AnyObject {
    func gameActionsViewDidTappedAddTiCollection(_ view: GameActionsView)
    func gameActionsViewDidTappedAddToPlay(_ view: GameActionsView)
}

final class GameActionsView: UIView {
    
    weak var delegate: GameActionsViewDelegate?
    
    private lazy var addToCollectionButton = UIButton.makeActionButton(title: "Add to Collection", backgroundColor: .systemGreen, fontSize: Constants.buttonFontSize, contentInsets: Constants.buttonInsets)
    
    private lazy var addPlayButton = UIButton.makeActionButton(title: "Add Play", backgroundColor: .systemGreen, fontSize: Constants.buttonFontSize, contentInsets: Constants.buttonInsets)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(addToCollectionButton, addPlayButton)
        
        addToCollectionButton.addTarget(
            self,
            action: #selector(addToCollectionTapped),
            for: .touchUpInside
        )
        
        addPlayButton.addTarget(
            self,
            action: #selector(addToPlayTapped),
            for: .touchUpInside
        )
        
        NSLayoutConstraint.activate([
            addToCollectionButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.topPadding),
            addToCollectionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            addToCollectionButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            addToCollectionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.bottomPadding),
            
            addPlayButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.topPadding),
            addPlayButton.leadingAnchor.constraint(equalTo: addToCollectionButton.trailingAnchor, constant: Constants.buttonSpacing),
            addPlayButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            addPlayButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            addPlayButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.bottomPadding),
            
            addPlayButton.widthAnchor.constraint(equalTo: addToCollectionButton.widthAnchor)
        ])
        
    }
    
    @objc private func addToCollectionTapped() {
        delegate?.gameActionsViewDidTappedAddTiCollection(self)
    }
    
    @objc private func addToPlayTapped() {
        delegate?.gameActionsViewDidTappedAddToPlay(self)
    }
    
    func updateCollectionButtonState(isInCollection: Bool) {
        let title = isInCollection ? "Remove from Collection" : "Add to Collection"
        let color: UIColor = isInCollection ? .systemRed : .systemGreen
        
        var config = addToCollectionButton.configuration
        config?.title = title
        config?.baseBackgroundColor = color
        addToCollectionButton.configuration = config
    }
}

private extension GameActionsView {
    enum Constants {
        static let topPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 16
        static let buttonSpacing: CGFloat = 12
        
        static let buttonHeight: CGFloat = 50
        static let buttonFontSize: CGFloat = 16
        static let buttonInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 16,
            bottom: 12,
            trailing: 16
        )
    }
}
