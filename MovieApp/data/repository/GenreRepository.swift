//
//  GenreRepository.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 05/08/2021.
//

import Foundation
import CoreData

protocol GenreRepository {
    func get(completion : @escaping ([MovieGenre])->Void)
    func save(data : MovieGenreList)
}

class GenreRepositoryImpl: BaseRepository, GenreRepository {
    
    static let shared = GenreRepositoryImpl()
    
   private override init() {}
    
    func get(completion: @escaping ([MovieGenre]) -> Void) {
        let fetchRequest : NSFetchRequest<GenreEntitiy> = GenreEntitiy.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        do {
            let results : [GenreEntitiy] = try coreData.context.fetch(fetchRequest)
            let items = results.map { GenreEntitiy.toMovieGenre(entity: $0)}
            completion(items)
        } catch {
            print("\(#function):\(error.localizedDescription)")
        }
    }
    
    func save(data: MovieGenreList) {
        let _ = data.genres?.map({ genre in
            let entity = GenreEntitiy(context: coreData.context)
            entity.id = String(genre.id ?? 0)
            entity.name = genre.name
            return
        })
        coreData.saveContext()
    }
    
    
    
}
