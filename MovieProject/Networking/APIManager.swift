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
        defer {
            self.components.queryItems?.removeLast()
        }
        self.components.path = "/3/movie/\(movieId)"
        self.components.queryItems?.append(URLQueryItem(name: "append_to_response", value: "watch/providers,recommendations,videos"))
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
        defer {
            self.components.queryItems?.removeLast()
        }
        self.components.path = "/3/movie/popular"
        self.components.queryItems?.append(URLQueryItem(name: "page", value: String(page)))
        if let componentsUrl = self.components.url {
            return componentsUrl
        }
        return URL(string: "")
    }
    
    func getPersonDetailUrl(personId: Int) -> URL? {
        defer {
            self.components.queryItems?.removeLast()
        }
        self.components.path = "/3/person/\(personId)"
        self.components.queryItems?.append(URLQueryItem(name: "append_to_response", value: "movie_credits"))
        if let componentsUrl = self.components.url {
            return componentsUrl
        }
        return URL(string: "")
    }
    
    func getSearchUrl(query: String, page: Int) -> URL? {
        defer {
            self.components.queryItems?.removeLast(2)
        }
        self.components.path = "/3/search/movie"
        self.components.queryItems?.append(URLQueryItem(name: "query", value: query))
        self.components.queryItems?.append(URLQueryItem(name: "page", value: String(page)))
        if let componentsUrl = self.components.url {
            return componentsUrl
        }
        return URL(string: "")
    }
    
    //relase date.gte/lte vote_average.gte/lte witn_genres with_runtime.lte/gte
    func getDiscoverMoviesUrl(page: Int, genre: String, releaseDateGte: String, releaseDateLte: String, voteAverageGte: String, voteAverageLte: String, sorting: MovieListSortingOptions = .popularityDesc) -> URL? {
        defer {
            self.components.queryItems?.removeLast(7)
        }
        switch sorting {
            case .popularityDesc:
                self.components.queryItems?.append(URLQueryItem(name: "sort_by", value: "popularity.desc"))
            case .voteCountDesc:
                self.components.queryItems?.append(URLQueryItem(name: "sort_by", value: "vote_count.desc"))
            case .releaseDateDesc:
                self.components.queryItems?.append(URLQueryItem(name: "sort_by", value: "release_date.desc"))
            case .voteAverageDesc:
                self.components.queryItems?.append(URLQueryItem(name: "sort_by", value: "vote_average.desc"))
            case .popularityAsc:
                self.components.queryItems?.append(URLQueryItem(name: "sort_by", value: "popularity.asc"))
            case .voteCountAsc:
                self.components.queryItems?.append(URLQueryItem(name: "sort_by", value: "vote_count.asc"))
            case .releaseDateAsc:
                self.components.queryItems?.append(URLQueryItem(name: "sort_by", value: "release_date.asc"))
            case .voteAverageAsc:
                self.components.queryItems?.append(URLQueryItem(name: "sort_by", value: "vote_average.asc"))
        }
        self.components.path = "/3/discover/movie"
        self.components.queryItems?.append(URLQueryItem(name: "page", value: String(page)))
        self.components.queryItems?.append(URLQueryItem(name: "with_genres", value: genre))
        self.components.queryItems?.append(URLQueryItem(name: "release_date.gte", value: releaseDateGte))
        self.components.queryItems?.append(URLQueryItem(name: "release_date.lte", value: releaseDateLte))
        self.components.queryItems?.append(URLQueryItem(name: "vote_average.gte", value: voteAverageGte))
        self.components.queryItems?.append(URLQueryItem(name: "vote_average.lte", value: voteAverageLte))
        
        if let componentsUrl = self.components.url {
            return componentsUrl
        }
        return URL(string: "")
    }
    
    func getGenreUrl() -> URL? {
        defer {
            self.components.queryItems?.removeLast()
        }
        self.components.path = "/3/genre/movie/list"
        // update language component with prefix of previous language
        self.components.queryItems?.append(URLQueryItem(name: "language", value: String(NetworkConstants.isoCode.prefix(2))))
        if let componentsUrl = self.components.url {
            return componentsUrl
        }
        return URL(string: "")
    }
    
    
}
