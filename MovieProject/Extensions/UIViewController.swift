import Foundation
import UIKit

extension UIViewController {
    
    func navigateToViewController<T: UIViewController>(withIdentifier identifier: String, configure: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! T
        
        configure?(vc)
        
        if let vc = vc as? MovieDetailViewController {
            vc.hidesBottomBarWhenPushed = true
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentViewController<T: UIViewController>(withIdentifier identifier: String, configure: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! T
        
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
                vc.listName = name
                vc.listId = id
            }
        }
    }
}
