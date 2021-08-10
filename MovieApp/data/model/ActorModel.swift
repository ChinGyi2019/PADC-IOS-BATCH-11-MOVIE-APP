//
//  ActorModel.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 23/07/2021.
//

import Foundation


protocol ActorModel {
    
    func getActorDetails(id : Int,completion : @escaping (MovieDBResult<ActorDetailsResponse>) -> Void)
    
    func getActorsList(page : Int , completion : @escaping (MovieDBResult<[ActorInfo]>) -> Void)
    
    func getActorCombinedCredits(id : Int, completion : @escaping (MovieDBResult<[MovieResult]>) -> Void)

}

class ActorModelImpl: BaseModel, ActorModel {
  
    private let actorRepo = ActorRepositoryImpl.shared
    
    private var totalPageForActors = 1
    
    func getActorCombinedCredits(id: Int, completion: @escaping (MovieDBResult<[MovieResult]>) -> Void) {
        networkingAgent.getActorCombinedCredits(id: id) { reuslt in
            switch reuslt{
            case .success(let data):
                self.actorRepo.saveActorCombinedCredits(movies: data.cast ?? [MovieResult]())
                
            case .failure(let error):
                print("\(#function):\(error)")
            }
            
            self.actorRepo.getActorCombinedCredits(id: id) {
                completion(.success($0))
            }
            
        }
        
    }
    
    func getActorDetails(id: Int, completion: @escaping (MovieDBResult<ActorDetailsResponse>) -> Void) {
        networkingAgent.getActorDetails(id: id) { result in
            switch result {
            case .success(let data):
                self.actorRepo.saveDetail(data: data)
                
            case .failure(let error):
                print("\(#function):\(error)")
            }
            
            self.actorRepo.getDetail(id: id)  { item in
                if let item = item {
                    completion(.success(item))
                }else{
                    completion(.failure("Cannot find Movie: \(id)"))
                }
            }
            
        }
    }
    
    func getActorsList(page: Int, completion: @escaping (MovieDBResult<[ActorInfo]>) -> Void) {
        
        var netWorkResult = [ActorInfo]()
        
        networkingAgent.getActorsList(page: page) { result in
            switch result {
            case .success(let data):
                netWorkResult = data.results ?? [ActorInfo]()
                self.actorRepo.save(list: data.results ?? [ActorInfo]())
                self.totalPageForActors = data.totalPages ?? 1
                
            case .failure(let error):
                print("\(#function):\(error)")
            }
            self.actorRepo.getList(page: page, type: ""){
                completion(.success($0))
            }
            
            if netWorkResult.isEmpty{
                self.actorRepo.getTotalPageActorList(page:page) {
                    self.totalPageForActors = $0
                }
            }
            
            
            
            
        }
    }
    
    static let shared = ActorModelImpl()
    
    override init() {}
}
