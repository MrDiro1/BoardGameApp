//
//  UILabel+Ext.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 11.01.2026.
//

import UIKit

extension UILabel {
    func isTruncated() -> Bool {
        guard let text = text, bounds.width > 0 else { return false }
        
        let textHeight = text.boundingRect(
            with: CGSize(width: bounds.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font!],
            context: nil
        ).height
        
        let maxHeight = font.lineHeight * CGFloat(numberOfLines)
        return textHeight > maxHeight
    }
}
