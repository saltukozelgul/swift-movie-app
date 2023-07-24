//
//  NetworkManager.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import Foundation
import Alamofire



class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init () {}
    
    // Get popular movies with AF
    func getPopularMovies(page: Int, completion: @escaping ([Movie]?, Int?) -> Void) {
        
        let dataDecoder = JSONDecoder()
        dataDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let url = NetworkConstants.popularMoviesUrl + "&page=\(page)"
        AF.request(url).responseDecodable(of: PopularMovies.self, decoder: dataDecoder) { (response) in
            
            guard let movies = response.value?.results else {
                completion(nil, nil)
                return
            }
            guard let maxPage = response.value?.totalPages else {
                completion(nil, nil)
                return
            }
            completion(movies,maxPage)
        }
    }
}
