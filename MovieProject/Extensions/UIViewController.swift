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
        vc.movieId = movie.id
        vc.title = movie.title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
