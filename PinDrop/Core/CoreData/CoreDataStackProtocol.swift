//
//  CoreDataStackProtocol.swift
//  PinDrop
//
//  Created by Ivan on 17.10.2026.
//

import Foundation

protocol CoreDataStackProtocol: AnyObject {
    
    func saveFavourite(_ place: Place, completion: @escaping (Result<Void, Error>) -> Void)
    
    func fetchFavourite(completion: @escaping (Result<[Place], Error>) -> Void )
}
