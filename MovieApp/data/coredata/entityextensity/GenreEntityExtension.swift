//
//  EntityExtension.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 06/08/2021.
//

import Foundation

extension GenreEntitiy{
    
    static func toMovieGenre(entity : GenreEntitiy) -> MovieGenre {
        MovieGenre(id: Int(entity.id ?? "0") ?? 0, name: entity.name ?? "")
    }
    
}
