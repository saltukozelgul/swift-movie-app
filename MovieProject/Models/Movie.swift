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
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}

