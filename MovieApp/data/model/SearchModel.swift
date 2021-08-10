//
//  SearchModel.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 23/07/2021.
//

import Foundation

protocol  SearchModel{
    
    func getSearchedMovieList(searchQuery : String, page : Int, completion : @escaping (MovieDBResult<MovieListResponse>) -> Void)
    
}

class SearchModelImpl: BaseModel,SearchModel {
    
    static let shared = SearchModelImpl()
    
    override init() {}
    func getSearchedMovieList(searchQuery: String, page: Int, completion: @escaping (MovieDBResult<MovieListResponse>) -> Void) {
        networkingAgent.getSearchedMovieList(searchQuery: searchQuery, page: page, completion: completion)
    }
    
    
}
