//
//  MovieType.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 03/02/2021.
//

import Foundation


enum MovieType : Int {
    case MOVIE_SLIDER = 0
    case MOVIE_POPULAR = 1
    case SERIE_POPULAR = 2
    case MOVIE_SHOWTIME = 3
    case MOVIE_GNRE = 4
    case MOVIE_SHOWCASE = 5
    case MOVIE_BESTACTOR = 6
    
}

enum MovieSeriesGroupType : String, CaseIterable{
    
    case upComingMovies = "UpComing Movies"
    case popularMovies = "Popular Movies"
    case popularSeries = "Popular Series"
    case topRatedMovies = "TopRated Movies"
    case upComingSeries = "UpComing Series"
    case actorCredits = "Actor Credits"
    
}


enum MovieOrSeries : String, Codable {
    case movie = "Movie"
    case series = "Series"
}

