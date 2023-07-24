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

    
    func convertToLocalizedDateString() -> String {
        //    Write a functions that convert "2023-06-06" to Haziran 2023 or June 2023
        let splittedString = self.split(separator: "-")
        let month = String(splittedString[1])
        
        switch month {
            case "01":
                return NSLocalizedString("january", comment: "Firts month of year") + " " + String(splittedString[0])
            case "02":
                return NSLocalizedString("february", comment: "Second month of year") + " " + String(splittedString[0])
            case "03":
                return NSLocalizedString("march", comment: "Third month of year") + " " + String(splittedString[0])
            case "04":
                return NSLocalizedString("april", comment: "Fourth month of year") + " " + String(splittedString[0])
            case "05":
                return NSLocalizedString("may", comment: "Fifth month of year") + " " + String(splittedString[0])
            case "06":
                return NSLocalizedString("june", comment: "Sixth month of year") + " " + String(splittedString[0])
            case "07":
                return NSLocalizedString("july", comment: "Seventh month of year") + " " + String(splittedString[0])
            case "08":
                return NSLocalizedString("august", comment: "Eighth month of year") + " " + String(splittedString[0])
            case "09":
                return NSLocalizedString("september", comment: "Ninth month of year") + " " + String(splittedString[0])
            case "10":
                return NSLocalizedString("october", comment: "Tenth month of year") + " " + String(splittedString[0])
            case "11":
                return NSLocalizedString("november", comment: "Eleventh month of year") + " " + String(splittedString[0])
            case "12":
                return NSLocalizedString("december", comment: "Twelfth month of year") + " " + String(splittedString[0])
            default:
                return "unknown"
                
        }
        
    }
}
