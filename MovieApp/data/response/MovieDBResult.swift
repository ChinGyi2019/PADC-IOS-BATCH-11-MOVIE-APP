//
//  MovieDBResult.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 07/07/2021.
//

import Foundation


enum MovieDBResult<T> {
    case success(T)
    case failure(String)
}


