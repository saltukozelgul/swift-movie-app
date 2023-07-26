//
//  String.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 24.07.2023.
//

import Foundation

extension String {
    
    func convertToCurrency() -> String {
        // 1000 to K
        // 1000000 to M
        
        guard let number = Double(self) else {
            return "0"
        }
            
        var convertedString = ""
        if number >= 1000000 {
            convertedString = String(format: "%.1f", number/1000000) + "M"
        } else if number >= 1000 {
            convertedString = String(format: "%.1f", number/1000) + "K"
        } else {
            convertedString = self
        }
        
        return convertedString
    }
    
    func getLocalizedMonth(month: String) -> String {
        switch month {
            case "01":
                return NSLocalizedString("january", comment: "Firts month of year")
            case "02":
                return NSLocalizedString("february", comment: "Second month of year")
            case "03":
                return NSLocalizedString("march", comment: "Third month of year")
            case "04":
                return NSLocalizedString("april", comment: "Fourth month of year")
            case "05":
                return NSLocalizedString("may", comment: "Fifth month of year")
            case "06":
                return NSLocalizedString("june", comment: "Sixth month of year")
            case "07":
                return NSLocalizedString("july", comment: "Seventh month of year")
            case "08":
                return NSLocalizedString("august", comment: "Eighth month of year")
            case "09":
                return NSLocalizedString("september", comment: "Ninth month of year")
            case "10":
                return NSLocalizedString("october", comment: "Tenth month of year")
            case "11":
                return NSLocalizedString("november", comment: "Eleventh month of year")
            case "12":
                return NSLocalizedString("december", comment: "Twelfth month of year")
            default:
                return "unknown"
                
        }
    }

    
    func convertToLocalizedDateString() -> String {
        //    Write a functions that convert "2023-06-06" to Haziran 2023 or June 2023
        var splittedString = self.split(separator: "-").map(String.init)
        splittedString[1] = getLocalizedMonth(month: splittedString[1])
        return splittedString.reversed().joined(separator: " ")
    }
}
