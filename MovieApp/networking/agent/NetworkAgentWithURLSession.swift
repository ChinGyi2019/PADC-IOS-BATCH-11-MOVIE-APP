//
//  NetworkAgentWithURLSession.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 08/07/2021.
//

import Foundation


class NetworkAgentWithURLSession: MovieDBNetworkAgentProtocol {
    func getSeriesCredits(id: Int, completion: @escaping (MovieDBResult<MovieCastListResponse>) -> Void) {
        print("")
    }
    
    
    static let shared = NetworkAgentWithURLSession()
    
    init() {}
    
    func getMovieTrailer(id: Int, completion: @escaping (MovieDBResult<MovieTrailerResponse>) -> Void) {
        print("")
    }
    
    func getSimilarMovies(id: Int, completion: @escaping (MovieDBResult<MovieListResponse>) -> Void) {
        print("")
    }
    
    func getMoviesCredits(id: Int, completion: @escaping (MovieDBResult<MovieCastListResponse>) -> Void) {
        print("")
    }
    
    func getSeriesDetails(id: Int, completion: @escaping (MovieDBResult<MovieDetailsResponse>) -> Void) {
        print("")
    }
    
    func getMovieDetails(id: Int, completion: @escaping (MovieDBResult<MovieDetailsResponse>) -> Void) {
        print("")
    }
    
    func getActorDetails(id: Int, completion: @escaping (MovieDBResult<ActorDetailsResponse>) -> Void) {
        print("")
    }
    
    func getActorCombinedCredits(id: Int, completion: @escaping (MovieDBResult<ActorCombinedCreditsResponse>) -> Void) {
        print("")
    }
    
    func getActorsList(page: Int, completion: @escaping (MovieDBResult<ActorListResponse>) -> Void) {
        print("")
    }
    
    func getSearchedMovieList(searchQuery: String, page: Int, completion: @escaping (MovieDBResult<MovieListResponse>) -> Void) {
        print("")
    }
    
    func getTopRatedMovieList(page: Int, completion: @escaping (MovieDBResult<MovieListResponse>) -> Void) {
        print("")
    }
    
    func getGenreList(completion: @escaping (MovieDBResult<MovieGenreList>) -> Void) {
        let url = MovieDBEndPoint.movieGenre
        var urlRequest = URLRequest(url: url.url)
        urlRequest.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { data, respons, error in
            let genreList : MovieGenreList = try! JSONDecoder().decode(MovieGenreList.self, from: data!)
            
            completion(.success(genreList))
        }.resume()
        
        
        
    }
    
    func getPopularSerieList(page: Int, completion: @escaping (MovieDBResult<MovieListResponse>) -> Void) {
        print("")
    }
    
    func getPopularMovieList(page: Int, completion: @escaping (MovieDBResult<MovieListResponse>) -> Void) {
        print("")
    }
    
    func getUpcommingMovieList(page: Int, completion: @escaping (MovieDBResult<MovieListResponse>) -> Void) {
        print("")
    }
    
    
}
