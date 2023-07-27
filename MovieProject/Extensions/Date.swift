//
//  File.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 26.07.2023.
//

import Foundation

extension Date {
    
    private func formatDate(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: NSLocalizedString("isoCode", comment: "language code"))
        if (self == Date.distantPast) {
            return NSLocalizedString("notReleased", comment: "not released")
        }
        return dateFormatter.string(from: self)
    }
    
    func getOnlyYear() -> String {
        return formatDate(with: "yyyy")
    }
    
    func getFullDateWithLocale() -> String {
        return formatDate(with: "dd MMMM yyyy")
    }
    
    func getMonthAndYearWithLocale() -> String {
        return formatDate(with: "MMMM yyyy")
    }
}
