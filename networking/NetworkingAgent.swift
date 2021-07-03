//
//  NetworkingAgent.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 22/06/2021.
//

import Foundation
import Alamofire

struct MovieDBNetwrokingAgent {
    
    static let shared = MovieDBNetwrokingAgent()
    
    init() {}
    
    func getSeriesDetails(id : Int, success : @escaping (MovieDetailsResponse) -> Void, failure : @escaping (String) -> Void){
        let url =  "\(AppConstants.BASE_URL)/tv/\(id)?api_key=\(AppConstants.API_KEY)"
        AF.request(url).validate(statusCode: 200 ..< 300)
            .responseDecodable(of: MovieDetailsResponse.self) { response  in //AFDataResponse<MovieDetailsResponse>
            switch response.result{
            
            case .success(let data):
                //Parse Data to Clousre to present in UIView
                success(data)
                            
            case .failure(let error):
                failure("\(error)")
                print(error)
                
                
            }
        }
        

    }
    
    func getMovieDetails(id : Int, success : @escaping (MovieDetailsResponse) -> Void, failure : @escaping (String) -> Void){
        let url =  "\(AppConstants.BASE_URL)/movie/\(id)?api_key=\(AppConstants.API_KEY)"
        AF.request(url).validate(statusCode: 200 ..< 300)
            .responseDecodable(of: MovieDetailsResponse.self) { response  in //AFDataResponse<MovieDetailsResponse>
            switch response.result{
            
            case .success(let data):
                //Parse Data to Clousre to present in UIView
                success(data)
                            
            case .failure(let error):
                failure("\(error)")
                print(error)
                
                
            }
        }
        

    }
    
    func getActorsList(success : @escaping (ActorListResponse) -> Void, failure : @escaping (String) -> Void){
        let url =  "\(AppConstants.BASE_URL)/person/popular?api_key=\(AppConstants.API_KEY)"
        AF.request(url).responseDecodable(of: ActorListResponse.self) { response  in //AFDataResponse<MovieGenreList>
            switch response.result{
            
            case .success(let data):
                //Parse Data to Clousre to present in UIView
                success(data)
                            
            case .failure(let error):
                failure("\(error)")
                print(error)
                
                
            }
        }
        

    }
    
    func getTopRatedMovieList(success : @escaping (MovieListResponse) -> Void, failure : @escaping (String) -> Void){
        let url =  "\(AppConstants.BASE_URL)/movie/top_rated?api_key=\(AppConstants.API_KEY)"
        AF.request(url).responseDecodable(of: MovieListResponse.self) { response  in //AFDataResponse<MovieGenreList>
            switch response.result{
            
            case .success(let data):
                //Parse Data to Clousre to present in UIView
                success(data)
                            
            case .failure(let error):
                failure("\(error)")
                print(error)
                
                
            }
        }
        

    }
    
    func getGenreList(success : @escaping (MovieGenreList) -> Void, failure : @escaping (String) -> Void){
        let url =  "\(AppConstants.BASE_URL)/genre/movie/list?api_key=\(AppConstants.API_KEY)"
        AF.request(url).responseDecodable(of: MovieGenreList.self) { response  in //AFDataResponse<MovieGenreList>
            switch response.result{
            
            case .success(let data):
                //Parse Data to Clousre to present in UIView
                success(data)
                            
            case .failure(let error):
                failure("\(error)")
                print(error)
                
                
            }
        }
        

    }
    func getPopularSerieList(success : @escaping (MovieListResponse) -> Void, failure : @escaping (String) -> Void){
        let url =  "\(AppConstants.BASE_URL)/tv/popular?api_key=\(AppConstants.API_KEY)"
        AF.request(url).responseDecodable(of: MovieListResponse.self) { response  in //AFDataResponse<PopularSeriesList>
            switch response.result{
            
            case .success(let popularSerieList):
                //Parse Data to Clousre to present in UIView
                success(popularSerieList)
                            
            case .failure(let error):
                failure("\(error)")
                print(error)
                
                
            }
        }
        

    }
    
    func getPopularMovieList(success : @escaping (MovieListResponse) -> Void, failure : @escaping (String) -> Void){
        let url =  "\(AppConstants.BASE_URL)/movie/popular?api_key=\(AppConstants.API_KEY)"
        AF.request(url).responseDecodable(of: MovieListResponse.self) { response  in //AFDataResponse<PopularMovieList>
            switch response.result{
            
            case .success(let popularMovieList):
                //Parse Data to Clousre to present in UIView
                success(popularMovieList)
                            
            case .failure(let error):
                failure("\(error)")
                print(error)
                
                
            }
        }
        

    }
    func getUpcommingMovieList(success : @escaping (MovieListResponse) -> Void, failure : @escaping (String) -> Void){
        let url =  "\(AppConstants.BASE_URL)/movie/upcoming?api_key=\(AppConstants.API_KEY)"
        AF.request(url).responseDecodable(of: MovieListResponse.self) { response  in //AFDataResponse<UpcommingMovieList>
            switch response.result{
            
            case .success(let upCommingMoieList):
                //Parse Data to Clousre to present in UIView
                success(upCommingMoieList)
                            
            case .failure(let error):
                failure("\(error)")
                print(error)
                
                
            }
        }
        
        
    }
    
}



//                upCommingMoieList.results?.forEach({ item in
//                    print(item.title ?? "unknown")
//                })
