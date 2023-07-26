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
        
        func fetchData<T: Decodable>(url: String, completion: @escaping (Result<T, AFError>) -> Void) {
            let dataDecoder = JSONDecoder()
            dataDecoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(url).responseDecodable(of: T.self, decoder: dataDecoder) { (response) in
                guard let data = response.value else {
                    completion(.failure(response.error ?? AFError.explicitlyCancelled))
                    return
                }
                completion(.success(data))
            }
        }
    
}


