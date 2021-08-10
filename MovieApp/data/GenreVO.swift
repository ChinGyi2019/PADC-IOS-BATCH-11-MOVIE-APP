//
//  GenreVO.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 30/01/2021.
//

import Foundation

class GenreVO{
    
    var id:Int = 0
    
    var name : String = "Action"
    
    var isSelected:Bool = false
    
    init(id:Int = 0, name : String, isSelected :Bool) {
        self.id = id
        self.isSelected = isSelected
        self.name = name
    }
}
