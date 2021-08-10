//
//  MovieModel.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 23/07/2021.
//

import Foundation

protocol MovieModel {

    
     func getActorsList(page : Int , completion : @escaping (MovieDBResult<ActorListResponse>) -> Void)
     
     
     func getTopRatedMovieList(page : Int, completion : @escaping (MovieDBResult<[MovieResult]>) -> Void)
     
     func getGenreList(completion : @escaping (MovieDBResult<[MovieGenre]>) -> Void)
     
     func getPopularSerieList(page : Int,completion : @escaping (MovieDBResult<[MovieResult]>) -> Void)
     
     func getPopularMovieList(page : Int, completion : @escaping (MovieDBResult<[MovieResult]>) -> Void)
     
     func getUpcommingMovieList(page : Int, completion : @escaping (MovieDBResult<[MovieResult]>) -> Void)
    
    func getMoviesOrSeries(page: Int, type : MovieSeriesGroupType, completion : @escaping ([MovieResult]) -> Void)
     
    
}

class MovieModelImpl: BaseModel, MovieModel {
    func getMoviesOrSeries(page: Int, type: MovieSeriesGroupType, completion: @escaping ([MovieResult]) -> Void) {
        
    }
    

    
    static let shared = MovieModelImpl()
    let movieRepository = MovieRepositoryImpl.shared
    let genreRepository = GenreRepositoryImpl.shared
    let contentTypeRepository = ContentTypeRepositoryImpl.shared
    private var fetchLimit = 15
    
    override init() {}
    
    func getActorsList(page: Int, completion: @escaping (MovieDBResult<ActorListResponse>) -> Void) {
        networkingAgent.getActorsList(page: page, completion: completion)
    }
    
    func getTopRatedMovieList(page: Int, completion: @escaping (MovieDBResult<[MovieResult]>) -> Void) {
        
        let contentType = MovieSeriesGroupType.topRatedMovies
        
        networkingAgent.getTopRatedMovieList(page: page) { result in
            switch result{
            
            case .success(let data):
                
                self.movieRepository.saveList(type: contentType, data: data)
                
            case .failure(let error):
                print("\(#function):\(error)")
            }

            self.movieRepository.getMoviesOrSeries(page: page, type: contentType) { result  in
                completion(.success(result))
            }

        }
    }
    
    func getGenreList(completion: @escaping (MovieDBResult<[MovieGenre]>) -> Void){
       //1): Fetch From Network
        networkingAgent.getGenreList { result in
            switch result{
            case .success(let data):
                //2): Save to db
                self.genreRepository.save(data: data)
            case .failure(let error):
                print("\(#function):\(error)")
            }
            //3): Retrieve from db and return
            self.genreRepository.get {completion(.success($0))}
        }
    }
    
    func getPopularSerieList(page: Int, completion: @escaping (MovieDBResult<[MovieResult]>) -> Void) {
        
        let contentType = MovieSeriesGroupType.popularSeries
        networkingAgent.getPopularSerieList(page: page) { result in
            switch result{
            
            case .success(let data):
                
                self.movieRepository.saveList(type: contentType, data: data)
                
            case .failure(let error):
                print("\(#function):\(error)")
            }
            
            self.movieRepository.getMoviesOrSeries(page: page, type: contentType) { result  in
                completion(.success(result))
            }
            
//            self.contentTypeRepository.getMovieOrSeries(type: contentType) {completion(.success($0))}
        }
    }
    
    func getPopularMovieList(page: Int, completion: @escaping (MovieDBResult<[MovieResult]>) -> Void) {
        let contentType = MovieSeriesGroupType.popularMovies
        networkingAgent.getPopularMovieList(page: page) { result in
            switch result{
            
            case .success(let data):
                
                self.movieRepository.saveList(type: contentType, data: data)
                
            case .failure(let error):
                print("\(#function):\(error)")
            }
            
            self.movieRepository.getMoviesOrSeries(page: page, type: contentType) { result  in
                completion(.success(result))
            }
//            self.contentTypeRepository.getMovieOrSeries(type: contentType) {completion(.success($0))}
        }
    }
    
    func getUpcommingMovieList(page: Int, completion: @escaping (MovieDBResult<[MovieResult]>) -> Void) {
        let contentType = MovieSeriesGroupType.upComingMovies
        networkingAgent.getUpcommingMovieList(page: page) { result in
            switch result{
            
            case .success(let data):
                
                self.movieRepository.saveList(type: contentType, data: data)
                
            case .failure(let error):
                print("\(#function):\(error)")
            }
            
            self.movieRepository.getMoviesOrSeries(page: page, type: contentType) { result  in
                completion(.success(result))
            }
//            self.contentTypeRepository.getMovieOrSeries(type: contentType) {completion(.success($0))}
        }
    }
    
    
}
