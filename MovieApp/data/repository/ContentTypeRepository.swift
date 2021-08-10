//
//  ContentTypeRepository.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 05/08/2021.
//

import Foundation
import CoreData

protocol ContentTypeRepository {
    func save(name : String) -> BelongToTypeEntitiy
    
    func getMovieOrSeries(type : MovieSeriesGroupType, completion : @escaping ([MovieResult]) -> Void)
    
    func getBelongsToTypeEntity(type : MovieSeriesGroupType) -> BelongToTypeEntitiy
    
    
}
class ContentTypeRepositoryImpl : BaseRepository, ContentTypeRepository {
    
    static let shared = ContentTypeRepositoryImpl()
    private var contentTypeMap = [String:BelongToTypeEntitiy]()
    
    override init() {
        super.init()
        initializeData()
        
    }
    
    func getMovieOrSeries(type: MovieSeriesGroupType, completion: @escaping ([MovieResult]) -> Void) {
        
        if let entity =  contentTypeMap[type.rawValue],
           let movies = entity.movies,
           let itemSet = movies as? Set<MovieEntity>{
            
            let sortedData = Array(itemSet.sorted(by: { (first, second) in
                
                let datFormatter = DateFormatter()
                datFormatter.dateFormat = "yyyy-MM-dd"
                
                let firstDate = datFormatter.date(from: first.releaseDate ?? "") ?? Date()
                
                let secondDate = datFormatter.date(from: second.releaseDate ?? "") ?? Date()
                
                return firstDate.compare(secondDate) == .orderedDescending
                
            })).map { MovieEntity.toMovieResult(entity: $0)
            }
            
            completion(sortedData)
            
        }else{
            print("Error Retrieveing at \(#function)")
            completion([MovieResult]())
        }
    
}
    
    func getBelongsToTypeEntity(type: MovieSeriesGroupType) -> BelongToTypeEntitiy{
        
        if let entity = contentTypeMap[type.rawValue]{
            return entity
        }
        return save(name: type.rawValue)
    }
    
    @discardableResult
    func save(name: String) -> BelongToTypeEntitiy {
        
        let entity = BelongToTypeEntitiy(context: coreData.context)
        
        entity.name = name
        
        //for Pre-fetch to Memory
        contentTypeMap[name] = entity
        
        coreData.saveContext()
        
        return entity
        
    }
    
    private func initializeData() {
        let fetchRequest : NSFetchRequest<BelongToTypeEntitiy> = BelongToTypeEntitiy.fetchRequest()
        
        do {
            let dataSource = try coreData.context.fetch(fetchRequest)
            
            if dataSource.isEmpty{
            MovieSeriesGroupType.allCases.forEach{
                let _ = save(name: $0.rawValue)
                }
            }else{
                //Map existing data
                dataSource.forEach{
                    if let key = $0.name{
                        contentTypeMap[key] = $0
                    }
                }
            }
            
        } catch {
            print(error)
        }
    }
    
    
    
    
}
