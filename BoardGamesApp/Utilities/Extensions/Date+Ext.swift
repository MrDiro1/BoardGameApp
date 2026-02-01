//
//  Date+Ext.swift
//  BoardGamesApp
//
//  Created by Володимир Гончарук on 05.01.2026.
//

import Foundation

extension Date {
    func toDisplayString(format: String = "dd.MM.yyyy, HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
}
