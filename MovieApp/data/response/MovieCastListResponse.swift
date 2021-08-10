//
//  MovieCastListResponse.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 05/07/2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieCastListResponse = try? newJSONDecoder().decode(MovieCastListResponse.self, from: jsonData)

import Foundation
import CoreData

// MARK: - MovieCastListResponse
struct MovieCastListResponse: Codable {
    let id: Int?
    let cast, crew: [Cast]?
}

// MARK: - Cast
struct Cast: Codable {
    let adult: Bool?
    let gender, id: Int?
    let knownForDepartment, name, originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castID: Int?
    let character, creditID: String?
    let order: Int?
    let department, job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
    
    func convertToActorInfo() -> ActorInfo {
        return ActorInfo(adult: self.adult ?? false,
                         gender: self.gender,
                         id: self.id,
                         knownFor: nil,
                         knownForDepartment: self.knownForDepartment,
                         name: self.name,
                         popularity: self.popularity,
                         profilePath: self.profilePath)
    }
    
    
    
   
   
}


