//
//  Router.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 10/05/2021.
//

import Foundation
import UIKit

enum StoryBoardName :String {
    case Main =  "Main"
    case Authentication = "Authentication"
    case LaunchScreen =  "LaunchScreen"
}

extension UIStoryboard{
    
    static func mainStoryBoard() -> UIStoryboard {
         UIStoryboard(name:StoryBoardName.Main.rawValue, bundle: nil)
    }
}

extension UIViewController{
   
    func navigateToMovieDetailsViewController(movieID : Int, isSeries : Bool){
    
         guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: MovieDetailsViewController.identifier) as? MovieDetailsViewController else {return}
         
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.movieID = movieID
        vc.isSeries = isSeries
        self.navigationController?.pushViewController(vc, animated: true)
        // present(vc, animated: true)
    }
    func navigateToHalfMovieDetailsViewController(movieID : Int, isSeries : Bool){
    
         guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: MovieDetailsViewController.identifier) as? MovieDetailsViewController else {return}
         
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .crossDissolve
        vc.movieID = movieID
        vc.isSeries = isSeries
        self.navigationController?.pushViewController(vc, animated: true)
        // present(vc, animated: true)
    }
    
    func navigateToActorDetailsViewController(id : Int){
    
         guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: ActorDetailsViewController.identifier) as? ActorDetailsViewController else {return}
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.actorID = id
        self.navigationController?.pushViewController(vc, animated: true)
         //present(vc, animated: true)
    }
    
    func navigateToShowMoreActorsViewController(actorResponse : ActorListResponse?){
    
         guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: MoreActorScreenViewController.identifier) as? MoreActorScreenViewController else {return}
        
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .crossDissolve
        vc.initData = actorResponse
        self.navigationController?.pushViewController(vc, animated: true)
//         present(vc, animated: true)
    }
    
    func navigateToShowMoreShowCasesViewController(movieResponse : MovieListResponse?){
    
         guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: MoreShowCasesViewController.identifier) as? MoreShowCasesViewController else {return}
        
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .crossDissolve
        vc.initData = movieResponse
        self.navigationController?.pushViewController(vc, animated: true)
         //present(vc, animated: true)
    }
    
    func navigateToSearchMovieViewController(){
    
         guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: SearchMovieViewController.identifier) as? SearchMovieViewController else {return}
        
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .crossDissolve
        //vc.initData = movieResponse
        self.navigationController?.pushViewController(vc, animated: true)
        // present(vc, animated: true)
    }
    
    func navigateToYouTubeViewController(id : String){
    
        let youTubeVC = YouTubePlayerViewController()        //let id = movieTrailers.first?.key
        youTubeVC.youtubeId = id
        
        self.navigationController?.pushViewController(youTubeVC, animated: true)
    }
    
    
    func navigateToMoreMoviesAndSeriesViewController(movieType : MovieOrSeries,_ response : MovieListResponse?){
    
        let vc = MoreMoviesViewController()
        vc.movieOrSeries = movieType
        vc.initData = response

        self.navigationController?.pushViewController(vc, animated: true)
    }




    
}
