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
    // get from Localizable.strings key isoCode
    static let isoCode = NSLocalizedString("isoCode", comment: "iso code for api for localization")
    static let suffixUrl = "?api_key=\(apiKey)&language=\(isoCode)"
    static let popularMoviesUrl = "\(baseUrl)/movie/popular\(suffixUrl)"
    static let movieDetailUrl = "\(baseUrl)/movie/"
    static let personDetailUrl = "\(baseUrl)/person/"
    static let creditSuffix = "/credits\(suffixUrl)"
    
    
    static func getMovieDetailUrl(movieId: Int) -> String {
        return "\(movieDetailUrl)\(movieId)\(suffixUrl)"
    }
    
    static func getMovieCastUrl(movieId: Int) -> String {
        return "\(movieDetailUrl)\(movieId)\(creditSuffix)"
    }
    
    static func getPopularMoviesUrl(page: Int) -> String {
        return "\(popularMoviesUrl)" + "&page=\(page)"
    }
}
