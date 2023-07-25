//
//  NetworkUrlBuilder.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 25.07.2023.
//

import Foundation

struct NetworkUrlBuilder {
    static func getMovieDetailUrl(movieId: Int) -> String {
        return "\(NetworkConstants.movieDetailUrl)\(movieId)\(NetworkConstants.suffixUrl)"
    }
    
    static func getMovieCastUrl(movieId: Int) -> String {
        return "\(NetworkConstants.movieDetailUrl)\(movieId)\(NetworkConstants.creditSuffix)"
    }
    
    static func getPopularMoviesUrl(page: Int) -> String {
        return "\(NetworkConstants.popularMoviesUrl)" + "&page=\(page)"
    }
}
