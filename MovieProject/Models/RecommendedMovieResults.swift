//
//  RecommendedMovieResults.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 31.07.2023.
//

import Foundation

struct RecommendedMovieResults: Codable{
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    var results: [Movie]?
}

