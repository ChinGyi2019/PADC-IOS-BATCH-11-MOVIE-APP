//
//  ProductionCompanyEntityExtension.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 07/08/2021.
//

import Foundation


extension ProductionCompanyEntity{
    
    static func toProuctionCompany(_ entity : ProductionCompanyEntity) -> ProductionCompany{
        
        return ProductionCompany(id: Int(entity.id),
                                 logoPath: entity.logoPath,
                                 name: entity.name,
                                 originCountry: entity.originalCountry)
    }
}

extension ProductionCountryEntity{
    
    static func toProuctionCountry(_ entity : ProductionCountryEntity) -> ProductionCountry{
        
        return ProductionCountry(iso3166_1: entity.iso3166_1,
                                 name: entity.name)
    }
}

extension SpokenLanguageEntity{
    
    static func toSpokenLanguage(_ entity : SpokenLanguageEntity?) -> SpokenLanguage{
        
        return SpokenLanguage(englishName: entity?.engilshName,
                              iso639_1: entity?.iso639_1,
                              name: entity?.name)
    }
}


extension BelongToCollectionEntity{
    
    static func toBelongToCollection(_ entity : BelongToCollectionEntity?) -> BelongsToCollection{
        
        return BelongsToCollection(id: Int(entity?.id ?? 0),
                                   name: entity?.name,
                                   posterPath: entity?.posterPath,
                                   backdropPath: entity?.backdropPath)
        
    }
    
    
}

extension GenreEntitiy{
    
    static func toBelongToCollection(_ entity : GenreEntitiy?) -> MovieGenre{
        
        return MovieGenre(id: Int(entity?.id ?? "0"),
                          name: entity?.name)
                
    }
}
