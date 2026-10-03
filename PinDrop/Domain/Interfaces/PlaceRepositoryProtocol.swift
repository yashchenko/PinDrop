//
//  PlaceRepositoryProtocol.swift
//  PinDrop
//
//  Created by Ivan on 26.09.2026.
//

import CoreLocation

protocol PlaceRepositoryProtocol {
    
    func fetchNearByPlaces(coordinate: CLLocationCoordinate2D, comletion: @escaping (Result<[Place], LocationError>) -> Void)
}
