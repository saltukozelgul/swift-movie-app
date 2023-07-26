//
//  UIViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 24.07.2023.
//

import Foundation
import UIKit


extension UIViewController {
    func navigateToMovieDetail(movie: Movie) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as! MovieDetailViewController
        vc.hidesBottomBarWhenPushed = true
        vc.movieId = movie.id
        vc.title = movie.title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToCastDetail(cast: Cast) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: CastDetailViewController.self)) as! CastDetailViewController
        vc.personId = cast.id
        vc.title = cast.name
        self.present(vc, animated: true, completion: nil)
    }
 
}
