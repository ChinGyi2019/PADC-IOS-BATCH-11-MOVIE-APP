//
//  ActorRepository.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 05/08/2021.
//

import Foundation
import CoreData

protocol ActorRepository {
    func getList(page : Int, type : String, completion : @escaping ([ActorInfo])->Void)//later change type : String to ActorGroupType
    
    func save(list : [ActorInfo])
    func saveDetail(data : ActorDetailsResponse)
    func getDetail(id : Int, completion : @escaping (ActorDetailsResponse?)->Void)
    func getTotalPageActorList(page : Int, completion : @escaping (Int)->Void)
    
    func saveActorCombinedCredits(movies : [MovieResult])
    
    func getActorCombinedCredits(id : Int,completion: @escaping ([MovieResult])->Void)
}


class ActorRepositoryImpl: BaseRepository, ActorRepository {
    func getActorCombinedCredits(id: Int, completion: @escaping ([MovieResult]) -> Void) {
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false),
            NSSortDescriptor(key: "insertedAt", ascending: true)]
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first,
           let movies = firstItem.credits as? Set<MovieEntity>{
            
            completion(movies.map{ MovieEntity.toMovieResult(entity: $0)})
//            completion(ActorEntity.toActorDetailResponse(entity: firstItem))
            
        }else{
            completion([MovieResult]())
        }
        
    }
    
    func saveActorCombinedCredits(movies: [MovieResult]) {
        let entity = ActorEntity(context: coreData.context)
        movies.forEach {
            entity.addToCredits(
                $0.toMovieEntity(context: coreData.context,
                                 groupType:contentRepo.getBelongsToTypeEntity(
                                    type: .actorCredits) ))
            
        }
        coreData.saveContext()
    }
   
    
    
    static let shared = ActorRepositoryImpl()
    private let contentRepo = ContentTypeRepositoryImpl.shared
    
    private let pageSize = 15
    
    private override init() {
        
    }
    
    func getList(page: Int, type: String, completion: @escaping ([ActorInfo]) -> Void) {
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "insertedAt", ascending: true),
            NSSortDescriptor(key: "popularity", ascending: true),
            NSSortDescriptor(key: "name", ascending: false)
        ]
        
        fetchRequest.fetchLimit = pageSize
        fetchRequest.fetchOffset = (pageSize * page) - pageSize
        
        do {
            let results =  try coreData.context.fetch(fetchRequest)
            completion(results.map{
                ActorEntity.toActorInfo(entity: $0)
            })
            
        } catch {
            print("\(#function): \(error.localizedDescription)")
            completion([ActorInfo]())
        }
    }
    
    func save(list: [ActorInfo]) {
        list.forEach {
            let _ = $0.toActorEntity(context: coreData.context, contentRepo: contentRepo)
        }
        
        coreData.saveContext()
    }
    
    func saveDetail(data: ActorDetailsResponse) {
        let _ = data.toActorEntity(context: coreData.context)
        coreData.saveContext()
    }
    
    func getDetail(id: Int, completion: @escaping (ActorDetailsResponse?) -> Void){
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false),
            NSSortDescriptor(key: "insertedAt", ascending: true)]
        
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first{
            
            completion(ActorEntity.toActorDetailResponse(entity: firstItem))
            
        }else{
            completion(nil)
        }
    
    }
    
    func getTotalPageActorList(page : Int,completion: @escaping (Int) -> Void) {
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "insertedAt", ascending: true),
            NSSortDescriptor(key: "popularity", ascending: true),
            NSSortDescriptor(key: "name", ascending: false)
        ]
        fetchRequest.fetchLimit = pageSize
        fetchRequest.fetchOffset = (pageSize * page) - pageSize
        
        do{
            let results = try coreData.context.fetch(fetchRequest)
            
            let totalPage = Int(results.count/pageSize)
            completion(totalPage)
        } catch {
            print("\(#function):\(error)")
            completion(0)
        }
        
    }
    
    
}
