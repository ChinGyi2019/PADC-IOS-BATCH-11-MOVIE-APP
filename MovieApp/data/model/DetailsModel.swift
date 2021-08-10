//
//  DetailsModel.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 23/07/2021.
//

import Foundation


protocol MovieDetailsModel {
    func getMovieTrailer(id: Int, completion : @escaping (MovieDBResult< MovieTrailerResponse>) -> Void)
     
     func getSimilarMovies(id: Int, completion : @escaping (MovieDBResult<[MovieResult]>) -> Void)
     
     func getMoviesCredits(id : Int, completion : @escaping (MovieDBResult<[Cast]>) -> Void)
     
     
     
     func getMovieDetails(id : Int, completion : @escaping (MovieDBResult<MovieDetailsResponse>) -> Void)
    
    func getSeriesCredits(id : Int, completion : @escaping (MovieDBResult<[Cast]>) -> Void)
    
    func getSeriesDetails(id : Int, completion : @escaping (MovieDBResult<MovieDetailsResponse>) -> Void)
}

class MovieDetailsImpl: BaseModel, MovieDetailsModel {
    
    
    
    static let shared = MovieDetailsImpl()
    
    private let moveRepo = MovieRepositoryImpl.shared
    
    override init() {}
    
    func getMovieTrailer(id: Int, completion: @escaping (MovieDBResult<MovieTrailerResponse>) -> Void) {
        networkingAgent.getMovieTrailer(id: id, completion: completion)
    }
    
    func getSimilarMovies(id: Int, completion: @escaping (MovieDBResult<[MovieResult]>) -> Void) {
        networkingAgent.getSimilarMovies(id: id) { result in
            switch result {
            case .success(let data):
                self.moveRepo.saveSimilarContent(id: id, data: data.results ?? [MovieResult]())
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.moveRepo.getSimilarContent(id: id) { completion(.success($0))
            }
        }
    }
    
    
    
    func getMoviesCredits(id: Int, completion: @escaping (MovieDBResult<[Cast]>) -> Void) {
        networkingAgent.getMoviesCredits(id: id) { result in
            switch result {
            case .success(let data):
                self.moveRepo.saveCasts(id: id, data: data.cast ?? [Cast]())
            case . failure(let error):
                print("\(#function):\(error.debugDescription)")
            }
            
            self.moveRepo.getCasts(id: id) { 
                completion(.success($0))
            
            }
        }
    }
    
  
    
    func getMovieDetails(id: Int, completion: @escaping (MovieDBResult<MovieDetailsResponse>) -> Void) {
        networkingAgent.getMovieDetails(id: id) { result in
            switch result {
            case .success(let data):
                self.moveRepo.savedetail(data: data)
            case .failure(let error):
                print("\(#function): \(error)")
            }
            
            self.moveRepo.getDetail(id: id) { item in
                if let item = item {
                    completion(.success(item))
                }else{
                    completion(.failure("Cannot find Movie: \(id)"))
                }
            }
        }
    }
    
    func getSeriesCredits(id: Int, completion: @escaping (MovieDBResult<[Cast]>) -> Void) {
        networkingAgent.getSeriesCredits(id: id) { result in
            switch result {
            case .success(let data):
                self.moveRepo.saveCasts(id: id, data: data.cast ?? [Cast]())
            case . failure(let error):
                print("\(#function):\(error.debugDescription)")
            }
            
            self.moveRepo.getCasts(id: id) {
                completion(.success($0))
            
            }
        }
    }
    
    func getSeriesDetails(id: Int, completion: @escaping (MovieDBResult<MovieDetailsResponse>) -> Void) {
        networkingAgent.getSeriesDetails(id: id) { result in
            switch result {
            case .success(let data):
                self.moveRepo.savedetail(data: data)
            case .failure(let error):
                print("\(#function): \(error)")
            }
            
            self.moveRepo.getDetail(id: id) { item in
                if let item = item {
                    completion(.success(item))
                }else{
                    completion(.failure("Cannot find TV/Series: \(id)"))
                }
            }
        }
    }
    
    
}
