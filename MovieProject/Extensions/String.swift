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
}
