//
//  File.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 31.07.2023.
//

import UIKit

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case castCollectionView:
                return castList?.count ?? 0
            case recommendationCollectionView:
                return detailedMovie?.recommendations?.results?.count ?? 0
            case productionCompaniesCollectionView:
                return detailedMovie?.productionCompanies?.count ?? 0
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            case castCollectionView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CastCollectionViewCell.self), for: indexPath) as? CastCollectionViewCell else { return UICollectionViewCell()}
                if let cast = castList?[indexPath.row] {
                    cell.configure(with: cast)
                }
                return cell
            case recommendationCollectionView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RecommendedCollectionViewCell.self), for: indexPath) as? RecommendedCollectionViewCell else { return UICollectionViewCell()}
                if let recommendation = detailedMovie?.recommendations?.results?[indexPath.row] {
                    cell.configure(recommendation)
                }
                return cell
            case productionCompaniesCollectionView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductionCompanyCollectionViewCell.self), for: indexPath) as? ProductionCompanyCollectionViewCell else { return UICollectionViewCell()}
                if let productionCompany = detailedMovie?.productionCompanies?[indexPath.row] {
                    cell.configure(with: productionCompany)
                }
                return cell
            default:
                return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            case recommendationCollectionView:
                if let recommendation = detailedMovie?.recommendations?.results?[indexPath.row] {
                    navigateToMovieDetail(movie: recommendation)
                }
            case castCollectionView:
                if let cast = castList?[indexPath.row] {
                    navigateToCastDetail(cast: cast)
                }
            default:
                break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
            case castCollectionView:
                return CGSize(width: TableConstants.widthForCastCell , height: TableConstants.heightForCastCell)
            case recommendationCollectionView:
                return CGSize(width: TableConstants.widthForRecommendedCell , height: TableConstants.heightForRecommendedCell)
            case productionCompaniesCollectionView:
                return CGSize(width: TableConstants.widthForProductionCompanyCell , height: TableConstants.heightForProductionCompanyCell)
            default:
                return .zero
        }
    }
}
