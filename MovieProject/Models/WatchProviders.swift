//
//  WatchProviders.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 31.07.2023.
//

import Foundation

struct WatchProviders: Codable {
    let results: WatchProvider?
}

struct WatchProvider: Codable {
    let TR: WatchProviderDetail?
    let US: WatchProviderDetail?
    
    subscript(countryCode: String) -> WatchProviderDetail? {
        switch countryCode {
        case "TR":
            return TR
        case "US":
            return US
        default:
            return nil
        }
    }

}

struct WatchProviderDetail: Codable {
    let link: String?
    let flatrate: [WatchProviderItem]?
}

struct WatchProviderItem: Codable {
    let displayPriority: Int?
    let logoPath: String?
    let providerId: Int?
    let providerName: String?
}



