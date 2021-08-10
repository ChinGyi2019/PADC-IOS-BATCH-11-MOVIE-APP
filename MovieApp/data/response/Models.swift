//
//  Models.swift
//  Networking
//
//  Created by Van Za Lyan Htan on 18/06/2021.
//

import Foundation
import CoreData

struct MovieGenreList : Codable {//Decodable aslo can be used but for covering both encoding & decoding process
    let genres : [MovieGenre]?
}
 struct MovieGenre : Codable {
   let  id : Int?
    let name : String?
    
    enum CodingKeys : String, CodingKey {
        case name 
        case id
    }
    
   public func convertToVOGenre() -> GenreVO {
        let vo = GenreVO(id: id ?? 0, name: name ?? "", isSelected: false)
        return vo
    }
    
    public func toGenreEntity(context : NSManagedObjectContext) -> GenreEntitiy {
        
        let entity = GenreEntitiy(context: context)
        entity.id = String(id ?? 0)
        entity.name = name
        
        return entity
     }
}

struct LoginSuccess : Codable{
    let success : Bool?
    let expiresAt : String?
    let requestToken : String?
    
    
    enum CodingKeys : String, CodingKey {
        case success
        case expiresAt  = "expires_at"
        case requestToken  = "request_token"
    }
}

struct LoginFailed : Codable {
    var success : Bool?
    var statusMessage : String?
    var statusCode : Int?
    
     enum CodingKeys : String, CodingKey  {
        case success
        case statusCode  = "status_code"
        case statusMessage  = "status_message"
        
    }
}

struct RequestTokenResponse : Codable {
    let success : Bool?
    let expiresAt : String?
    let requestToken : String?
    
    
    enum CodingKeys : String, CodingKey {
        case success
        case expiresAt  = "expires_at"
        case requestToken  = "request_token"
    }
}

struct UserLogin  : Codable{
    var userName : String?
    var password : String?
    var requestToken : String?
    
    enum CodingKeys : String, CodingKey {// CodingKeys <<<<--- Case Sensitive
        case userName = "username"
        case password = "password"
        case requestToken = "request_token"
        
    }
}
