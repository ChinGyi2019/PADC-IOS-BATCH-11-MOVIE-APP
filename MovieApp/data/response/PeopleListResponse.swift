//
//  PeopleListResponse.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 23/06/2021.
//

import Foundation
import CoreData

// MARK: - PeopleListResponse
struct ActorListResponse: Codable {
    let page: Int?
    let results: [ActorInfo]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct ActorInfo: Codable {
    let adult: Bool?
    let gender, id: Int?
    let knownFor: [MovieResult]?
    let knownForDepartment: String?
    let name: String?
    let popularity: Double?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case name, popularity
        case profilePath = "profile_path"
    }
    
    func toActorEntity(context : NSManagedObjectContext, contentRepo : ContentTypeRepository) -> ActorEntity {
        let entity = ActorEntity(context: context)
        entity.id = Int32(id ?? 0)
        entity.adult = adult ?? false
        entity.gender = Int32(gender ?? 0)
        entity.popularity = popularity ?? 0.0
        entity.name = name
        entity.profilePath = profilePath
        entity.insertedAt = Date()
        knownFor?.forEach({
            entity.addToCredits($0.toMovieEntity(context: context, groupType: contentRepo.getBelongsToTypeEntity(type: .actorCredits)))
        })
       
        
        return entity
    }
    
    
}


