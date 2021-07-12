//
//  ActorDelegate.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 02/02/2021.
//

import Foundation


protocol ActorDelegate{
    
    func onTabFavourite(isSelected : Bool)
    
    func onTabLike(isLiked : Bool)
    
   
    
}

protocol ActorItemDelegate : class { //inherient class means purpose only for class
    func didTabActor(id : Int)
}
