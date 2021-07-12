//
//  MovieItemDelegate.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 10/05/2021.
//

import Foundation

protocol MovieItemDelegate {

    func onTapMovie(id : Int, isSeries : Bool)
    
}

protocol MoreMovieItemDelegate {

    func onTapMoreMovies()
    
}
