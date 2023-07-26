//
//  Cast.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import Foundation

struct Cast: Codable {
    let id: Int?
    let name: String?
    let profilePath: String?
    let biography: String?
    let birthday: Date?
    let deathday: Date?
    let placeOfBirth: String?
    let character: String?
}
