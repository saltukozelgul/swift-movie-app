//
//  File.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 26.07.2023.
//

import Foundation

extension Date {
    
    func getOnlyYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    func getFullDateWithLocale() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: NSLocalizedString("isoCode", comment: "language code"))
        return dateFormatter.string(from: self)
    }
    
    func getMonthAndYearWithLocale() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = Locale(identifier: NSLocalizedString("isoCode", comment: "language code"))
        return dateFormatter.string(from: self)
    }
    
    
    
}
