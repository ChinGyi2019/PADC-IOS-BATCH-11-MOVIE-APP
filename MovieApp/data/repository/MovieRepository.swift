//
//  MovieRepository.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 05/08/2021.
//

import Foundation
import CoreData

protocol MovieRepository {
    
    func getDetail(id : Int, completion : @escaping (MovieDetailsResponse?) -> Void)
    
    func savedetail(data : MovieDetailsResponse)
    
    func saveList(type : MovieSeriesGroupType, data : MovieListResponse)
    
    func getMoviesOrSeries(page: Int, type : MovieSeriesGroupType, completion : @escaping ([MovieResult]) -> Void)
    
    func saveSimilarContent(id : Int, data : [MovieResult])
    
    func getSimilarContent(id : Int, completion : @escaping([MovieResult])-> Void)
    
    func saveCasts(id : Int, data : [Cast])
    
    func getCasts(id : Int, completion : @escaping([Cast])-> Void)
    
    func getMovieToalPage(completion : @escaping (Int)-> Void)
    
    
    
}

class MovieRepositoryImpl: BaseRepository, MovieRepository {
    
    
    
    private let pageSize = 15
    
    let contentRepo = ContentTypeRepositoryImpl.shared
    
    static let shared = MovieRepositoryImpl()
    
    override init() {}
    
    func getMoviesOrSeries(page: Int, type: MovieSeriesGroupType, completion: @escaping ([MovieResult]) -> Void) {
        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        
        /*Alternative Solutions
         
         1] . This approach is lacking accuracy like "Getting a few data".
         
         fetchRequest.predicate = NSPredicate(format: "ANY belongToType.name LIKE[cd] %@", "\(type.rawValue)")
         
         2] . This approach does not work with Pagination.
         
         let results = movies.filter {MovieEntity in
         let typeItems =  MovieEntity.belongToType as! Set<BelongToTypeEntitiy>
         
         return typeItems.contains{ $0.name == type.rawValue }
         
         }.map {
         MovieEntity.toMovieResult(entity: $0)
         }
         print("\(#function)->\(results.count)")
         
         */
        
        /*
         3] . Amazing Artwork  -->>
         
         source ==> https://medium.com/@Czajnikowski/subquery-is-not-that-scary-3f95cb9e2d98
         */
        
        fetchRequest.predicate = NSPredicate(
            format: "SUBQUERY(" +
                "belongToType, " +
                "$type, " +
                "$type.name ==[cd] \"\(type.rawValue)\"" +
                ").@count >0"
        )
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false)]
        
        fetchRequest.fetchOffset = (page * pageSize) - pageSize
        fetchRequest.fetchLimit = pageSize
        
        do {
            let movies : [MovieEntity] = try coreData.context.fetch(fetchRequest)
            
            let results = movies.map{
                MovieEntity.toMovieResult(entity: $0)
            }
            
            completion(results)
            
            
        } catch {
            print("\(#function):\( error.localizedDescription)")
            completion([MovieResult]())
        }
        
        
        
        
        
    }
    
    
    
    func getMovieToalPage(completion : @escaping (Int)-> Void){
        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        
        do {
            let movies : [MovieEntity] = try coreData.context.fetch(fetchRequest)
            
            if  movies.count % pageSize == 0{
                completion(Int(movies.count % pageSize))
            }else{
                completion(Int((movies.count % pageSize) + 1))
            }
            
            
            
        } catch {
            print("\(#function):\( error.localizedDescription)")
            completion(0)
        }
        
        
        
    }
    
    
    func getDetail(id: Int, completion: @escaping (MovieDetailsResponse?) -> Void){
        
        let fetchRequest = getMovieFetchRequestById(id)
        
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first{
            
            completion(MovieEntity.toMovieDetailResponse(entity: firstItem))
            
        }else{
            completion(nil)
        }
    }
    
    func savedetail(data: MovieDetailsResponse) {
        let _ = data.toMovieEntity(context: coreData.context)
        
        coreData.saveContext()
    }
    
    func saveList(type: MovieSeriesGroupType, data: MovieListResponse) {
        data.results?.forEach({
            $0.toMovieEntity(context: coreData.context,
                             groupType: contentRepo.getBelongsToTypeEntity(type: type))
        })
        self.coreData.saveContext()
    }
    
    func saveSimilarContent(id: Int, data: [MovieResult]) {
        
        let fetchRequest = getMovieFetchRequestById(id)
        
        if let items  = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first{
            let _ = data.map{
                firstItem.addToSimilarMovies($0.toMovieEntity(context: coreData.context, groupType: contentRepo.getBelongsToTypeEntity(type: .actorCredits)))
            }
            coreData.saveContext()
            
        }
        
        
    }
    
    func getSimilarContent(id: Int, completion: @escaping ([MovieResult]) -> Void){
        
        let fetchRequest = getMovieFetchRequestById(id)
        
        if let items = try? coreData.context.fetch(fetchRequest),
           let item = items.first{
            
            if let similarSet  = item.similarMovies as? Set<MovieEntity>{
                completion((similarSet.map {
                    MovieEntity.toMovieResult(entity: $0)
                }))
            }else{
                completion([MovieResult]())
            }
        }
    }
    
    func saveCasts(id: Int, data: [Cast]) {
        let fetchRequest = getMovieFetchRequestById(id)
        
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first{
            data.map {
                $0.convertToActorInfo()
            }.map{
                $0.toActorEntity(context: coreData.context, contentRepo: contentRepo)
            }.forEach {
                firstItem.addToCredits($0)
            }
            
            coreData.saveContext()
        }
    }
    
    func getCasts(id: Int, completion: @escaping ([Cast]) -> Void) {
        let fetchRequest = getMovieFetchRequestById(id)
        
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first,
           let casts = firstItem.credits as? Set<ActorEntity>{
            completion(casts.map {
                ActorEntity.toCast(entity: $0)
            })
        }else {
            completion([Cast]())
        }
    }
    
    private func getMovieFetchRequestById(_ id : Int) -> NSFetchRequest<MovieEntity>{
        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false)]
        
        return fetchRequest
        
    }
    
}



extension NSSet {
    func toArray<T>() -> [T] {
        let array = self.map({ $0 as! T})
        return array
    }
}
