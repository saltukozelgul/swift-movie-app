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
    
    private var dataDecoder = JSONDecoder()
    private var dateFormatter = DateFormatter()
    
    private init () {
        dataDecoder.keyDecodingStrategy = .convertFromSnakeCase
        dataDecoder.dateDecodingStrategy = .custom(customDateDecoder(_:))
    }
    
    func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url).responseDecodable(of: T.self, decoder: dataDecoder) { (response) in
            guard let data = response.value else {
                completion(.failure(response.error ?? AFError.explicitlyCancelled))
                return
            }
            completion(.success(data))
        }
    }
    
    private func customDateDecoder(_ decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return Date.distantPast
        }
    }
}


