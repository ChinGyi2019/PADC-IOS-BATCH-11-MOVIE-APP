//
//  MovieDBEndPoint.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 07/07/2021.
//

import Foundation
import Alamofire

enum MovieDBEndPoint : URLConvertible{
    
    
    case popularMovie(_ page : Int)
    case upcomingMovie(_ page : Int)
    case popularTvSeries(_ page : Int)
    case movieGenre
    case topRatedMovie(_ page : Int)
    case popularActors(_ page : Int)
    case tvSeriesDetails(_ id : Int)
    case movieDetails(_ id : Int)
    case movieActors(_ id : Int)
    case seriesActors(_ id : Int)
    case similarMovie(_ id : Int)
    case trailerVideo(_ id : Int)
    case actorDetails(_ id : Int)
    case actorImages(_ id : Int)
    case actorCombinedCredits(_ id : Int)
    case searchMovie(_ query : String,_ page : Int)
    
    func asURL() throws -> URL {
        return url
    }
    private var baseURL : String{
        return AppConstants.BASE_URL
    }
    
    var url :  URL{
        let urlComponent = NSURLComponents (string: baseURL.appending(apiPath))
        if urlComponent?.queryItems == nil{
            urlComponent?.queryItems = []
        }
        urlComponent?.queryItems?.append(contentsOf: [URLQueryItem(name: "api_key", value: AppConstants.API_KEY)])
        return urlComponent!.url!
    }
    
    private var apiPath : String{
        switch self {
        case .popularMovie(let page): return "/movie/popular?page=\(page)"
            
        case .upcomingMovie(let page): return "/movie/upcoming?page=\(page)"
            
            
        case .popularTvSeries(let page): return "/tv/popular?page=\(page)"
            
        case .movieGenre: return "/genre/movie/list"
            
        case .topRatedMovie(let page): return "/movie/top_rated?page=\(page)"
            
        case .popularActors(let page):
            return "/person/popular?page=\(page)"
        case .tvSeriesDetails(let id):
            return "/tv/\(id)"
        case .movieDetails(let id):
            return "/movie/\(id)"
        case .movieActors(let id):
            return "/movie/\(id)/credits"
        case .similarMovie(let id):
            return "/movie/\(id)/similar"
        case .trailerVideo(let id):
            return "/movie/\(id)/videos"
        case .actorDetails(let id):
            return "/person/\(id)"
        case .actorImages(let id):
            return "/person/\(id)/images"
        case .actorCombinedCredits(let id):
            return "/person/\(id)/combined_credits"
            
        case .searchMovie(let query, let page):
            return "/search/movie?page=\(page)"
//            return "/search/movie?query=\(query)&page=\(page)"
        case .seriesActors(let id):
            return "/tv/\(id)/credits"
        }
    }
}
