//
//  Constants.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import Foundation


struct Constants {
    static let heightForPopularMovieRow: CGFloat = 210
    static let heightForCastCell: CGFloat = 135
    static let widthForCastCell: CGFloat = 135
    static let entityNameForFavouriteCheck: String = "FavouriteMovie"
    static let keyValueForFavoriteCheck: String = "movieId"
    static let iconNameForFavouriteMovie: String = "heart.fill"
    static let iconNameForNotFavouriteMovie: String = "heart"
    static let searchTimerInterval: CGFloat = 0.5
    static let castCollectionViewRestorationId: String = "castForMovie"
    static let recommendedCollectionViewRestorationId: String = "recommendedForMovie"
}
