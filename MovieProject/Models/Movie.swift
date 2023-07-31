//
//  Movie.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import Foundation

struct Movie: Codable {
    let id: Int?
    let posterPath: String?
    let title: String?
    let backdropPath: String?
    let originalTitle: String?
    let originalLanguage: String?
    let releaseDate: Date?
    let budget: Int?
    let revenue: Int?
    let homepage: String?
    let overview: String?
    let runtime: Int?
    let genres: [Genre]?
    let productionCompanies: [ProductionCompany]?
    let recommendations: [Movie]?
    let voteAverage: Double?
    let watchProviders: WatchProviders?
    
    //Api is returnin watch/providers we have to convert it to watchProviders
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath
        case title
        case backdropPath
        case originalTitle
        case originalLanguage
        case releaseDate
        case budget
        case revenue
        case homepage
        case overview
        case runtime
        case genres
        case productionCompanies
        case recommendations
        case voteAverage
        case watchProviders = "watch/providers"
    }
}


struct Genre: Codable {
    let id: Int?
    let name: String?
}

