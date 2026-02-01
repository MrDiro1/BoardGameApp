//
//  UIView+Layout.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 24.12.2025.
//

import UIKit
import Foundation

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func pinToEdges(
        of superview: UIView,
        insets: UIEdgeInsets = .zero,
        useSafeArea: Bool = false
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if useSafeArea {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: insets.top),
                leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: insets.left),
                trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -insets.right),
                bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom)
            ])
        } else {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
            ])
        }
    }
}
