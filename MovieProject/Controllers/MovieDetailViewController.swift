//
//  MovieDetailViewController.swift
//  MovieProject
//
//  Created by Saltuk Bugra OZELGUL on 23.07.2023.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var movieId: Int?
    var detailedMovie: Movie?
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMovie()
    }
    
    func fetchMovie() {
        if let movieId {
            NetworkManager.shared.getMovieDetail(movieId: movieId) { movie in
                self.detailedMovie = movie
                self.updateUI()
            }
        }
    }
    
    func updateUI() {
        movieNameLabel.text = detailedMovie?.title
        moviePosterImageView.setImageFromPath(path: detailedMovie?.backdropPath ?? "unknown")
        
    }
    

}
