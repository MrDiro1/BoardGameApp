//
//  UIButton+Ext.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 27.01.2026.
//

import UIKit
import Foundation

extension UIButton {
    static func makeActionButton(
        title: String,
        backgroundColor: UIColor,
        fontSize: CGFloat = 16,
        contentInsets: NSDirectionalEdgeInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
    ) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = backgroundColor
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        configuration.contentInsets = contentInsets
        configuration.titleAlignment = .center
        configuration.titleLineBreakMode = .byWordWrapping
        
        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .semibold)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
}

