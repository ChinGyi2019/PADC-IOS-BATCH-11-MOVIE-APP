//
//  ActorDetailsResponse.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 06/07/2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let actorDetailsResponse = try? newJSONDecoder().decode(ActorDetailsResponse.self, from: jsonData)

import Foundation
import CoreData

// MARK: - ActorDetailsResponse
struct ActorDetailsResponse: Codable {
    let adult: Bool?
    let alsoKnownAs: [String]?
    let biography, birthday: String?
    let deathday: String?
    let gender: Int?
    let homepage: String?
    let id: Int?
    let imdbID, knownForDepartment, name, placeOfBirth: String?
    let popularity: Double?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography, birthday, deathday, gender, homepage, id
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
    
    func toActorEntity(context : NSManagedObjectContext) -> ActorEntity {
        let entity = ActorEntity(context: context)
        entity.id = Int32(id ?? 0)
        entity.adult = adult ?? false
        entity.gender = Int32(gender ?? 0)
        entity.popularity = popularity ?? 0.0
        entity.name = name
        entity.profilePath = profilePath
        entity.knownForDepartment = knownForDepartment
        entity.palceForBirth = placeOfBirth
        entity.biogrophy = biography
        entity.birthday = birthday
        entity.dethday = deathday
        entity.imdbID = imdbID
        entity.insertedAt = Date()
        entity.gender = Int32(gender ?? 0)
        entity.alsoKnownAs = alsoKnownAs.map{ $0}?.joined(separator: ",")
       
        
        return entity
    }
    
    
    
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

