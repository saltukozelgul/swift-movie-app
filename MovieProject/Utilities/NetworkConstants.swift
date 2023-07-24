//
//  NetworkConstants.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import Foundation

struct NetworkConstants {
    static let apiKey = "e17c0c151bd8b342a611a49b92e038bc"
    static let baseUrl = "https://api.themoviedb.org/3"
    static let baseImageUrl = "https://image.tmdb.org/t/p/w500"
    static let popularMoviesUrl = "\(baseUrl)/movie/popular?api_key=\(apiKey)&language=en-US&"

}
