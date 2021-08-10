//
//  MovieEntityExtension.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 06/08/2021.
//

import Foundation



extension MovieEntity{
    static func toMovieResult(entity : MovieEntity)-> MovieResult{
        
        return MovieResult(adult: entity.adult,
                           backdropPath: entity.backdropPath,
                           genreIDS: entity.genreIDs?.components(separatedBy: ",").compactMap{ Int($0.trimmingCharacters(in: .whitespaces))},
                           id: Int(entity.id ),
                           originalLanguage: entity.originalLanguage,
                           originalTitle: entity.originalTitle,
                           originalName: entity.originalName,
                           overview: entity.overView,
                           popularity: entity.popularity,
                           posterPath: entity.posterPath,
                           releaseDate: entity.releaseDate,
                           title: entity.title,
                           video: entity.video,
                           voteAverage: entity.voteAverage,
                           voteCount: Int(entity.voteCount))
    }
    
    static func toMovieDetailResponse(entity : MovieEntity)-> MovieDetailsResponse{
        
        return MovieDetailsResponse(adult: entity.adult,
                                    backdropPath: entity.backdropPath,
                                    belongsToCollection:
                                        BelongToCollectionEntity.toBelongToCollection(entity.belongToCollection),
                                    budget: Int(entity.budget),
                                    genres: getGenreArray(entity.genres),
                                    homepage: entity.homePage,
                                    id: Int(entity.id),
                                    imdbID: entity.imdbID,
                                    originalTitle: entity.originalTitle,
                                    originalLanguage: entity.originalLanguage,
                                    originalName: entity.originalName,
                                    overview: entity.overView,
                                    popularity: entity.popularity,
                                    posterPath: entity.posterPath,
                                    productionCompanies: getProductionCompanyArray(entity.productionCompanies),
                                    productionCountries: getProductionCountryArray(entity.productionCountries),
                                    releaseDate: entity.releaseDate,
                                    firstAirDate: entity.firstAirDate,
                                    revenue: Int(entity.revenu),
                                    runtime: Int(entity.runTime),
                                    spokenLanguages: [SpokenLanguageEntity.toSpokenLanguage(entity.spokenLanguages)],
                                    status: entity.status,
                                    tagline: entity.tagline,
                                    title: entity.title,
                                    video: entity.video,
                                    voteAverage: entity.voteAverage,
                                    voteCount: Int(entity.voteCount)
        )
        
    }
    
    static func getProductionCompanyArray(_ set : NSSet?) -> [ProductionCompany]{
        if let itemSet = set as? Set<ProductionCompanyEntity>{
            return itemSet.map {
                ProductionCompanyEntity.toProuctionCompany($0)
            }
        }else{
            return [ProductionCompany]()
        }
    }
    
    static func getProductionCountryArray(_ set : NSSet?) -> [ProductionCountry]{
        if let itemSet = set as? Set<ProductionCountryEntity>{
            return itemSet.map {
                ProductionCountryEntity.toProuctionCountry($0)
        }
        }else{
           return [ProductionCountry]()
        }
    
    }
    
    static func getSpokenLanguageArray(_ set : NSSet?) -> [SpokenLanguage]{
        if let itemSet = set as? Set<SpokenLanguageEntity>{
            return itemSet.map {
                SpokenLanguageEntity.toSpokenLanguage($0)
        }
        }else{
           return [SpokenLanguage]()
        }
    
    }
    
    static func getGenreArray(_ set : NSSet?) -> [MovieGenre]{
        if let itemSet = set as? Set<GenreEntitiy>{
            return itemSet.map {
                GenreEntitiy.toMovieGenre(entity: $0)
        }
        }else{
           return [MovieGenre]()
        }
    
    }
}
