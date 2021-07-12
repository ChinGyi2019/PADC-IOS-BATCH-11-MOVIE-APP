//
//  NetworkingAgent.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 22/06/2021.
//

import Foundation
import Alamofire

protocol MovieDBNetworkAgentProtocol {
    
   func getMovieTrailer(id: Int, completion : @escaping (MovieDBResult< MovieTrailerResponse>) -> Void)
    
    func getSimilarMovies(id: Int, completion : @escaping (MovieDBResult<MovieListResponse>) -> Void)
    
    func getMoviesCredits(id : Int, completion : @escaping (MovieDBResult<MovieCastListResponse>) -> Void)
    
    func getSeriesCredits(id : Int, completion : @escaping (MovieDBResult<MovieCastListResponse>) -> Void)
    
    func getSeriesDetails(id : Int, completion : @escaping (MovieDBResult<MovieDetailsResponse>) -> Void)
    
    func getMovieDetails(id : Int, completion : @escaping (MovieDBResult<MovieDetailsResponse>) -> Void)
    
    func getActorDetails(id : Int,completion : @escaping (MovieDBResult<ActorDetailsResponse>) -> Void)
    
    func getActorCombinedCredits(id : Int, completion : @escaping (MovieDBResult<ActorCombinedCreditsResponse>) -> Void)
    
    func getActorsList(page : Int , completion : @escaping (MovieDBResult<ActorListResponse>) -> Void)
    
    func getSearchedMovieList(searchQuery : String, page : Int, completion : @escaping (MovieDBResult<MovieListResponse>) -> Void)
    
    func getTopRatedMovieList(page : Int, completion : @escaping (MovieDBResult<MovieListResponse>) -> Void)
    
    func getGenreList(completion : @escaping (MovieDBResult<MovieGenreList>) -> Void)
    
    func getPopularSerieList(page : Int,completion : @escaping (MovieDBResult <MovieListResponse>) -> Void)
    
    func getPopularMovieList(page : Int, completion : @escaping (MovieDBResult<MovieListResponse>) -> Void)
    
    func getUpcommingMovieList(page : Int, completion : @escaping (MovieDBResult<MovieListResponse>) -> Void)
    
    
    
}




struct MovieDBNetwrokingAgent : MovieDBNetworkAgentProtocol {
    
    static let shared = MovieDBNetwrokingAgent()
    
    init() {}
    
    func getMovieTrailer(id: Int, completion : @escaping (MovieDBResult< MovieTrailerResponse>) -> Void){
        AF.request(MovieDBEndPoint.trailerVideo(id)).responseDecodable(of: MovieTrailerResponse.self) { response  in //AFDataResponse<MovieTrailerResponse>
            switch response.result{
            
            case .success(let data): completion(.success(data))
               
            case .failure(let error): completion(.failure(error.errorDescription!))

            }
        }
        

    }
    
    func getSimilarMovies(id: Int, completion : @escaping (MovieDBResult<MovieListResponse>) -> Void){
      
        AF.request(MovieDBEndPoint.similarMovie(id)).responseDecodable(of: MovieListResponse.self) { response  in //AFDataResponse<SimilarMovies>
            switch response.result{
            
            case .success(let data):
                
                completion(.success(data))
                            
            case .failure(let error):
                completion(.failure("\(error)"))
               
                
                
            }
        }
        

    }
    
    func getMoviesCredits(id : Int, completion : @escaping (MovieDBResult<MovieCastListResponse>) -> Void){
      
        AF.request(MovieDBEndPoint.movieActors(id))
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: MovieCastListResponse.self) { response  in //AFDataResponse<MovieCastListResponse>
            switch response.result{
            
            case .success(let data):
                //Parse Data to Clousre to present in UIView
                completion(.success(data))
                            
            case .failure(let error):
                completion(.failure("\(error)"))
               
                
                
            }
        }
        

    }
    
    func getSeriesCredits(id : Int, completion : @escaping (MovieDBResult<MovieCastListResponse>) -> Void){
      
        AF.request(MovieDBEndPoint.seriesActors(id))
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: MovieCastListResponse.self) { response  in //AFDataResponse<MovieCastListResponse>
            switch response.result{
            
            case .success(let data):
                //Parse Data to Clousre to present in UIView
                completion(.success(data))
                            
            case .failure(let error):
                completion(.failure("\(error)"))
               
                
                
            }
        }
        

    }
    
    func getSeriesDetails(id : Int, completion : @escaping (MovieDBResult<MovieDetailsResponse>) -> Void){
      
        AF.request(MovieDBEndPoint.tvSeriesDetails(id)).validate(statusCode: 200 ..< 300)
            .responseDecodable(of: MovieDetailsResponse.self) { response  in //AFDataResponse<MovieDetailsResponse>
                switch response.result{
                case .success(let data):
                    //Parse Data to Clousre to present in UIView
                    completion(.success(data))
                    
                case .failure(let error):
                    completion(.failure("\(error)"))
                    print(error)
                    
                    
                }
            }
        

    }
    
    
    
    func getMovieDetails(id : Int, completion : @escaping (MovieDBResult<MovieDetailsResponse>) -> Void){
       
        AF.request(MovieDBEndPoint.movieDetails(id))
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: MovieDetailsResponse.self) { response  in //AFDataResponse<MovieDetailsResponse>
            switch response.result{
            
            case .success(let data):
                //Parse Data to Clousre to present in UIView
                completion(.success(data))
                            
            case .failure(let error):
                completion(.failure("\(error)"))
                print(error)
                
                
            }
        }
        

    }
    
    func getActorDetails(id : Int,completion : @escaping (MovieDBResult<ActorDetailsResponse>) -> Void){
       
        AF.request(MovieDBEndPoint.actorDetails(id)).responseDecodable(of: ActorDetailsResponse.self) { response  in //AFDataResponse<MovieGenreList>
            switch response.result{
            
            case .success(let data):
                //Parse Data to Clousre to present in UIView
                completion(.success(data))
                            
            case .failure(let error):
                completion(.failure("\(error)"))
                print(error)
                
                
            }
        }
        

    }
    
    func getActorCombinedCredits(id : Int, completion : @escaping (MovieDBResult<ActorCombinedCreditsResponse>) -> Void){
    
        AF.request(MovieDBEndPoint.actorCombinedCredits(id)).responseDecodable(of: ActorCombinedCreditsResponse.self) { response  in //AFDataResponse<MovieGenreList>
            switch response.result{
            
            case .success(let data):
                //Parse Data to Clousre to present in UIView
                completion(.success(data))
                            
            case .failure(let error):
                completion(.failure("\(error)"))
        
            }
        }
        

    }
    
    func getActorsList(page : Int = 1, completion : @escaping (MovieDBResult<ActorListResponse>) -> Void){

        AF.request(MovieDBEndPoint.popularActors(page)).responseDecodable(of: ActorListResponse.self) { response  in //AFDataResponse<MovieGenreList>
            switch response.result{
            
            case .success(let data):
                //Parse Data to Clousre to present in UIView
                completion( .success(data))
                            
            case .failure(let error):
                completion(.failure("\(error)"))
                print(error)
                
                
            }
        }
        

    }
    
    func getSearchedMovieList(searchQuery : String, page : Int = 1, completion : @escaping (MovieDBResult<MovieListResponse>) -> Void){

        let queryDict = ["query" : searchQuery]
        AF.request(MovieDBEndPoint.searchMovie(searchQuery, page),parameters: queryDict).responseDecodable(of: MovieListResponse.self) { response  in //AFDataResponse<MovieGenreList>
            switch response.result{
            
            case .success(let data):
                completion( .success(data))
                            
            case .failure(let error):
                completion(.failure(error.errorDescription!))
                
                
                
            }
        }
        

    }
    
    func getTopRatedMovieList(page : Int = 1, completion : @escaping (MovieDBResult<MovieListResponse>) -> Void){
     
        AF.request(MovieDBEndPoint.topRatedMovie(page)).responseDecodable(of: MovieListResponse.self) { response  in //AFDataResponse<MovieGenreList>
            switch response.result{
            
            case .success(let data):
                completion(.success(data))
                            
            case .failure(let error):
                completion(.failure(error.errorDescription!))
                
                
            }
        }
        

    }
    
    func getGenreList(completion : @escaping (MovieDBResult<MovieGenreList>) -> Void){
        AF.request(MovieDBEndPoint.movieGenre).responseDecodable(of: MovieGenreList.self) { response  in //AFDataResponse<MovieGenreList>
            switch response.result{
            
            case .success(let data):
                //Parse Data to Clousre to present in UIView
                completion(.success(data))
                            
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                
                
            }
        }
        

    }
    func getPopularSerieList(page : Int = 1,completion : @escaping (MovieDBResult <MovieListResponse>) -> Void){

        AF.request(MovieDBEndPoint.popularTvSeries(page)).responseDecodable(of: MovieListResponse.self) { response  in //AFDataResponse<PopularSeriesList>
            switch response.result{
            
            case .success(let data):
                //Parse Data to Clousre to present in UIView
                completion(.success(data))
                            
            case .failure(let error):
                completion(.failure(error.errorDescription!))
                
                
                
            }
        }
        

    }
    
    func getPopularMovieList(page : Int = 1, completion : @escaping (MovieDBResult<MovieListResponse>) -> Void){
        
        AF.request(MovieDBEndPoint.popularMovie(page)).responseDecodable(of: MovieListResponse.self) { response  in //AFDataResponse<PopularMovieList>
            switch response.result{
            
            case .success(let data):
                //Parse Data to Clousre to present in UIView
                completion(.success(data))
                            
            case .failure(let error):
                completion(.failure(error.errorDescription!))
              
                
                
            }
        }
        

    }
    func getUpcommingMovieList(page : Int = 1, completion : @escaping (MovieDBResult<MovieListResponse>) -> Void){
//        let url =  "\(AppConstants.BASE_URL)/movie/upcoming?api_key=\(AppConstants.API_KEY)"
        AF.request(MovieDBEndPoint.upcomingMovie(page))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: MovieListResponse.self) { response  in //AFDataResponse<UpcommingMovieList>
            switch response.result{
            case .success(let data):
                completion(.success(data))
                            
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            
            }
        }
        
        
    }
    
    fileprivate func handleError<T,E: MDBErrorModel>(
        _ response : DataResponse<T, AFError>,
        _ error: (AFError),
        _ errorBodyType : E.Type) -> String {
        
        var respBody : String = ""
        
        var serverErrorMessage : String?
        
        var errorBody : E?
        
        if let respData = response.data{
            respBody = String(data: respData, encoding: .utf8) ?? "empty response Body"
            errorBody = try? JSONDecoder().decode(errorBodyType, from: respData)
            
            serverErrorMessage = errorBody?.message
            
        }
        /// 2 --- Extract debug info
        
        let respCode : Int = response.response?.statusCode ?? 0
        
        let sourcePath : String = response.request?.url?.absoluteString ?? "No URL"
         
        // 1 - Essential Debug info
        
        print("""
        =======================
        
        URL
        -> \(sourcePath)
        
        Status
        -> \(respCode)
        
        Body
        -> \(respBody)
        
        UnderLyingError
        -> \(String(describing: error.underlyingError))
        
        Error Description
        -> \(String(describing: error.errorDescription))
        
        ========================
        """)
        
        
        return serverErrorMessage ?? error.errorDescription ?? "undified error :)"
    }
    
}
    

protocol MDBErrorModel : Decodable{
    var message : String { get }
}

class MDBCommonResponseError : MDBErrorModel  {
    var message: String{
        return statusMessage
    }
    let statusMessage : String
    let statusCode : Int
    
    enum CodingKeys: String,CodingKey  {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}


