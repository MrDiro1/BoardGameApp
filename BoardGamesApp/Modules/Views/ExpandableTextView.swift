//
//  ExpandableTextView.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 11.01.2026.
//

import UIKit

final class ExpandableTextView: UIView {
        
    private var isExpanded = false
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.fontSize)
        label.textColor = .secondaryLabel
        label.numberOfLines = Constants.maxLinesWhenCollapsed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var readMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.readMoreTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.fontSize, weight: .semibold)
        button.addTarget(self, action: #selector(toggleExpanded), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        addSubviews(textLabel, readMoreButton)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            readMoreButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: Constants.buttonSpacing),
            readMoreButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            readMoreButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func toggleExpanded() {
        isExpanded.toggle()
        
        UIView.animate(withDuration: Constants.animationDuration) {
            self.textLabel.numberOfLines = self.isExpanded ? 0 : Constants.maxLinesWhenCollapsed
            self.readMoreButton.setTitle(self.isExpanded ? Constants.readLessTitle : Constants.readMoreTitle, for: .normal)
            self.superview?.layoutIfNeeded()
        }
    }
    
    func configure(text: String?) {
        guard let text = text, !text.isEmpty else {
            textLabel.text = Constants.emptyStateText
            readMoreButton.isHidden = true
            return
        }
        
        let cleanedText = text.replacingOccurrences(of: "\n", with: " ")
        
        textLabel.text = cleanedText
        isExpanded = false
        textLabel.numberOfLines = Constants.maxLinesWhenCollapsed
        readMoreButton.setTitle(Constants.readMoreTitle, for: .normal)
        
        layoutIfNeeded()
        readMoreButton.isHidden = !textLabel.isTruncated()
    }
}

private extension ExpandableTextView {
    enum Constants {
        static let maxLinesWhenCollapsed = 3
        static let fontSize: CGFloat = 15
        static let buttonSpacing: CGFloat = 8
        static let animationDuration: TimeInterval = 0.3
        static let readMoreTitle = "Read more"
        static let readLessTitle = "Read less"
        static let emptyStateText = "No description available."
    }
}
