//
//  PopularMovies.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import Foundation

struct PopularMovies: Codable {
    let page: Int?
    let totalPages: Int?
    let totalResults: Int?
    let results: [Movie]?
}
