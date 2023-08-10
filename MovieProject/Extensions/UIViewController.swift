import Foundation
import UIKit

extension UIViewController {
    
    func navigateToViewController<T: UIViewController>(withIdentifier identifier: String, configure: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? T else { return }
        
        configure?(vc)
        
        if let vc = vc as? MovieDetailViewController {
            vc.hidesBottomBarWhenPushed = true
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentViewController<T: UIViewController>(withIdentifier identifier: String, configure: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? T else { return }
        
        configure?(vc)
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func navigateToMovieDetail(movie: Movie) {
        navigateToViewController(withIdentifier: String(describing: MovieDetailViewController.self)) { (vc: MovieDetailViewController) in
            vc.movieId = movie.id
            vc.title = movie.title
        }
    }
    
    func navigateToCastDetail(cast: Cast) {
        presentViewController(withIdentifier: String(describing: CastDetailViewController.self)) { (vc: CastDetailViewController) in
            vc.delegate = self as? MovieDetailViewController
            vc.personId = cast.id
            vc.title = cast.name
        }
    }
    
    func navigateToCustomListDetail(list: CustomList) {
        navigateToViewController(withIdentifier: String(describing: CustomListViewController.self)) { (vc: CustomListViewController) in
            if let name = list.customListName, let id = list.customListId {
                if id == CustomListConstants.idForFavouritesList {
                    vc.title = NSLocalizedString("favList", comment: "a text for table name for favourites")
                } else {
                    vc.title = name
                }
                vc.listId = id
            }
        }
    }
    
    func navigateToDiscoverMovies(genre: String, releaseDateGte: String, releaseDateLte: String, voteAverageGte: String, voteAverageLte: String, sortingType: String) {
        navigateToViewController(withIdentifier: String(describing: DiscoverMoviesListController.self)) { (vc: DiscoverMoviesListController) in
            vc.genreString = genre
            vc.releaseDateLte = releaseDateLte
            vc.releaseDateGte = releaseDateGte
            vc.voteAverageLte = voteAverageLte
            vc.voteAverageGte = voteAverageGte
            vc.sortingTypeString = sortingType
        }
    }
    
}
