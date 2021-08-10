//
//  UpcommingMovieList.swift
//  Networking
//
//  Created by Van Za Lyan Htan on 21/06/2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let upcommingMovieList = try? newJSONDecoder().decode(UpcommingMovieList.self, from: jsonData)

import Foundation
import CoreData

// MARK: - UpcommingMovieList
struct MovieListResponse: Codable {
    let dates: Dates?
    let page: Int?
    let results: [MovieResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String?
}

// MARK: - Result
struct MovieResult: Codable, Hashable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle, originalName, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    @discardableResult
    func toMovieEntity(context : NSManagedObjectContext,
                       groupType : BelongToTypeEntitiy) -> MovieEntity {
        let entity = MovieEntity(context: context)
        entity.id = Int32(id ?? 0)
        entity.adult = adult ?? false
        entity.backdropPath = backdropPath
        entity.genreIDs = genreIDS?.map{ String($0) }.joined(separator: ",")
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
        entity.addToBelongToType(groupType)
        
        return entity
    }
    

}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case es = "es"
    case ja = "ja"
}



