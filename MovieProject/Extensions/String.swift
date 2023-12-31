//
//  String.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 24.07.2023.
//

import Foundation

extension String {
    
    func convertToShortNumberFormat() -> String {
        guard let number = Double(self) else {
            return "0"
        }
        
        var convertedString = ""
        let suffixes = ["", "K", "M", "B", "T", "P", "E", "Z", "Y"]
        
        var index = 0
        var num = number
        while num >= 1000 && index < suffixes.count - 1 {
            num /= 1000
            index += 1
        }
        
        convertedString = String(format: "%.1f", num) + suffixes[index]
        return convertedString
    }
    
    // This function is useful on discover page. Because we need to send date in format of "yyyy-MM-dd" to API.
    func toApiDateFormat(month: String = "01", day: String = "01") -> String {
        return "\(self)-\(month)-\(day)"
    }
}
