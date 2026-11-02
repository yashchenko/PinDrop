//
//  PlaceRepositoryProtocol.swift
//  PinDrop
//
//  Created by Ivan on 26.09.2026.
//

import CoreLocation

protocol PlaceRepositoryProtocol {
    
    func fetchNearByPlaces(coordinate: CLLocationCoordinate2D, comletion: @escaping (Result<[Place], LocationError>) -> Void)
    
    func saveFavourite(_ place: Place, completion: @escaping (Result<Void, Error>) -> Void)
    
    func deleteFavourite(id: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func fetchFavourites(completion: @escaping (Result<[Place], Error>) -> Void)
}
