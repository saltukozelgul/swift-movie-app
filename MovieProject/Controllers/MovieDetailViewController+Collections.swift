//
//  File.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 31.07.2023.
//

import UIKit

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.restorationIdentifier {
            case Constants.castCollectionViewRestorationId:
                return self.castList?.count ?? 0
            case Constants.recommendedCollectionViewRestorationId:
                return self.detailedMovie?.recommendations?.results?.count ?? 0
            default:
                return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.restorationIdentifier {
        case Constants.castCollectionViewRestorationId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CastCollectionViewCell.self), for: indexPath) as! CastCollectionViewCell
            if let cast = self.castList?[indexPath.row] {
                cell.configure(with: cast)
            }
            return cell
        case Constants.recommendedCollectionViewRestorationId:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RecommendedCollectionViewCell.self), for: indexPath) as! RecommendedCollectionViewCell
            if let recommendation = self.detailedMovie?.recommendations?.results?[indexPath.row] {
                cell.configure(recommendation)
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.restorationIdentifier == Constants.recommendedCollectionViewRestorationId {
            if let recommendation = self.detailedMovie?.recommendations?.results?[indexPath.row] {
                navigateToMovieDetail(movie: recommendation)
            }
        }
        else {
            if let cast = self.castList?[indexPath.row] {
                navigateToCastDetail(cast: cast)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.widthForCastCell , height: Constants.heightForCastCell)
    }
}
