//
//  MovieSearchResults.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import Foundation

struct MovieSearchResult: Codable{
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [Movie]?
}
