//
//  MovieDetailsResponse.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 24/06/2021.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieDetailsResponse = try? newJSONDecoder().decode(MovieDetailsResponse.self, from: jsonData)

import Foundation
import CoreData

// MARK: - MovieDetailsResponse
struct MovieDetailsResponse: Codable {
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int?
    let genres: [MovieGenre]?
    let homepage: String?
    let id: Int?
    let imdbID, originalTitle,originalLanguage, originalName,overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate, firstAirDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    @discardableResult
    func toMovieEntity(context : NSManagedObjectContext) -> MovieEntity {
        let entity = MovieEntity(context: context)
        entity.id = Int32(id ?? 0)
        entity.adult = adult ?? false
        entity.backdropPath = backdropPath
        entity.genreIDs = genres?.map{ String($0.id ?? 0) }.joined(separator: ",")
        entity.originalLanguage = originalLanguage
        entity.originalTitle = originalTitle
        entity.originalName =  originalName
        entity.overView = overview
        entity.popularity = popularity ?? 0.0
        entity.posterPath = posterPath
        entity.releaseDate = releaseDate ?? ""
        entity.title = title
        entity.video = video ?? false
        entity.voteAverage = voteAverage ?? 0.0
        entity.voteCount = Int64(voteCount ?? 0)
        entity.belongToCollection = belongsToCollection?.toBelongsToCollectionEntity(context: context)
        
        //ProcductionCompany
        productionCompanies?.forEach{
            entity.addToProductionCompanies(  $0.toProductionCompanyEntity(context: context))
            
        }
        //ProcductionCountries
        productionCountries?.forEach{
            entity.addToProductionCountries($0.toProductionCountryEntity(context: context))
        }
        //Spoken Language
        entity.spokenLanguages = spokenLanguages?.first?.toSpokenLanguageEntity(context: context)
        
        //Spoken Language
        genres?.forEach{
            entity.addToGenres($0.toGenreEntity(context: context))
            
        }
     
    
        
        return entity
    }
}

// MARK: - BelongsToCollection
struct BelongsToCollection: Codable {
    let id: Int?
    let name, posterPath, backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
    
    func toBelongsToCollectionEntity(context: NSManagedObjectContext) -> BelongToCollectionEntity {
        let entity = BelongToCollectionEntity(context: context)
        entity.id = Int32(id ?? 0)
        entity.name = name
        entity.backdropPath = backdropPath
        
        
        return entity
        
    }
}



// MARK: - ProductionCompany
struct ProductionCompany: Codable, Hashable {
    let id: Int?
    let logoPath, name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
    
    @discardableResult
    func toProductionCompanyEntity(context: NSManagedObjectContext) -> ProductionCompanyEntity {
        let entity = ProductionCompanyEntity(context: context)
        entity.id = Int32(id ?? 0)
        entity.name = name
        entity.logoPath = logoPath
        entity.originalCountry = originCountry

        return entity
        
    }
}

// MARK: - ProductionCountry

struct ProductionCountry: Codable {
    let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
    @discardableResult
    func toProductionCountryEntity(context: NSManagedObjectContext) -> ProductionCountryEntity {
        let entity = ProductionCountryEntity(context: context)
        entity.name = name
        entity.iso3166_1 = iso3166_1

        return entity
        
    }
}

// MARK: - SpokenLanguage

struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
    
    @discardableResult
    func toSpokenLanguageEntity(context: NSManagedObjectContext) -> SpokenLanguageEntity {
        let entity = SpokenLanguageEntity(context: context)
        entity.name = name
        entity.iso639_1 = iso639_1
        entity.engilshName = englishName

        return entity
        
    }
}
