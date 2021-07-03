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
         present(vc, animated: true)
    }

    
}
