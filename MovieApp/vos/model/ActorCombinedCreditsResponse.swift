//
//  ActorCombinedCreditsResponse.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 06/07/2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let actorCombinedCreditsResponse = try? newJSONDecoder().decode(ActorCombinedCreditsResponse.self, from: jsonData)

import Foundation

// MARK: - ActorCombinedCreditsResponse
struct ActorCombinedCreditsResponse: Codable {
    let cast, crew: [MovieResult]?
    let id: Int?
}

// MARK: - Cast // No Need now
struct Credit: Codable {
    let video: Bool?
    let voteAverage: Double?
    let overview, releaseDate: String?
    let voteCount: Int?
    let adult: Bool?
    let backdropPath: String?
    let title: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let posterPath: String?
    let popularity: Double?
    let character, creditID: String?
    let order: Int?
    let mediaType: MediaType?
    let originalName: String?
    let originCountry: [String]?
    let name, firstAirDate: String?
    let episodeCount: Int?
    let department: String?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case video
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
        case voteCount = "vote_count"
        case adult
        case backdropPath = "backdrop_path"
        case title
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case popularity, character
        case creditID = "credit_id"
        case order
        case mediaType = "media_type"
        case originalName = "original_name"
        case originCountry = "origin_country"
        case name
        case firstAirDate = "first_air_date"
        case episodeCount = "episode_count"
        case department, job
    }
}

enum Department: String, Codable {
    case creator = "Creator"
    case directing = "Directing"
    case production = "Production"
    case writing = "Writing"
}

enum Job: String, Codable {
    case creator = "Creator"
    case director = "Director"
    case executiveProducer = "Executive Producer"
    case producer = "Producer"
    case writer = "Writer"
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}

enum OriginCountry: String, Codable {
    case ca = "CA"
    case de = "DE"
    case us = "US"
}



