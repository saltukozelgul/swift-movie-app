//
//  NetworkUrlBuilder.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 25.07.2023.
//

import Foundation

class APIManager {
    
    private var components = URLComponents()
    static let shared = APIManager()
    
    private init() {
        self.components.scheme = "https"
        self.components.host = "api.themoviedb.org"
        self.components.queryItems = [
            URLQueryItem(name: "api_key", value: NetworkConstants.apiKey),
            URLQueryItem(name: "language", value: NetworkConstants.isoCode)
        ]
    }
    
    func getMovieDetailUrl(movieId: Int) -> URL? {
        self.components.path = "/3/movie/\(movieId)"
        if let componentsUrl = self.components.url {
            return componentsUrl
        }
        return URL(string: "")
    }
    
    func getMovieCastUrl(movieId: Int) -> URL? {
        self.components.path = "/3/movie/\(movieId)/credits"
        if let componentsUrl = self.components.url {
            return componentsUrl
        }
        return URL(string: "")
    }
    
    func getPopularMoviesUrl(page: Int) -> URL? {
        self.components.path = "/3/movie/popular"
        self.components.queryItems?.append(URLQueryItem(name: "page", value: String(page)))
        if let componentsUrl = self.components.url {
            return componentsUrl
        }
        defer {
            self.components.queryItems?.removeLast()
        }
        return URL(string: "")
    }
    
    func getPersonDetailUrl(personId: Int) -> URL? {
        self.components.path = "/3/person/\(personId)"
        if let componentsUrl = self.components.url {
            return componentsUrl
        }
        return URL(string: "")
    }
    
}
