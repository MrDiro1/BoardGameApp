//
//  UIHelper.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 25.12.2025.
//

import UIKit
import Foundation

enum UIHelper {
    static func createThreeColumnLayout(width: CGFloat) -> UICollectionViewFlowLayout {
        
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        
        let itemWidth = availableWidth / 3
        let itemHeight = itemWidth + 40
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: padding,
            left: padding,
            bottom: padding,
            right: padding
        )
        
        layout.minimumInteritemSpacing = minimumItemSpacing
        layout.minimumLineSpacing = minimumItemSpacing
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        return layout
    }
}

