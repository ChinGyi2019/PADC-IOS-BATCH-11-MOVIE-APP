//
//  ActorEntitiyExtension.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 07/08/2021.
//

import Foundation


extension ActorEntity{
    static func toCast(entity : ActorEntity)->Cast{
        return Cast(adult: entity.adult,
                    gender: Int(entity.gender),
                    id: Int(entity.id),
                    knownForDepartment: entity.knownForDepartment,
                    name: entity.name,
                    originalName: entity.name,
                    popularity: entity.popularity,
                    profilePath: entity.profilePath,
                    castID: Int(entity.id),
                    character: entity.alsoKnownAs,
                    creditID: String(entity.id),
                    order:Int(entity.id),
                    department: entity.knownForDepartment,
                    job: entity.knownForDepartment)
        
    }
    
    static func toActorInfo(entity : ActorEntity)->ActorInfo{
        return ActorInfo(adult: entity.adult,
                         gender: Int(entity.gender),
                         id: Int(entity.id),
                         knownFor: getCreditsArray(entity.credits),
                         knownForDepartment: entity.knownForDepartment,
                         name: entity.name,
                         popularity: entity.popularity,
                         profilePath: entity.profilePath)
        
    }
    
    static func toActorDetailResponse(entity : ActorEntity)->ActorDetailsResponse{
        return ActorDetailsResponse(adult: entity.adult,
                                    alsoKnownAs: [String](),
                                    biography: entity.biogrophy,
                                    birthday: entity.birthday,
                                    deathday: entity.dethday,
                                    gender: Int(entity.gender),
                                    homepage: entity.homePage,
                                    id: Int(entity.id),
                                    imdbID: entity.imdbID,
                                    knownForDepartment: entity.knownForDepartment,
                                    name: entity.name,
                                    placeOfBirth: entity.palceForBirth,
                                    popularity: entity.popularity,
                                    profilePath: entity.profilePath)
        
    }
    
    
    private static func getCreditsArray(_ set : NSSet?)->[MovieResult]{
        if let itemSet = set as? Set<MovieEntity>{
            return itemSet.map {
                MovieEntity.toMovieResult(entity: $0)
            }
        }else{
            return [MovieResult]()
        }
    }
}
